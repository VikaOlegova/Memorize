//
//  ResultPresenter.swift
//  Memorize
//
//  Created by Вика on 01/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

class ResultPresenter {
    weak var view: ResultViewInput!
    let words = [TranslationPair]()
    
    func fillResultViewModel(image: UIImage) {
        
    }
    
    func fillView(isRepeatingEnd: Bool, haveMistakes: Bool) {
        var viewModels = [ResultViewModel]()
        let image: UIImage
        
        if isRepeatingEnd {
            if haveMistakes {
                image = UIImage(named: "wrong")!
                view.show(title: "Ошибки")
                view.show(textButton: "Исправить ошибки")
            } else {
                image = UIImage(named: "right")!
                view.show(title: "Повторение")
                view.show(textButton: "OK")
            }
        } else {
            image = UIImage(named: "right")!
            view.show(title: "Ошибки")
            view.show(textButton: "OK")
        }
            
        words.forEach { (word) in
            viewModels.append(ResultViewModel(word: word.originalWord, image: image))
        }
        view.show(allWords: viewModels)
    }
}

extension ResultPresenter: ResultViewOutput {
    func didTapGreenButton() {
        
    }
    
    func viewDidLoad() {
        fillView(isRepeatingEnd: true, haveMistakes: false)
    }
}
