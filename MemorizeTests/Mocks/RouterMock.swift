//
//  RouterMock.swift
//  MemorizeTests
//
//  Created by Вика on 11/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit
import XCTest

class RouterMock: RouterProtocol {
    func start() -> UINavigationController {
        fatalError()
    }
    
    var showAllWordsCounter = 0
    func showAllWords() {
        showAllWordsCounter += 1
    }
    
    var showRepeatArguments = [Bool]()
    func showRepeat(isMistakes: Bool) {
        showRepeatArguments.append(isMistakes)
    }
    
    var showCreatePairCounter = 0
    func showCreatePair() {
        showCreatePairCounter += 1
    }
    
    func showEdit(translationPair: TranslationPair) {
        fatalError()
    }
    
    func showCorrectAnswer(isCorrect: Bool, correctTranslation: String, correctTranslationLanguage: Language, didTapNextCallback: @escaping () -> ()) {
        fatalError()
    }
    
    func showResult(resultScreenType: ResultScreenType) {
        fatalError()
    }
    
    func closeResult() {
        fatalError()
    }
    
    func returnToMainMenu() {
        fatalError()
    }
    
    func showMistakes() {
        fatalError()
    }
    
    func returnBack(completion: (() -> ())?) {
        fatalError()
    }
    
    var showAlertArguments = [String]()
    func showAlert(title: String, completion: (() -> ())?) {
        showAlertArguments.append(title)
        completion?()
    }
    
    func verify(showRepeatArguments: [Bool] = [],
                showCreatePairCounter: Int = 0,
                showAlertArguments: [String] = [],
                showAllWordsCounter: Int = 0) {
        XCTAssertEqual(self.showRepeatArguments, showRepeatArguments)
        XCTAssertEqual(self.showCreatePairCounter, showCreatePairCounter)
        XCTAssertEqual(self.showAlertArguments, showAlertArguments)
        XCTAssertEqual(self.showAllWordsCounter, showAllWordsCounter)
    }
}
