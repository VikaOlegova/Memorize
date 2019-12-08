//
//  AllWordsPresenter.swift
//  Memorize
//
//  Created by Вика on 27/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

class AllWordsPresenter {
    weak var view: AllWordsViewInput!
    var translationPairs = [TranslationPair]()
    
    private func fillAllTranslationPairs() {
        let coreData = CoreDataService()
        coreData.fetchTranslationPairs(of: .allPairs) { [weak self] in
            self?.translationPairs = $0
            self?.showAllPairs()
        }
    }
    
    private func showAllPairs() {
        let translationPairViewModels = translationPairs.map {
            return TranslationPairViewModel(firstWord: $0.originalWord,
                                     firstWordLanguage: $0.originalLanguage.rawValue,
                                     secondWord: $0.translatedWord,
                                     secondWordLanguage: $0.translatedLanguage.rawValue)
        }
        view.show(allWords: translationPairViewModels)
    }
}

extension AllWordsPresenter: AllWordsViewOutput {
    func viewDidLoad() { }
    
    func viewWillAppear() {
        fillAllTranslationPairs()
    }
    
    func addButtonTapped() {
        Router.shared.showCreatePair()
    }
    
    func cellTapped(with pair: TranslationPairViewModel) {
        let translationPair = translationPairs.first { (translationPair) -> Bool in
            return translationPair.originalWord == pair.firstWord && translationPair.translatedWord == pair.secondWord
        }
        guard let notNilPair = translationPair else {
            print("Невозможная ошибка: не найдена нужная пара в массиве всех слов")
            return
        }
        Router.shared.showEdit(translationPair: notNilPair)
    }
}
