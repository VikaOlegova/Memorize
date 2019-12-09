//
//  TranslationPairViewModel.swift
//  Memorize
//
//  Created by Вика on 26/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import Foundation

/// Модель данных для ячейки таблицы экрана со всеми словами
class TranslationPairViewModel {
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
}
