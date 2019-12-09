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
    weak var view: MainMenuViewInput!
    private var repeatWordsCount = 0
    private let coreData: CoreDataServiceProtocol
    
    init(coreData: CoreDataServiceProtocol) {
        self.coreData = coreData
    }
}

extension MainMenuPresenter: MainMenuViewOutput {
    func viewDidLoad() { }
    
    /// Загружает и отображает количество всех слов и слов для повторения
    func viewWillAppear() {
        coreData.countOfTranslationPairs(of: .allPairs) { [weak self] allWordsCount in
            self?.view.show(allWordsCount: allWordsCount)
        }
        coreData.countOfTranslationPairs(of: .repeatPairs) { [weak self] repeatWordsCount in
            self?.repeatWordsCount = repeatWordsCount
            self?.view.show(repeatWordsCount: repeatWordsCount)
        }
    }
    
    /// Направляет на экран повторения, предварительно загрузив слова, или показывает алерт, если слов нет
    func repeatWordsButtonTapped() {
        guard repeatWordsCount != 0 else {
            view.showNoWordsAlert()
            return
        }
        view.enableInteraction(false)
        RepeatingSession.shared.resetMistakes()
        RepeatingSession.shared.resetAnsweredPairs()
        RepeatingSession.shared.load { [weak self] in
            Router.shared.showRepeat(isMistakes: false)
            self?.view.enableInteraction(true)
        }
    }
    
    /// Направляет на экран со всеми словами
    func allWordsButtonTapped() {
        Router.shared.showAllWords()
    }
}
