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
        view.show(allWordsCount: 100)
        view.show(repeatWordsCount: 25)
    }
    
    func repeatWordsButtonTapped() {
        Router.shared.showRepeat()
    }
    
    func allWordsButtonTapped() {
        Router.shared.showAllWords()
    }
}
