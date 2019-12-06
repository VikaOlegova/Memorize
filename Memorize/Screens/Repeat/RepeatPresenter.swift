//
//  RepeatPresenter.swift
//  Memorize
//
//  Created by Вика on 27/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

class RepeatPresenter {
    weak var view: RepeatViewInput!
    
    var translationPairs: [TranslationPair]
    var currentTranslationPair: TranslationPair = TranslationPair.empty
    var mistakeCounter = 0
    var translationCounter = 0
    var showKeyboardWorkItem: DispatchWorkItem?
    let isMistakes: Bool
    
    init(isMistakes: Bool) {
        self.isMistakes = isMistakes
        translationPairs = isMistakes ? TranslationSession.shared.mistakes.shuffled() : TranslationSession.shared.repeatPairs
    }
    
    func showNextQuestion() -> Bool {
        guard translationCounter < translationPairs.count else { return false}
        
        currentTranslationPair = translationPairs[translationCounter]
        view.show(image: currentTranslationPair.image!)
        view.show(titleButton: "Показать перевод")
        view.show(originalWord: currentTranslationPair.originalWord)
        view.show(translationsCount: translationCounter + 1, from: translationPairs.count)
        view.show(fromToLanguage: currentTranslationPair.originalLanguage.fromTo(currentTranslationPair.translatedLanguage))
        
        if isMistakes {
            view.hideMistakes()
            view.show(title: "Исправление ошибок")
            view.showRightBarButtonItem(show: false)
        } else {
            view.show(mistakeCount: mistakeCounter)
            view.show(title: "Повторение")
            view.showRightBarButtonItem(show: true)
        }
        
        view.clearTextField()
        
        showKeyboardWorkItem = DispatchWorkItem(block: { [weak self] in
            self?.view.showKeyboard()
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: showKeyboardWorkItem!)
        
        translationCounter += 1
        return true
    }
    
    func showResultScreen() {
        Router.shared.showResult(resultScreenType: isMistakes ? .mistakesCorrectionEnded : .repeatingEnded(withMistakes: !TranslationSession.shared.mistakes.isEmpty))
    }
}

extension RepeatPresenter: RepeatViewOutput {
    func viewDidLoad() {
        _ = showNextQuestion()
    }
    
    func textFieldChanged(textIsEmpty: Bool) {
        if textIsEmpty {
            view.show(titleButton: "Показать перевод")
        } else {
            view.show(titleButton: "OK")
        }
    }
    
    func didEnterTranslation(_ enteredTranslation: String) {
        showKeyboardWorkItem?.cancel()
        let isCorrect = currentTranslationPair.translatedWord.lowercased() == enteredTranslation.lowercased()
        if !isMistakes {
            TranslationSession.shared.addAnsweredPair(pair: currentTranslationPair)
            TranslationSession.shared.removeFirstPairFromRepeatPairs()
            if !isCorrect {
                mistakeCounter += 1
                TranslationSession.shared.addMistake(mistake: currentTranslationPair)
            }
        }
        Router.shared.showCorrectAnswer(isCorrect: isCorrect,
                                        correctTranslation: currentTranslationPair.translatedWord) { [weak self] in
                                            guard let weakSelf = self else { return }
                                            if weakSelf.isMistakes, !isCorrect {
                                                weakSelf.translationCounter = 0
                                                weakSelf.translationPairs = TranslationSession.shared.mistakes.shuffled()
                                            }
                                            if !weakSelf.showNextQuestion() {
                                                weakSelf.showResultScreen()
                                            }
        }
    }
    
    func playAudioTapped() {
        
    }
    
    func didOpenKeyboard() {
        showKeyboardWorkItem?.cancel()
    }
    
    func didTapRightBarButtonItem() {
        showKeyboardWorkItem?.cancel()
        showResultScreen()
    }
    
    func viewWillAppear() {
        if !isMistakes {
            mistakeCounter = TranslationSession.shared.mistakes.count
            view.show(mistakeCount: mistakeCounter)
        }
    }
}
