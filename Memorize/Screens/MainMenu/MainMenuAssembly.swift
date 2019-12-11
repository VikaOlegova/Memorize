//
//  MainMenuAssembly.swift
//  Memorize
//
//  Created by Вика on 27/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

/// Собирает все зависимости для экрана главного меню
class MainMenuAssembly {
    func create() -> UIViewController {
        let coreData = CoreDataService()
        let presenter = MainMenuPresenter(coreData: coreData,
                                          router: Router.shared,
                                          session: RepeatingSession.shared)
        let viewController = MainMenuViewController(presenter: presenter)
        
        presenter.view = viewController
        
        return viewController
    }
}
