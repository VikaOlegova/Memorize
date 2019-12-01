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
    let translationPairs: [TranslationPair] = [TranslationPair(originalWord: "Яблоко", translatedWord: "Apple", originalLanguage: .RU, translatedLanguage: .EN, image: UIImage(named: "night"), rightAnswersStreakCounter: 0, nextShowDate: Date()),
    TranslationPair(originalWord: "Ручка", translatedWord: "Pen", originalLanguage: .RU, translatedLanguage: .EN, image: UIImage(named: "checked"), rightAnswersStreakCounter: 0, nextShowDate: Date()),
    TranslationPair(originalWord: "Cucumber", translatedWord: "Огурец", originalLanguage: .EN, translatedLanguage: .RU, image: UIImage(named: "unchecked"), rightAnswersStreakCounter: 0, nextShowDate: Date())]
    
    var currentTranslationPair: TranslationPair = TranslationPair.empty
    var mistakeCounter = 0
    var mistakes = [TranslationPair]()
    var translationCounter = 0
    var showKeyboardWorkItem: DispatchWorkItem?
    
    func showNextQuestion() -> Bool {
        guard translationCounter < translationPairs.count else { return false}
        
        currentTranslationPair = translationPairs[translationCounter]
        view.show(image: currentTranslationPair.image!)
        view.show(titleButton: "Показать перевод")
        view.show(mistakeCount: mistakeCounter)
        view.show(originalWord: currentTranslationPair.originalWord)
        view.show(translationsCount: translationCounter + 1, from: translationPairs.count)
        view.show(fromToLanguage: currentTranslationPair.originalLanguage.fromTo(currentTranslationPair.translatedLanguage))
        view.clearTextField()
        
        showKeyboardWorkItem = DispatchWorkItem(block: { [weak self] in
            self?.view.showKeyboard()
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: showKeyboardWorkItem!)
        
        translationCounter += 1
        return true
    }
    
    func showResultScreen() {
        if mistakes.isEmpty {
            Router.shared.showResult(words: translationPairs, resultScreenType: .repeatingEnded(withMistakes: false))
        } else {
            Router.shared.showResult(words: mistakes, resultScreenType: .repeatingEnded(withMistakes: true))
        }
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
        if !isCorrect {
            mistakeCounter += 1
            mistakes.append(currentTranslationPair)
        }
        Router.shared.showCorrectAnswer(isCorrect: isCorrect,
                                        correctTranslation: currentTranslationPair.translatedWord) { [weak self] in
                                            guard let weakSelf = self else { return }
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
}
