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
}

extension MainMenuPresenter: MainMenuViewOutput {
    func viewDidLoad() {
        TranslationSession.shared.load()
        view.show(allWordsCount: 100)
    }
    
    func viewWillAppear() {
        //TranslationSession.shared.load()
        view.show(repeatWordsCount: TranslationSession.shared.repeatPairs.count)
    }
    
    func repeatWordsButtonTapped() {
        guard !TranslationSession.shared.repeatPairs.isEmpty else {
            view.showNoWordsAllert()
            return
        }
        Router.shared.showRepeat(isMistakes: false)
    }
    
    func allWordsButtonTapped() {
        Router.shared.showAllWords()
    }
}
