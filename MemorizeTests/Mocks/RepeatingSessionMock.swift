//
//  RepeatingSessionMock.swift
//  MemorizeTests
//
//  Created by Вика on 11/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import Foundation
import XCTest

class RepeatingSessionMock: RepeatingSessionProtocol {
    var mistakes: [TranslationPair] = []
    var repeatPairs: [TranslationPair] = []
    var answeredPairs: [TranslationPair] = []
    
    var resetMistakesCounter = 0
    var resetAnsweredPairsCounter = 0
    var loadCounter = 0
    
    func load(completion: @escaping () -> ()) {
        loadCounter += 1
        completion()
    }
    
    func removeFirstPairFromRepeatPairs() {
        fatalError()
    }
    
    func shuffleRepeatPairs() {
        fatalError()
    }
    
    func add(mistake: TranslationPair) {
        fatalError()
    }
    
    func resetMistakes() {
        resetMistakesCounter += 1
    }
    
    func resetAnsweredPairs() {
        resetAnsweredPairsCounter += 1
    }
    
    func add(answeredPair: TranslationPair) {
        fatalError()
    }
    
    func verify(resetMistakesCounter: Int = 0,
                resetAnsweredPairsCounter: Int = 0,
                loadCounter: Int = 0) {
        XCTAssertEqual(self.resetMistakesCounter, resetMistakesCounter)
        XCTAssertEqual(self.resetAnsweredPairsCounter, resetAnsweredPairsCounter)
        XCTAssertEqual(self.loadCounter, loadCounter)
    }
}
