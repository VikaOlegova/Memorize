//
//  TranslationSession.swift
//  Memorize
//
//  Created by Вика on 01/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

class TranslationSession {
    static let shared = TranslationSession()
    
    private(set) var mistakes = [TranslationPair]()
    private(set) var repeatPairs = [TranslationPair]()
    private(set) var answeredPairs = [TranslationPair]()
    
    private init() { }
    
    func load() {
        // загружает из кор даты
        repeatPairs = [TranslationPair(originalWord: "Яблоко", translatedWord: "Apple", originalLanguage: .RU, translatedLanguage: .EN, image: UIImage(named: "night"), rightAnswersStreakCounter: 0, nextShowDate: Date()),
                                  TranslationPair(originalWord: "Ручка", translatedWord: "Pen", originalLanguage: .RU, translatedLanguage: .EN, image: UIImage(named: "checked"), rightAnswersStreakCounter: 0, nextShowDate: Date()),
                                  TranslationPair(originalWord: "Cucumber", translatedWord: "Огурец", originalLanguage: .EN, translatedLanguage: .RU, image: UIImage(named: "unchecked"), rightAnswersStreakCounter: 0, nextShowDate: Date()),
                                  TranslationPair(originalWord: "Курица", translatedWord: "Chicken", originalLanguage: .RU, translatedLanguage: .EN, image: UIImage(named: "night"), rightAnswersStreakCounter: 0, nextShowDate: Date()),
                                  TranslationPair(originalWord: "Солнце", translatedWord: "Sun", originalLanguage: .RU, translatedLanguage: .EN, image: UIImage(named: "checked"), rightAnswersStreakCounter: 0, nextShowDate: Date()),
                                  TranslationPair(originalWord: "Свинья", translatedWord: "Pig", originalLanguage: .RU, translatedLanguage: .EN, image: UIImage(named: "unchecked"), rightAnswersStreakCounter: 0, nextShowDate: Date())]
    }
    
    func addMistake(mistake: TranslationPair) {
        mistakes.append(mistake)
    }
    
    func addAnsweredPair(pair: TranslationPair) {
        answeredPairs.append(pair)
    }
    
    func reset() {
        mistakes.removeAll()
        repeatPairs.removeAll()
    }
}
