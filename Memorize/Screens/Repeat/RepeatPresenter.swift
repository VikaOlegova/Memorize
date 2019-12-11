//
//  RepeatPresenter.swift
//  Memorize
//
//  Created by Вика on 27/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit
import AVFoundation

class RepeatPresenter {
    weak var view: RepeatViewInput!
    
    private var translationPairs: [TranslationPair]
    private var currentTranslationPair: TranslationPair = TranslationPair.empty
    private var mistakeCounter = 0
    private var translationCounter = 0
    private var showKeyboardWorkItem: DispatchWorkItem?
    private let isMistakes: Bool
    private let synthesizer = AVSpeechSynthesizer()
    
    private let coreData = CoreDataService()
    
    init(isMistakes: Bool) {
        self.isMistakes = isMistakes
        translationPairs = isMistakes ? TranslationSession.shared.mistakes.shuffled() : TranslationSession.shared.repeatPairs
    }
    
    private func showNextQuestion() -> Bool {
        guard translationCounter < translationPairs.count else { return false}
        
        currentTranslationPair = translationPairs[translationCounter]
        view.show(image: currentTranslationPair.image)
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
    
    private func showResultScreen() {
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
        synthesizer.stopSpeaking(at: .immediate)
        let isCorrect = currentTranslationPair.translatedWord.lowercased().replacingOccurrences(of: "ё", with: "е") == enteredTranslation.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "ё", with: "е")
        if !isMistakes {
            TranslationSession.shared.addAnsweredPair(pair: currentTranslationPair)
            TranslationSession.shared.removeFirstPairFromRepeatPairs()
            coreData.updateCounterAndDate(originalWord: currentTranslationPair.originalWord,
                                          translatedWord: currentTranslationPair.translatedWord,
                                          isMistake: !isCorrect) { }
            if !isCorrect {
                mistakeCounter += 1
                TranslationSession.shared.addMistake(mistake: currentTranslationPair)
            }
        }
        Router.shared.showCorrectAnswer(isCorrect: isCorrect,
                                        correctTranslation: currentTranslationPair.translatedWord,
                                        correctTranslationLanguage: currentTranslationPair.translatedLanguage) { [weak self] in
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
        guard !synthesizer.isSpeaking else {
            synthesizer.stopSpeaking(at: .immediate)
            return
        }
        let utterance = AVSpeechUtterance(string: currentTranslationPair.originalWord)
        var language = ""
        switch currentTranslationPair.originalLanguage {
        case .RU:
            language = "ru-RU"
        case .EN:
            language = "en-US"
        }
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = 0.3
        
        synthesizer.speak(utterance)
    }
    
    func didOpenKeyboard() {
        showKeyboardWorkItem?.cancel()
    }
    
    func didTapRightBarButtonItem() {
        showKeyboardWorkItem?.cancel()
        synthesizer.stopSpeaking(at: .immediate)
        showResultScreen()
    }
    
    func viewWillAppear() {
        if !isMistakes {
            mistakeCounter = TranslationSession.shared.mistakes.count
            view.show(mistakeCount: mistakeCounter)
        }
    }
}
