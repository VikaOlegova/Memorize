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
    let translationPairs: [TranslationPair] = [TranslationPair(originalWord: "Яблоко", translatedWord: "Apple", originalLanguage: .RU, translatedLanguage: .EN, image: UIImage(named: "night"), rightAnswersStreakCounter: 0, nextShowDate: Date()),
                                               TranslationPair(originalWord: "Ручка", translatedWord: "Pen", originalLanguage: .RU, translatedLanguage: .EN, image: UIImage(named: "checked"), rightAnswersStreakCounter: 0, nextShowDate: Date()),
                                               TranslationPair(originalWord: "Cucumber", translatedWord: "Огурец", originalLanguage: .EN, translatedLanguage: .RU, image: UIImage(named: "unchecked"), rightAnswersStreakCounter: 0, nextShowDate: Date())]
}

extension AllWordsPresenter: AllWordsViewOutput {
    func viewDidLoad() {
        var translationPairViewModels = [TranslationPairViewModel]()
        for pair in translationPairs {
            translationPairViewModels.append(TranslationPairViewModel(firstWord: pair.originalWord, secondWord: pair.translatedWord))
        }
        view.show(allWords: translationPairViewModels)
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
