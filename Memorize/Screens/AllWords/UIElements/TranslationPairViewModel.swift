//
//  TranslationPairViewModel.swift
//  Memorize
//
//  Created by Вика on 26/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import Foundation

class TranslationPairViewModel {
    let firstWord: String
    let firstWordLanguage: String
    let secondWord: String
    let secondWordLanguage: String
    
    init(firstWord: String, firstWordLanguage: String, secondWord: String, secondWordLanguage: String) {
        self.firstWord = firstWord
        self.firstWordLanguage = firstWordLanguage
        self.secondWord = secondWord
        self.secondWordLanguage = secondWordLanguage
    }
}
