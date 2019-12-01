//
//  ResultAssembly.swift
//  Memorize
//
//  Created by Вика on 01/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

class ResultAssembly {
    func create(translationPair: TranslationPair? = nil) -> UIViewController {
        let presenter = ResultPresenter()
        let viewController = ResultViewController(presenter: presenter)
        
        presenter.view = viewController
        
        return viewController
    }
}
