//
//  Router.swift
//  Memorize
//
//  Created by Вика on 27/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

fileprivate extension UIViewController {
    func add(subViewController: UIViewController) {
        subViewController.view.frame = view.bounds
        
        subViewController.willMove(toParent: self)
        addChild(subViewController)
        view.addSubview(subViewController.view)
        subViewController.didMove(toParent: self)
    }
}

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
    
    func showCorrectAnswer(isCorrect: Bool, correctTranslation: String, didTapNextCallback: @escaping ()->()) {
        let subViewController = CorrectAnswerAssembly().create(isCorrect: isCorrect,
                                                               correctTranslation: correctTranslation,
                                                               didTapNextCallback: didTapNextCallback)
        rootNavigationController.viewControllers.last?.add(subViewController: subViewController)
    }
}
