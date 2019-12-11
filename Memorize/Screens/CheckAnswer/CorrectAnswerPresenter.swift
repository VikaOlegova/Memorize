//
//  CorrectAnswerPresenter.swift
//  Memorize
//
//  Created by Вика on 29/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit
import AVFoundation

class CorrectAnswerPresenter {
    weak var view: CorrectAnswerPopupViewInput!
    private let isCorrect: Bool
    private let correctTranslation: String
    private let correctTranslationLanguage: Language
    private let synthesizer = AVSpeechSynthesizer()
    private let didTapNextCallback: (() -> ())
    
    init(isCorrect: Bool, correctTranslation: String,
         correctTranslationLanguage: Language,
         didTapNextCallback: @escaping ()->()) {
        self.isCorrect = isCorrect
        self.correctTranslation = correctTranslation
        self.didTapNextCallback = didTapNextCallback
        self.correctTranslationLanguage = correctTranslationLanguage
    }
}

extension CorrectAnswerPresenter: CorrectAnswerPopupViewOutput {
    func viewDidLoad() {
        view.setupUI(forCorrectAnswer: isCorrect)
        view.show(correctTranslation: correctTranslation)
    }
    
    func playAudioTapped() {
        guard !synthesizer.isSpeaking else {
            synthesizer.stopSpeaking(at: .immediate)
            return
        }
        let utterance = AVSpeechUtterance(string: correctTranslation)
        var language = ""
        switch correctTranslationLanguage {
        case .RU:
            language = "ru-RU"
        case .EN:
            language = "en-US"
        }
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = 0.3
        
        synthesizer.speak(utterance)
    }
    
    func nextButtonTapped() {
        synthesizer.stopSpeaking(at: .immediate)
        didTapNextCallback()
    }
}
