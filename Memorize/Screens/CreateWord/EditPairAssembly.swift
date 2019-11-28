//
//  EditPairAssembly.swift
//  Memorize
//
//  Created by Вика on 27/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

class EditPairAssembly {
    func create(translationPair: TranslationPair? = nil) -> UIViewController {
        let presenter = EditPairPresenter()
        let viewController = EditPairViewController(presenter: presenter)
        
        presenter.view = viewController
        if let pair = translationPair {
            presenter.edit(translationPair: pair)
        }
        
        return viewController
    } 
}
