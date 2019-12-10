//
//  Router.swift
//  Memorize
//
//  Created by Вика on 27/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

private extension UIViewController {
    func add(subViewController: UIViewController) {
        subViewController.view.frame = view.bounds
        
        subViewController.willMove(toParent: self)
        addChild(subViewController)
        view.addSubview(subViewController.view)
        subViewController.didMove(toParent: self)
    }
}

/// Класс, управляющий переходами между экранами
class Router {
    static let shared = Router()
    
    private let rootNavigationController = UINavigationController()
    
    private init() { }
    
    /// Показывает экран главного меню
    func start() -> UINavigationController {
        rootNavigationController.setViewControllers([MainMenuAssembly().create()], animated: false)
        return rootNavigationController
    }
    
    /// Показывает экран со всеми созданными слова
    func showAllWords() {
        rootNavigationController.pushViewController(AllWordsAssembly().create(), animated: true)
    }
    
    /// Показывает экран повторения или экран исправления ошибок в зависимости от передаваемого параметра
    ///
    /// - Parameter isMistakes: true, если экран для исправления ошибок, false, если для повторения
    func showRepeat(isMistakes: Bool) {
        rootNavigationController.pushViewController(RepeatAssembly().create(isMistakes: isMistakes), animated: true)
    }
    
    /// Показывает экран создания слова
    func showCreatePair() {
        rootNavigationController.pushViewController(EditPairAssembly().create(), animated: true)
    }
    
    /// Показывает экран редактирования слова
    ///
    /// - Parameter translationPair: слово для редактирования
    func showEdit(translationPair: TranslationPair) {
        rootNavigationController.pushViewController(EditPairAssembly().create(translationPair: translationPair), animated: true)
    }
    
    /// Показывает экран с оценкой правильности ответа
    ///
    /// - Parameters:
    ///   - isCorrect: был введен корректный перевод или нет
    ///   - correctTranslation: корректный перевод
    ///   - correctTranslationLanguage: язык перевода
    ///   - didTapNextCallback: оповещает о нажатии на кнопку Далее
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
    
    /// Показывает экран результата повторения или исправления ошибок в зависимости от параметра
    ///
    /// - Parameter resultScreenType: тип экрана результата: конец повторения с ошибками или без или конец исправления ошибок
    func showResult(resultScreenType: ResultScreenType) {
        let newVC = ResultAssembly().create(resultScreenType: resultScreenType)
        
        switch resultScreenType {
        case .repeatingEnded:
            if !RepeatingSession.shared.repeatPairs.isEmpty {
                rootNavigationController.pushViewController(newVC,
                                                            animated: true)
                return
            }
        default:
            break
        }
        pushReplacingLast(with: newVC)
    }
    
    /// Закрывает экран результата
    func closeResult() {
        rootNavigationController.popViewController(animated: true)
    }
    
    /// Возвращает на главное меню
    func returnToMainMenu() {
        rootNavigationController.popToRootViewController(animated: true)
    }
    
    /// Показывает экран исправления ошибок
    func showMistakes() {
        let newVC = RepeatAssembly().create(isMistakes: true)
        pushReplacingLast(with: newVC)
    }
    
    /// Возвращает на предыдущий экран
    func returnBack(completion: (()->())? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            completion?()
        }
        rootNavigationController.popViewController(animated: true)
        
        CATransaction.commit()
    }
    
    /// Показывает алерт
    ///
    /// - Parameter title: заголвок алерта
    func showAlert(title: String, completion: (() -> ())? = nil) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "ОК", style: .default, handler: { _ in
            completion?()
        }))
        rootNavigationController.topViewController?.present(alertController, animated: true, completion: nil)
    }
}
