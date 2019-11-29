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
    var translationCounter = 0
    
    func showNextQuestion() {
        translationCounter += 1
        guard translationCounter < translationPairs.count else { return }
        view.clearTextField()
        viewDidLoad()
    }
}

extension RepeatPresenter: RepeatViewOutput {
    func viewDidLoad() {
        currentTranslationPair = translationPairs[translationCounter]
        view.show(image: currentTranslationPair.image!)
        view.show(titleButton: "Показать перевод")
        view.show(mistakeCount: mistakeCounter)
        view.show(originalWord: currentTranslationPair.originalWord)
        view.show(translationsCount: translationCounter + 1, from: translationPairs.count)
        view.show(fromToLanguage: currentTranslationPair.originalLanguage.fromTo(currentTranslationPair.translatedLanguage))
    }
    
    func textFieldChanged(textIsEmpty: Bool) {
        guard textIsEmpty else {
            view.show(titleButton: "OK")
            return
        }
        view.show(titleButton: "Показать перевод")
    }
    
    func greenButtonTapped(enteredTranslation: String) {
        let isCorrect = currentTranslationPair.translatedWord.lowercased() == enteredTranslation.lowercased()
        if !isCorrect {
            mistakeCounter += 1
        }
        let popViewController = Router.shared.showCorrectAnswer(isCorrect: isCorrect, correctTranslation: currentTranslationPair.translatedWord, repeatPresenter: self)
        view.show(popViewController: popViewController)
    }
    
    func playAudioTapped() {
        
    }
}
