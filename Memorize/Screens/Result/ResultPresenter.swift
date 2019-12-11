//
//  ResultPresenter.swift
//  Memorize
//
//  Created by Вика on 01/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

/// Тип экрана результата
///
/// - repeatingEnded: конец повторения
/// - mistakesCorrectionEnded: конец исправления ошибок
enum ResultScreenType {
    case repeatingEnded(withMistakes: Bool)
    case mistakesCorrectionEnded
}

/// Презентер экрана результата
class ResultPresenter {
    /// Слабая ссылка на вью экрана результата
    weak var view: ResultViewInput?
    private let words: [TranslationPair]
    private let resultScreenType: ResultScreenType
    private let repeatingSession: RepeatingSessionProtocol
    private let router: RouterProtocol
    
    init(resultScreenType: ResultScreenType,
         repeatingSession: RepeatingSessionProtocol,
         router: RouterProtocol) {
        self.resultScreenType = resultScreenType
        self.repeatingSession = repeatingSession
        self.router = router
        
        switch resultScreenType {
        case .repeatingEnded(withMistakes: false):
            words = self.repeatingSession.answeredPairs
        case .repeatingEnded(withMistakes: true):
            words = self.repeatingSession.mistakes
        case .mistakesCorrectionEnded:
            words = self.repeatingSession.mistakes
            self.repeatingSession.resetMistakes()
        }
    }
    
    private func fillView() {
        var viewModels = [ResultViewModel]()
        let image: UIImage
        
        switch resultScreenType {
        case .repeatingEnded(withMistakes: true):
            image = UIImage(named: "wrong")!
            view?.show(title: "Ошибки")
            view?.show(textButton: "Исправить ошибки")
        case .repeatingEnded(withMistakes: false):
            image = UIImage(named: "right")!
            view?.show(title: "Повторение")
            view?.show(textButton: "OK")
        case .mistakesCorrectionEnded:
            image = UIImage(named: "right")!
            view?.show(title: "Ошибки")
            view?.show(textButton: "OK")
        }
            
        words.forEach { (word) in
            viewModels.append(ResultViewModel(word: word.originalWord, image: image))
        }
        view?.show(allWords: viewModels)
    }
}

extension ResultPresenter: ResultViewOutput {
    /// Производит переход на нужный экран
    func didTapGreenButton() {
        switch resultScreenType {
        case .repeatingEnded(withMistakes: true):
            router.showMistakes()
        default:
            repeatingSession.repeatPairs.isEmpty ? router.returnToMainMenu() : router.closeResult()
        }
    }
    
    /// Заполняет вьюху нужными данными
    func viewDidLoad() {
        fillView()
    }
}
