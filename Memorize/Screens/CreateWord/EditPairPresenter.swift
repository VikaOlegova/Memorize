//
//  EditPairPresenter.swift
//  Memorize
//
//  Created by Вика on 27/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

/// Презентер экрана создания\редактирования слова
class EditPairPresenter {
    /// Слабая ссылка на вью экрана создания\редактирования слова
    weak var view: EditPairViewInput?
    private var translationPair: TranslationPair?
    private var isCreating = true
    private var fromLanguage: Language = .EN
    private var toLanguage: Language = .RU
    private var images = [ImageCollectionViewCellData]()
    private let coreData: CoreDataServiceProtocol
    private let imageService: ImageServiceProtocol
    private let translateService: TranslateServiceProtocol
    
    init(coreData: CoreDataServiceProtocol,
         imageService: ImageServiceProtocol,
         translateService: TranslateServiceProtocol) {
        self.coreData = coreData
        self.imageService = imageService
        self.translateService = translateService
    }
    
    /// Заполняет данные о пришедшем слове для редактирования
    ///
    /// - Parameter translationPair: слово для редактирования
    func edit(translationPair: TranslationPair) {
        self.translationPair = translationPair
        fromLanguage = translationPair.originalLanguage
        toLanguage = translationPair.translatedLanguage
        isCreating = false
    }
    
    private func translate(word: String) {
        view?.showLoadingIndicator(true)
        translateService.translate(text: word, from: fromLanguage, to: toLanguage) { [weak self] results in
            guard let weakSelf = self, let translation = results.first else { return }
            
            weakSelf.view?.show(translation: translation)
            weakSelf.view?.showLoadingIndicator(false)
        }
    }
    
    private func reloadImages(text: String) {
        images = Array(repeating: (), count: 10).map { ImageCollectionViewCellData.loading }
        view?.show(images: images)
        
        imageService.loadImageList(searchString: text) { [weak self] imagesToLoad in
            self?.images = Array(repeating: (), count: imagesToLoad.count).map { ImageCollectionViewCellData.loading }
            self?.view?.show(images: self?.images ?? [])
            
            for (index, imageToLoad) in imagesToLoad.enumerated() {
                let cellData = self?.images[index]
                
                self?.imageService.loadImage(for: imageToLoad, completion: { loadedImage in
                    guard loadedImage.uiImage != nil else {
                        guard let newIndex = self?.images.firstIndex(where: { $0 === cellData }) else { return }
                        self?.images.remove(at: newIndex)
                        self?.view?.removeImage(at: newIndex)
                        return
                    }
                    
                    cellData?.image = loadedImage.uiImage
                    self?.view?.show(images: self?.images ?? [])
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
        coreData.checkExistenceOfTranslationPair(originalWord: originalWord) { [weak self] isExisting in
            if isExisting {
                self?.view?.showAlert(title: "Такое слово уже существует!")
                completion(false)
            } else {
                self?.coreData.saveNewTranslationPair(originalWord: originalWord,
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
        coreData.updateTranslationPair(oldOriginalWord: pair.originalWord,
                                       newOriginalWord: originalWord,
                                       newTranslatedWord: translatedWord,
                                       image: image,
                                       completion: completion)
    }
}

extension EditPairPresenter: EditPairViewOutput {
    /// Заполняет вьюху данными
    func viewDidLoad() {
        if isCreating {
            translationPair = .empty
        }
        guard let pair = translationPair else { return }
        
        if !isCreating, let image = pair.image {
            view?.show(images: [ImageCollectionViewCellData(image: image)])
        }
        
        view?.show(originalWord: pair.originalWord, reverseTranslationCheckBox: isCreating)
        view?.show(translation: pair.translatedWord)
        view?.show(languageInfo: pair.originalLanguage.fromTo(pair.translatedLanguage))
        view?.show(reverseTranslationEnabled: true)
        view?.show(title: isCreating ? "Создать" : "Редактировать")
    }
    
    /// Сохраняет новое слово или изменения в старом
    func saveTapped(originalWord: String?,
                    translatedWord: String?,
                    reverseTranslationEnabled: Bool,
                    image: UIImage?) {
        guard let originalWord = originalWord,
                let translatedWord = translatedWord,
                !originalWord.isEmpty,
                !translatedWord.isEmpty else {
            view?.showAlert(title: "Вы заполнили не все обязательные поля!")
            return
        }
        
        view?.enableGreenButton(enable: false)
        let completion = { [weak self] (goBack: Bool) in
            self?.view?.enableGreenButton(enable: true)
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
                                completion: { [weak self] saved in
                                    guard let weakSelf = self else { return }
                                    guard reverseTranslationEnabled, saved else {
                                        completion(saved)
                                        return
                                    }
                                    weakSelf.saveTranslationPair(originalWord: translatedWord,
                                                        translatedWord: originalWord,
                                                        originalLanguage: weakSelf.toLanguage,
                                                        translatedLanguage: weakSelf.fromLanguage,
                                                        image: image,
                                                        completion: completion)
            })
        } else {
            updateTranslationPair(originalWord: originalWord,
                                  translatedWord: translatedWord,
                                  image: image,
                                  completion: { completion(true) })
        }
    }
    
    /// Переводит слово и обновляет изображение по слову
    func didChange(originalWord: String) {
        translate(word: originalWord)
        reloadImages(text: originalWord)
    }
    
    /// Изменяет направление перевода и обновляет перевод слова
    func didTapFromToButton(with originalWord: String) {
        if isCreating {
            let temp = fromLanguage
            fromLanguage = toLanguage
            toLanguage = temp
            view?.show(languageInfo: fromLanguage.fromTo(toLanguage))
            
            if !originalWord.isEmpty {
                translate(word: originalWord)
            }
        }
    }
}
