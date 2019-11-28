//
//  TranslationPair.swift
//  Memorize
//
//  Created by Вика on 27/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

enum Language: String {
    case RU
    case EN
    
    func fromTo(_ other: Language) -> String {
        return "\(self) -> \(other)"
    }
}

class TranslationPair {
    var originalWord: String
    var translatedWord: String
    var originalLanguage: Language
    var translatedLanguage: Language
    var image: UIImage?
    var rightAnswersStreakCounter: Int
    var nextShowDate: Date
    
    static var empty: TranslationPair {
        return TranslationPair(originalWord: "", translatedWord: "", originalLanguage: .EN, translatedLanguage: .RU)
    }
    
    init(originalWord: String,
         translatedWord: String,
         originalLanguage: Language,
         translatedLanguage: Language,
         image: UIImage? = nil,
         rightAnswersStreakCounter: Int = 0,
         nextShowDate: Date = Date()) {
        
        self.originalWord = originalWord
        self.translatedWord = translatedWord
        self.originalLanguage = originalLanguage
        self.translatedLanguage = translatedLanguage
        self.image = image
        self.rightAnswersStreakCounter = rightAnswersStreakCounter
        self.nextShowDate = nextShowDate
    }
}
