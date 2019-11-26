//
//  Router.swift
//  Memorize
//
//  Created by Вика on 27/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

class Router {
    static let shared = Router()
    
    private let rootNavigationController = UINavigationController()
    
    private init() { }
    
    func start() -> UINavigationController {
        rootNavigationController.setViewControllers([MainMenuAssembly().create()], animated: false)
        return rootNavigationController
    }
    
    func showAllWords() {
        rootNavigationController.pushViewController(AllWordsViewController(), animated: true)
    }
}
