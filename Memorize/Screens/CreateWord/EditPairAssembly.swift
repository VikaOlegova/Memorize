//
//  EditPairAssembly.swift
//  Memorize
//
//  Created by Вика on 27/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

class EditPairAssembly {
    func create(translationPair: TranslationPair? = nil) -> UIViewController {
        let coreData = CoreDataService()
        let networkService = NetworkService()
        let googleImageService = GoogleImageService(networkService: networkService)
        let yandexTranslateService = YandexTranslateService()
        let presenter = EditPairPresenter(coreData: coreData,
                                          googleImageService: googleImageService,
                                          translateService: yandexTranslateService)
        let viewController = EditPairViewController(presenter: presenter)
        
        presenter.view = viewController
        if let pair = translationPair {
            presenter.edit(translationPair: pair)
        }
        
        return viewController
    } 
}
