//
//  AllWordsPresenter.swift
//  Memorize
//
//  Created by Вика on 27/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

/// Презентер экрана всех слов
class AllWordsPresenter {
    /// Слабая ссылка на вью экрана всех слов
    weak var view: AllWordsViewInput!
    private var translationPairs = [TranslationPair]()
    private let coreData: CoreDataServiceProtocol
    
    init(coreData: CoreDataServiceProtocol) {
        self.coreData = coreData
    }
    
    private func fillAllTranslationPairs() {
        coreData.fetchTranslationPairs(of: .allPairs) { [weak self] in
            self?.translationPairs = $0
            self?.view.showPlaceholder(isHidden: !$0.isEmpty)
            self?.showAllPairs()
        }
    }
    
    private func showAllPairs() {
        let translationPairViewModels = translationPairs.map {
            return TranslationPairViewModel(originalWord: $0.originalWord,
                                     originalWordLanguage: $0.originalLanguage.rawValue,
                                     translatedWord: $0.translatedWord,
                                     translatedWordLanguage: $0.translatedLanguage.rawValue)
        }
        view.show(allWords: translationPairViewModels)
    }
    
    private func goToCreateScreen() {
        Router.shared.showCreatePair()
    }
}

extension AllWordsPresenter: AllWordsViewOutput {
    /// Удаляет слово из кордаты и показывает оповещение, если слов в таблице больше нет
    func didDelete(pair: TranslationPairViewModel, allPairsCount: Int) {
        coreData.deleteTranslationPair(originalWord: pair.originalWord) { }
        
        view.showPlaceholder(isHidden: allPairsCount != 0)
    }
    
    func viewDidLoad() { }
    
    /// Получает из кордаты все слова и показывает их; если слов нет, показывает оповещение
    func viewWillAppear() {
        fillAllTranslationPairs()
    }
    
    /// Направляет на экран создания слова
    func addButtonTapped() {
        goToCreateScreen()
    }
    
    /// Направляет на экран создания слова
    func createButtonTapped() {
        goToCreateScreen()
    }
    
    /// Направляет на экран редактирования слова
    func cellTapped(with pair: TranslationPairViewModel) {
        let translationPair = translationPairs.first { (translationPair) -> Bool in
            return translationPair.originalWord == pair.originalWord
        }
        guard let notNilPair = translationPair else {
            print("Невозможная ошибка: не найдена нужная пара в массиве всех слов")
            return
        }
        Router.shared.showEdit(translationPair: notNilPair)
    }
}
