//
//  CreateWordPresenter.swift
//  Memorize
//
//  Created by Вика on 27/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

class CreateWordPresenter {
    weak var view: CreateWordViewInput!
}

extension CreateWordPresenter: CreateWordViewOutput {
    func viewDidLoad() {
        view.showWords(original: "Яблоко", translation: "Apple")
        view.show(image: UIImage(named: "checked")!)
        view.show(languageInfo: "RU -> EN")
        view.show(reverseTranslationEnabled: false)
    }
    
    func saveTapped(originalWord: String?, translationWord: String?, reverseTranslationEnabled: Bool) {
        
    }
}
