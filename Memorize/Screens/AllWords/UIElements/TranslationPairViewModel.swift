//
//  TranslationPairViewModel.swift
//  Memorize
//
//  Created by Вика on 26/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import Foundation

/// Модель данных для ячейки таблицы экрана со всеми словами
class TranslationPairViewModel: Equatable {
    /// Слово
    let originalWord: String
    
    /// Язык слова
    let originalWordLanguage: String
    
    /// Перевод слова
    let translatedWord: String
    
    /// Язык перевода слова
    let translatedWordLanguage: String
    
    init(originalWord: String, originalWordLanguage: String, translatedWord: String, translatedWordLanguage: String) {
        self.originalWord = originalWord
        self.originalWordLanguage = originalWordLanguage
        self.translatedWord = translatedWord
        self.translatedWordLanguage = translatedWordLanguage
    }
    
    static func == (lhs: TranslationPairViewModel, rhs: TranslationPairViewModel) -> Bool {
        return lhs.originalWord == rhs.originalWord &&
            lhs.originalWordLanguage == rhs.originalWordLanguage &&
            lhs.translatedWord == rhs.translatedWord &&
            lhs.translatedWordLanguage == rhs.translatedWordLanguage
    }
}
