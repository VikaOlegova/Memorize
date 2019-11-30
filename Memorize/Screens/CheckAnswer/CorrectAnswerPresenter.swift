//
//  CorrectAnswerPresenter.swift
//  Memorize
//
//  Created by Вика on 29/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

class CorrectAnswerPresenter {
    weak var view: CorrectAnswerPopupViewInput!
    let isCorrect: Bool
    let correctTranslation: String
    let didTapNextCallback: (() -> ())
    
    init(isCorrect: Bool, correctTranslation: String, didTapNextCallback: @escaping ()->()) {
        self.isCorrect = isCorrect
        self.correctTranslation = correctTranslation
        self.didTapNextCallback = didTapNextCallback
    }
}

extension CorrectAnswerPresenter: CorrectAnswerPopupViewOutput {
    func viewDidLoad() {
        view.setupUI(forCorrectAnswer: isCorrect)
        view.show(correctTranslation: correctTranslation)
    }
    
    func playAudioTapped() {
        
    }
    
    func nextButtonTapped() {
        didTapNextCallback()
    }
}
