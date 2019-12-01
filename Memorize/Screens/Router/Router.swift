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
    
    func showRepeat(isMistakes: Bool) {
        rootNavigationController.pushViewController(RepeatAssembly().create(isMistakes: isMistakes), animated: true)
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
    
    func showResult(resultScreenType: ResultScreenType) {
        rootNavigationController.pushViewController(ResultAssembly().create(resultScreenType: resultScreenType), animated: true)
    }
    
    func closeResult() {
        rootNavigationController.popViewController(animated: true)
    }
    
    func returnToMainMenu() {
        rootNavigationController.popToRootViewController(animated: true)
    }
    
    func showMistakes() {
        var viewControllers = rootNavigationController.viewControllers
        viewControllers.removeLast()
        viewControllers.append(RepeatAssembly().create(isMistakes: true))
        rootNavigationController.setViewControllers(viewControllers, animated: true)
    }
}
