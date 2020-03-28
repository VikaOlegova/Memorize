//
//  CorrectAnswerAssembly.swift
//  Memorize
//
//  Created by Вика on 29/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

/// Собирает все зависимости для экрана с оценкой правильности ответа
class CorrectAnswerAssembly {
    func create(
        isCorrect: Bool,
        correctTranslation: String,
        correctTranslationLanguage: Language,
        didTapNextCallback: @escaping ()->()
        ) -> UIViewController {
        let presenter = CorrectAnswerPresenter(
            isCorrect: isCorrect,
            correctTranslation: correctTranslation,
            correctTranslationLanguage: correctTranslationLanguage,
            didTapNextCallback: didTapNextCallback
        )
        let viewController = CorrectAnswerViewController(presenter: presenter)
        
        presenter.view = viewController
        
        return viewController
    }
}
