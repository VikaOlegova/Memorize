//
//  RepeatPresenter.swift
//  Memorize
//
//  Created by Вика on 27/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

class RepeatPresenter {
    weak var view: RepeatViewInput!
}

extension RepeatPresenter: RepeatViewOutput {
    func viewDidLoad() {
        view.show(image: UIImage(named: "night")!)
        view.show(titleButton: "Показать перевод")
        view.show(mistakeCount: 0)
        view.show(originalWord: "Яблоко")
        view.show(translationsCount: 1, from: 19)
    }
    
    func textFieldChanged(textIsEmpty: Bool) {
        guard textIsEmpty else {
            view.show(titleButton: "OK")
            return
        }
        view.show(titleButton: "Показать перевод")
    }
    
    func greenButtonTapped(enteredTranslation: String) {
        
    }
}
