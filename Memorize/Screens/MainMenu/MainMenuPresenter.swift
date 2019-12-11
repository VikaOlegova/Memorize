//
//  MainMenuPresenter.swift
//  Memorize
//
//  Created by Вика on 27/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import Foundation

/// Презентер экрана главного меню
class MainMenuPresenter {
    /// Слабая ссылка на вью экрана главного меню
    weak var view: MainMenuViewInput?
    var repeatWordsCount = 0
    var allWordsCount = 0
    private let coreData: CoreDataServiceProtocol
    private weak var router: RouterProtocol?
    private weak var session: RepeatingSessionProtocol?
    
    init(coreData: CoreDataServiceProtocol,
         router: RouterProtocol,
         session: RepeatingSessionProtocol) {
        self.coreData = coreData
        self.router = router
        self.session = session
    }
}

extension MainMenuPresenter: MainMenuViewOutput {
    func viewDidLoad() { }
    
    /// Загружает и отображает количество всех слов и слов для повторения
    func viewWillAppear() {
        coreData.countOfTranslationPairs(of: .allPairs) { [weak self] allWordsCount in
            self?.allWordsCount = allWordsCount
            self?.view?.show(allWordsCount: allWordsCount)
        }
        coreData.countOfTranslationPairs(of: .repeatPairs) { [weak self] repeatWordsCount in
            self?.repeatWordsCount = repeatWordsCount
            self?.view?.show(repeatWordsCount: repeatWordsCount)
        }
    }
    
    /// Направляет на экран повторения, предварительно загрузив слова, или показывает алерт, если слов нет
    func repeatWordsButtonTapped() {
        guard repeatWordsCount != 0 else {
            guard allWordsCount != 0 else {
                router?.showAlert(title: "Сначала добавьте слова;)", completion: { [weak self] in
                    self?.router?.showCreatePair()
                })
                return
            }
            router?.showAlert(title: "На сегодня все!", completion: nil)
            return
        }
        view?.enableInteraction(false)
        session?.resetMistakes()
        session?.resetAnsweredPairs()
        session?.load { [weak self] in
            self?.router?.showRepeat(isMistakes: false)
            self?.view?.enableInteraction(true)
        }
    }
    
    /// Направляет на экран со всеми словами
    func allWordsButtonTapped() {
        router?.showAllWords()
    }
}
