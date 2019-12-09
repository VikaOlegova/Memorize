//
//  ResultViewModel.swift
//  Memorize
//
//  Created by Вика on 01/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

/// Модель данных для ячейки таблицы экрана результата
class ResultViewModel {
    /// Слово
    let word: String
    /// Иконка, говорящая о корректности\некорректности перевода слова при ответе
    let image: UIImage
    
    init(word: String, image: UIImage) {
        self.word = word
        self.image = image
    }
}
