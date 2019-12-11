//
//  AllWordsAssembly.swift
//  Memorize
//
//  Created by Вика on 27/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

/// Собирает все зависимости для экрана всех слов
class AllWordsAssembly {
    func create() -> UIViewController {
        let coreData = CoreDataService()
        let presenter = AllWordsPresenter(coreData: coreData, router: Router.shared)
        let viewController = AllWordsViewController(presenter: presenter)
        
        presenter.view = viewController
        
        return viewController
    }
}
