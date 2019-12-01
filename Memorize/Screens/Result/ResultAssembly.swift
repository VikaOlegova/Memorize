//
//  ResultAssembly.swift
//  Memorize
//
//  Created by Вика on 01/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

class ResultAssembly {
    func create(words: [TranslationPair], resultScreenType: ResultScreenType) -> UIViewController {
        let presenter = ResultPresenter(words: words, resultScreenType: resultScreenType)
        let viewController = ResultViewController(presenter: presenter)
        
        presenter.view = viewController
        
        return viewController
    }
}
