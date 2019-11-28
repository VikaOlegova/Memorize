//
//  EditPairPresenter.swift
//  Memorize
//
//  Created by Вика on 27/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

class EditPairPresenter {
    weak var view: EditPairViewInput!
    private var translationPair: TranslationPair?
    
    func edit(translationPair: TranslationPair) {
        self.translationPair = translationPair
    }
}

extension EditPairPresenter: EditPairViewOutput {
    func viewDidLoad() {
        let newPair = translationPair == nil
        if newPair {
            translationPair = .empty
        }
        guard let pair = translationPair else { return }
        
        view.showWords(original: pair.originalWord, translation: pair.translatedWord, reverseTranslationCheckBox: newPair)
        view.show(image: pair.image)
        view.show(languageInfo: pair.originalLanguage.fromTo(pair.translatedLanguage))
        view.show(reverseTranslationEnabled: true)
        view.show(title: newPair ? "Создать" : "Редактировать")
    }
    
    func saveTapped(originalWord: String?, translationWord: String?, reverseTranslationEnabled: Bool) {
        
    }
}
