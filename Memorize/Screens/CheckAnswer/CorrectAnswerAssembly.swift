//
//  CorrectAnswerAssembly.swift
//  Memorize
//
//  Created by Вика on 29/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

class CorrectAnswerAssembly {
    func create(isCorrect: Bool, correctTranslation: String, repeatPresenter: RepeatPresenter) -> UIViewController {
        let presenter = CorrectAnswerPresenter(isCorrect: isCorrect,
                                               correctTranslation: correctTranslation,
                                               repeatPresenter: repeatPresenter)
        let viewController = CorrectAnswerPopViewController(presenter: presenter)
        
        presenter.view = viewController
        
        return viewController
    }
}
