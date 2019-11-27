//
//  AllWordsPresenter.swift
//  Memorize
//
//  Created by Вика on 27/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import Foundation

class AllWordsPresenter {
    weak var view: AllWordsViewInput!
}

extension AllWordsPresenter: AllWordsViewOutput {
    func viewDidLoad() {
        view.show(allWords: [TranslationPairViewModel(firstWord: "Яблоко ЯблокоЯблоко ЯблокоЯблоко Яблоко ЯблокоЯблоко",
                                                      secondWord: "Apple  ЯблокоЯблоко ЯблокоЯблоко Яблоко ЯблокоЯблоко"),
                             TranslationPairViewModel(firstWord: "Ручка", secondWord: "Pen"),
                             TranslationPairViewModel(firstWord: "Лягушка", secondWord: "Frog"),
                             TranslationPairViewModel(firstWord: "Лошадь", secondWord: "Horse")])
    }
    
    func addButtonTapped() {
        Router.shared.showCreateWord()
    }
    
    func cellTapped(with pair: TranslationPairViewModel) {
        
    }
}
