//
//  CreateWordAssembly.swift
//  Memorize
//
//  Created by Вика on 27/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

class CreateWordAssembly {
    func create() -> UIViewController {
        let presenter = CreateWordPresenter()
        let viewController = CreateWordViewController(presenter: presenter)
        
        presenter.view = viewController
        
        return viewController
    }
    
}
