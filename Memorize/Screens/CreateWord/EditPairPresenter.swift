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
                    DispatchQueue.main.async {
                        guard let weakSelf = self else { return }
                        
                        guard loadedImage.uiImage != nil else {
                            guard let newIndex = weakSelf.images.firstIndex(where: { $0 === cellData }) else { return }
                            weakSelf.images.remove(at: newIndex)
                            weakSelf.view.removeImage(at: newIndex)
                            return
                        }
                        
                        cellData.image = loadedImage.uiImage
                        weakSelf.view.show(images: weakSelf.images)
                    }
                })
            }
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
                    translationWord: String?,
                    reverseTranslationEnabled: Bool,
                    image: UIImage?) {
        
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
            
            translate(word: originalWord)
        }
    }
}
