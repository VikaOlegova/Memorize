//
//  TranslationPair.swift
//  Memorize
//
//  Created by Вика on 27/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

/// Язык
///
/// - RU: русский
/// - EN: английский
enum Language: String {
    case RU
    case EN
    
    /// Генерирует строку типа RU -> EN
    ///
    /// - Parameter other: второй язык
    /// - Returns: сгенерированная строка
    func fromTo(_ other: Language) -> String {
        return "\(self) -> \(other)"
    }
}

/// Слово с переводом
class TranslationPair: Equatable {
    /// Слово
    var originalWord: String
    
    /// Перевод слова
    var translatedWord: String
    
    /// Язык слова
    var originalLanguage: Language
    
    /// Язык перевода слова
    var translatedLanguage: Language
    
    /// Изображение к слову
    var image: UIImage?
    
    static var empty: TranslationPair {
        return TranslationPair(originalWord: "", translatedWord: "", originalLanguage: .EN, translatedLanguage: .RU)
    }
    
    init(originalWord: String,
         translatedWord: String,
         originalLanguage: Language,
         translatedLanguage: Language,
         image: UIImage? = nil) {
        
        self.originalWord = originalWord
        self.translatedWord = translatedWord
        self.originalLanguage = originalLanguage
        self.translatedLanguage = translatedLanguage
        self.image = image
    }
    
    static func == (lhs: TranslationPair, rhs: TranslationPair) -> Bool {
        return lhs.originalWord == rhs.originalWord &&
            lhs.originalLanguage == rhs.originalLanguage &&
            lhs.translatedWord == rhs.translatedWord &&
            lhs.translatedLanguage == lhs.translatedLanguage
    }
}
