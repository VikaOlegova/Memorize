//
//  CorrectAnswerPresenter.swift
//  Memorize
//
//  Created by Вика on 29/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

class CorrectAnswerPresenter {
    weak var view: CorrectAnswerPopViewInput!
    let isCorrect: Bool
    let correctTranslation: String
    let repeatPresenter: RepeatPresenter
    
    init(isCorrect: Bool, correctTranslation: String, repeatPresenter: RepeatPresenter) {
        self.isCorrect = isCorrect
        self.correctTranslation = correctTranslation
        self.repeatPresenter = repeatPresenter
    }
}

extension CorrectAnswerPresenter: CorrectAnswerPopViewOutput {
    func viewDidLoad() {
        view.showPopView(for: isCorrect)
        view.show(correctTranslation: correctTranslation)
    }
    
    func playAudioTapped() {
        
    }
    
    func nextButtonTapped() {
        repeatPresenter.showNextQuestion()
    }
}
