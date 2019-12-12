//
//  MainMenuPresenter.swift
//  Memorize
//
//  Created by Вика on 27/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import Foundation

class MainMenuPresenter {
    weak var view: MainMenuViewInput!
    private var repeatWordsCount = 0
}

extension MainMenuPresenter: MainMenuViewOutput {
    func viewDidLoad() { }
    
    func viewWillAppear() {
        let coreData = CoreDataService()
        coreData.countOfTranslationPairs(of: .allPairs) { [weak self] allWordsCount in
            self?.view.show(allWordsCount: allWordsCount)
        }
        coreData.countOfTranslationPairs(of: .repeatPairs) { [weak self] repeatWordsCount in
            self?.repeatWordsCount = repeatWordsCount
            self?.view.show(repeatWordsCount: repeatWordsCount)
        }
    }
    
    func repeatWordsButtonTapped() {
        guard repeatWordsCount != 0 else {
            view.showNoWordsAllert()
            return
        }
        view.enableInteraction(false)
        RepeatingSession.shared.load { [weak self] in
            Router.shared.showRepeat(isMistakes: false)
            self?.view.enableInteraction(true)
        }
    }
    
    func allWordsButtonTapped() {
        Router.shared.showAllWords()
    }
}
