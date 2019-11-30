//
//  CorrectAnswerAssembly.swift
//  Memorize
//
//  Created by Вика on 29/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

class CorrectAnswerAssembly {
    func create(isCorrect: Bool, correctTranslation: String, didTapNextCallback: @escaping ()->()) -> UIViewController {
        let presenter = CorrectAnswerPresenter(isCorrect: isCorrect,
                                               correctTranslation: correctTranslation,
                                               didTapNextCallback: didTapNextCallback)
        let viewController = CorrectAnswerViewController(presenter: presenter)
        
        presenter.view = viewController
        
        return viewController
    }
}
