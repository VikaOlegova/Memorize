//
//  RepeatAssembly.swift
//  Memorize
//
//  Created by Вика on 27/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

/// Собирает все зависимости для экрана повторения\исправления ошибок
class RepeatAssembly {
    func create(isMistakes: Bool) -> UIViewController {
        let coreData = CoreDataService()
        let presenter = RepeatPresenter(coreData: coreData, isMistakes: isMistakes)
        let viewController = RepeatViewController(presenter: presenter)
        
        presenter.view = viewController
        
        return viewController
    }
}
