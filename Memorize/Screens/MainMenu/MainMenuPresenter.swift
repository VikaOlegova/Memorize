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
        view.show(repeatWordsCount: TranslationSession.shared.repeatPairs.count - TranslationSession.shared.answeredPairs.count)
    }
    
    func viewWillAppear() {
        //TranslationSession.shared.load()
    }
    
    func repeatWordsButtonTapped() {
        Router.shared.showRepeat(isMistakes: false)
    }
    
    func allWordsButtonTapped() {
        Router.shared.showAllWords()
    }
}
