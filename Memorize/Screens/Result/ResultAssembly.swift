//
//  ResultAssembly.swift
//  Memorize
//
//  Created by Вика on 01/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

/// Собирает все зависимости для экрана результата
class ResultAssembly {
    func create(resultScreenType: ResultScreenType) -> UIViewController {
        let presenter = ResultPresenter(resultScreenType: resultScreenType,
                                        repeatingSession: RepeatingSession.shared,
                                        router: Router.shared)
        let viewController = ResultViewController(presenter: presenter)
        
        presenter.view = viewController
        
        return viewController
    }
}
