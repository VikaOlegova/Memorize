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
        isEditing = true
    }
}

extension EditPairPresenter: EditPairViewOutput {
    func viewDidLoad() {
        let newPair = translationPair == nil
        if newPair {
            translationPair = .empty
        }
        guard let pair = translationPair else { return }
        
        view.show(originalWord: pair.originalWord, reverseTranslationCheckBox: newPair)
        view.show(translation: pair.translatedWord)
        view.show(image: pair.image)
        view.show(languageInfo: pair.originalLanguage.fromTo(pair.translatedLanguage))
        view.show(reverseTranslationEnabled: true)
        view.show(title: newPair ? "Создать" : "Редактировать")
    }
    
    func saveTapped(originalWord: String?, translationWord: String?, reverseTranslationEnabled: Bool) {
        
    }
    
    func translate(original: String) {
        view.showLoadingIndicator(true)
        let translateService = YandexTranslateService()
        translateService.translate(text: original, from: .EN, to: .RU) { [weak self] results in
            guard let weakSelf = self else { return }
            
            var translation = ""
            results.forEach({ (word) in
                translation += word
            })
            
            weakSelf.view.show(translation: translation)
            weakSelf.view.showLoadingIndicator(false)
        }
    }
}
