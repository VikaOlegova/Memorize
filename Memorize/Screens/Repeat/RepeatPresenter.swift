//
//  RepeatPresenter.swift
//  Memorize
//
//  Created by Вика on 27/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit
import AVFoundation

/// Презентер экрана повторения\заучивания ошибок
class RepeatPresenter {
    /// Слабая ссылка на вью экрана повторения\заучивания ошибок
    weak var view: RepeatViewInput?
    
    private var translationPairs: [TranslationPair]
    private var currentTranslationPair = TranslationPair.empty
    private var mistakeCounter = 0
    private var translationCounter = 0
    private var showKeyboardWorkItem: DispatchWorkItem?
    private let isMistakes: Bool
    private let synthesizer = AVSpeechSynthesizer()
    
    let coreData: CoreDataServiceProtocol
    private let repeatingSession: RepeatingSessionProtocol
    private let router: RouterProtocol
    
    init(
        coreData: CoreDataServiceProtocol,
        repeatingSession: RepeatingSessionProtocol,
        router: RouterProtocol,
        isMistakes: Bool
        ) {
        self.coreData = coreData
        self.repeatingSession = repeatingSession
        self.router = router
        self.isMistakes = isMistakes
        if !isMistakes {
            self.repeatingSession.shuffleRepeatPairs()
        }
        translationPairs = isMistakes ? self.repeatingSession.mistakes.shuffled() : self.repeatingSession.repeatPairs
    }
    
    private func showNextQuestion() -> Bool {
        guard translationCounter < translationPairs.count else { return false}
        
        currentTranslationPair = translationPairs[translationCounter]
        view?.show(image: currentTranslationPair.image)
        view?.show(titleButton: "Показать перевод")
        view?.show(originalWord: currentTranslationPair.originalWord)
        view?.show(translationsCount: translationCounter + 1, from: translationPairs.count)
        view?.show(fromToLanguage: currentTranslationPair.originalLanguage.fromTo(currentTranslationPair.translatedLanguage))
        
        if isMistakes {
            view?.hideMistakes()
            view?.show(title: "Исправление ошибок")
            view?.showRightBarButtonItem(show: false)
        } else {
            view?.show(mistakeCount: mistakeCounter)
            view?.show(title: "Повторение")
            view?.showRightBarButtonItem(show: true)
        }
        
        view?.clearTextField()
        
        showKeyboardWorkItem = DispatchWorkItem(block: { [weak self] in
            self?.view?.showKeyboard()
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: showKeyboardWorkItem!)
        
        translationCounter += 1
        return true
    }
    
    private func showResultScreen() {
        router.showResult(resultScreenType: isMistakes ? .mistakesCorrectionEnded : .repeatingEnded(withMistakes: !repeatingSession.mistakes.isEmpty))
    }
}

extension RepeatPresenter: RepeatViewOutput {
    /// Показывает вопрос
    func viewDidLoad() {
        _ = showNextQuestion()
    }
    
    /// Меняет текст зеленой кнопки
    func textFieldChanged(textIsEmpty: Bool) {
        if textIsEmpty {
            view?.show(titleButton: "Показать перевод")
        } else {
            view?.show(titleButton: "OK")
        }
    }
    
    /// Проверяет, является ли корректным введенный перевод, и в зависимости от этого открывает нужный экран
    func didEnterTranslation(_ enteredTranslation: String) {
        showKeyboardWorkItem?.cancel()
        synthesizer.stopSpeaking(at: .immediate)
        let isCorrect = currentTranslationPair.translatedWord.isAlmostEqual(to: enteredTranslation)
        if !isMistakes {
            repeatingSession.add(answeredPair: currentTranslationPair)
            repeatingSession.removeFirstPairFromRepeatPairs()
            coreData.updateCounterAndDate(
                originalWord: currentTranslationPair.originalWord,
                isMistake: !isCorrect
            ) { }
            if !isCorrect {
                mistakeCounter += 1
                repeatingSession.add(mistake: currentTranslationPair)
            }
        }
        router.showCorrectAnswer(
            isCorrect: isCorrect,
            correctTranslation: currentTranslationPair.translatedWord,
            correctTranslationLanguage: currentTranslationPair.translatedLanguage
        ) { [weak self] in
            guard let self = self else { return }
            if self.isMistakes, !isCorrect {
                self.translationCounter = 0
                self.translationPairs = self.repeatingSession.mistakes.shuffled()
            }
            if !self.showNextQuestion() {
                self.showResultScreen()
            }
        }
    }
    
    /// Воспроизводит слово, которое нужно перевести
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
    
    /// Отменяет автоматическое открытие клавиатуры
    func didOpenKeyboard() {
        showKeyboardWorkItem?.cancel()
    }
    
    /// Отменяет автоматическое открытие клавиатуры, останавливает чтение слова и переходит на экран результата
    func didTapRightBarButtonItem() {
        showKeyboardWorkItem?.cancel()
        synthesizer.stopSpeaking(at: .immediate)
        showResultScreen()
    }
    
    /// Обновляет счетчик ошибок
    func viewWillAppear() {
        if !isMistakes {
            mistakeCounter = repeatingSession.mistakes.count
            view?.show(mistakeCount: mistakeCounter)
        }
    }
}
