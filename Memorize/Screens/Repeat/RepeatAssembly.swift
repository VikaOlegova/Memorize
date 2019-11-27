//
//  RepeatAssembly.swift
//  Memorize
//
//  Created by Вика on 27/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

class RepeatAssembly {
    func create() -> UIViewController {
        let presenter = RepeatPresenter()
        let viewController = RepeatViewController(presenter: presenter)
        
        presenter.view = viewController
        
        return viewController
    }
}
