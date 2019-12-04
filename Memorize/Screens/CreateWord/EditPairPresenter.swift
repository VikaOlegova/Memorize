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
    var isCreating = true
    var fromLanguage: Language = .EN
    var toLanguage: Language = .RU
    var images = [UIImage]()
    
    func edit(translationPair: TranslationPair) {
        self.translationPair = translationPair
        fromLanguage = translationPair.originalLanguage
        toLanguage = translationPair.translatedLanguage
        isCreating = false
    }
    
    private func translate(word: String) {
        view.showLoadingIndicator(true)
        let translateService = YandexTranslateService()
        translateService.translate(text: word, from: fromLanguage, to: toLanguage) { [weak self] results in
            guard let weakSelf = self else { return }
            
            guard let translation = results.first else { return }
            
            weakSelf.view.show(translation: translation)
            weakSelf.view.showLoadingIndicator(false)
        }
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
        
        //view.show(image: pair.image)
        view.show(images: [UIImage(named: "night")!, UIImage(named: "checked")!, UIImage(named: "wrong")!, UIImage(named: "audio")!, UIImage(named: "unchecked")!, UIImage(named: "right")!])
        
        view.show(languageInfo: pair.originalLanguage.fromTo(pair.translatedLanguage))
        view.show(reverseTranslationEnabled: true)
        view.show(title: newPair ? "Создать" : "Редактировать")
    }
    
    func saveTapped(originalWord: String?, translationWord: String?, reverseTranslationEnabled: Bool) {
        
    }
    
    func didChange(originalWord: String) {
        translate(word: originalWord)
    }
    
    func didTapFromToButton(with originalWord: String) {
        if isCreating {
            let temp = fromLanguage
            fromLanguage = toLanguage
            toLanguage = temp
            view.show(languageInfo: fromLanguage.fromTo(toLanguage))
            
            translate(word: originalWord)
        }
    }
}
