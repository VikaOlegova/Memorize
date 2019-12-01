//
//  ResultPresenter.swift
//  Memorize
//
//  Created by Вика on 01/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

enum ResultScreenType {
    case repeatingEnded(withMistakes: Bool)
    case mistakesCorrectionEnded
}

class ResultPresenter {
    weak var view: ResultViewInput!
    let words: [TranslationPair]
    let resultScreenType: ResultScreenType
    
    init(words: [TranslationPair], resultScreenType: ResultScreenType) {
        self.words = words
        self.resultScreenType = resultScreenType
    }
    
    func fillView() {
        var viewModels = [ResultViewModel]()
        let image: UIImage
        
        switch resultScreenType {
        case .repeatingEnded(withMistakes: true):
            image = UIImage(named: "wrong")!
            view.show(title: "Ошибки")
            view.show(textButton: "Исправить ошибки")
        case .repeatingEnded(withMistakes: false):
            image = UIImage(named: "right")!
            view.show(title: "Повторение")
            view.show(textButton: "OK")
        case .mistakesCorrectionEnded:
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
        fillView()
    }
}
