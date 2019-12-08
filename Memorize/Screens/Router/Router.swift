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
    
    func showCorrectAnswer(isCorrect: Bool,
                           correctTranslation: String,
                           correctTranslationLanguage: Language,
                           didTapNextCallback: @escaping ()->()) {
        let subViewController = CorrectAnswerAssembly().create(isCorrect: isCorrect,
                                                               correctTranslation: correctTranslation,
                                                               correctTranslationLanguage: correctTranslationLanguage,
                                                               didTapNextCallback: didTapNextCallback)
        rootNavigationController.viewControllers.last?.add(subViewController: subViewController)
    }
    
    private func pushReplacingLast(with viewController: UIViewController) {
        var viewControllers = rootNavigationController.viewControllers
        viewControllers.removeLast()
        viewControllers.append(viewController)
        rootNavigationController.setViewControllers(viewControllers, animated: true)
    }
    
    func showResult(resultScreenType: ResultScreenType) {
        let newVC = ResultAssembly().create(resultScreenType: resultScreenType)
        
        switch resultScreenType {
        case .repeatingEnded:
            if !TranslationSession.shared.repeatPairs.isEmpty {
                rootNavigationController.pushViewController(newVC,
                                                            animated: true)
                return
            }
        default:
            break
        }
        pushReplacingLast(with: newVC)
    }
    
    func closeResult() {
        rootNavigationController.popViewController(animated: true)
    }
    
    func returnToMainMenu() {
        rootNavigationController.popToRootViewController(animated: true)
    }
    
    func showMistakes() {
        let newVC = RepeatAssembly().create(isMistakes: true)
        pushReplacingLast(with: newVC)
    }
    
    func returnBack() {
        rootNavigationController.popViewController(animated: true)
    }
}
