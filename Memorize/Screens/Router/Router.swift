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
        rootNavigationController.pushViewController(AllWordsAssembly().create(), animated: true)
    }
    
    func showRepeat() {
        rootNavigationController.pushViewController(RepeatAssembly().create(), animated: true)
    }
    
    func showCreatePair() {
        rootNavigationController.pushViewController(EditPairAssembly().create(), animated: true)
    }
    
    func showEdit(translationPair: TranslationPair) {
        rootNavigationController.pushViewController(EditPairAssembly().create(translationPair: translationPair), animated: true)
    }
}
