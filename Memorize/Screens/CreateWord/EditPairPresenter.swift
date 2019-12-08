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
    let googleImageService = GoogleImageService()
    var images = [ImageCollectionViewCellData]()
    
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
    
    private func reloadImages(text: String) {
        images = Array(repeating: (), count: 10).map { ImageCollectionViewCellData() }
        view.show(images: images)
        
        googleImageService.loadImageList(searchString: text) { [weak self] imagesToLoad in
            guard let weakSelf = self else { return }
            
            weakSelf.images = Array(repeating: (), count: imagesToLoad.count).map { ImageCollectionViewCellData() }
            weakSelf.view.show(images: weakSelf.images)
            
            for (index, imageToLoad) in imagesToLoad.enumerated() {
                guard let weakSelf = self else { return }
                
                let cellData = weakSelf.images[index]
                
                self?.googleImageService.loadImage(for: imageToLoad, completion: { loadedImage in
                    guard let weakSelf = self else { return }
                    
                    guard loadedImage.uiImage != nil else {
                        guard let newIndex = weakSelf.images.firstIndex(where: { $0 === cellData }) else { return }
                        weakSelf.images.remove(at: newIndex)
                        weakSelf.view.removeImage(at: newIndex)
                        return
                    }
                    
                    cellData.image = loadedImage.uiImage
                    weakSelf.view.show(images: weakSelf.images)
                })
            }
        }
    }
    
    private func saveTranslationPair(originalWord: String,
                                     translatedWord: String,
                                     originalLanguage: Language,
                                     translatedLanguage: Language,
                                     image: UIImage?,
                                     completion: @escaping (_ saved: Bool)->()) {
        let coreData = CoreDataService()
        coreData.checkExistenceOfTranslationPair(originalWord: originalWord,
                                                 translatedWord: translatedWord) { [weak self] isExisting in
            if isExisting {
                self?.view.showAlert(title: "Такая пара уже существует!")
                completion(false)
            } else {
                coreData.saveNewTranslationPair(originalWord: originalWord,
                                                translatedWord: translatedWord,
                                                originalLanguage: originalLanguage,
                                                translatedLanguage: translatedLanguage,
                                                image: image,
                                                completion: { completion(true) })
            }
        }
    }
    
    private func updateTranslationPair(originalWord: String,
                                       translatedWord: String,
                                       image: UIImage?,
                                       completion: @escaping ()->()) {
        guard let pair = translationPair else { return }
        let coreData = CoreDataService()
        coreData.updateTranslationPair(oldOriginalWord: pair.originalWord,
                                       oldTranslatedWord: pair.translatedWord,
                                       newOriginalWord: originalWord,
                                       newTranslatedWord: translatedWord,
                                       image: image,
                                       completion: completion)
    }
}

extension EditPairPresenter: EditPairViewOutput {
    func viewDidLoad() {
        let newPair = translationPair == nil
        if newPair {
            translationPair = .empty
        }
        guard let pair = translationPair else { return }
        
        if !isCreating {
            view.show(images: [ImageCollectionViewCellData(image: pair.image)])
        }
        
        view.show(originalWord: pair.originalWord, reverseTranslationCheckBox: newPair)
        view.show(translation: pair.translatedWord)
        view.show(languageInfo: pair.originalLanguage.fromTo(pair.translatedLanguage))
        view.show(reverseTranslationEnabled: true)
        view.show(title: newPair ? "Создать" : "Редактировать")
    }
    
    func saveTapped(originalWord: String?,
                    translatedWord: String?,
                    reverseTranslationEnabled: Bool,
                    image: UIImage?) {
        guard let originalWord = originalWord, let translatedWord = translatedWord else {
            view.showAlert(title: "Вы заполнили не все обязательные поля!")
            return
        }
        
        view.enableGreenButton(enable: false)
        let completion = { [weak self] (goBack: Bool) in
            self?.view.enableGreenButton(enable: true)
            if goBack {
                Router.shared.returnBack()
            }
        }
        
        if isCreating {
            saveTranslationPair(originalWord: originalWord,
                                translatedWord: translatedWord,
                                originalLanguage: fromLanguage,
                                translatedLanguage: toLanguage,
                                image: image,
                                completion: { completion(!reverseTranslationEnabled && $0) })
            
            if reverseTranslationEnabled {
                saveTranslationPair(originalWord: translatedWord,
                                    translatedWord: originalWord,
                                    originalLanguage: toLanguage,
                                    translatedLanguage: fromLanguage,
                                    image: image,
                                    completion: { completion($0) })
            }
        } else {
            updateTranslationPair(originalWord: originalWord,
                                  translatedWord: translatedWord,
                                  image: image,
                                  completion: { completion(true) })
        }
    }
    
    func didChange(originalWord: String) {
        translate(word: originalWord)
        reloadImages(text: originalWord)
    }
    
    func didTapFromToButton(with originalWord: String) {
        if isCreating {
            let temp = fromLanguage
            fromLanguage = toLanguage
            toLanguage = temp
            view.show(languageInfo: fromLanguage.fromTo(toLanguage))
            
            if !originalWord.isEmpty {
                translate(word: originalWord)
            }
        }
    }
}
