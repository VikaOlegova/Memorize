//
//  MainMenuViewControllerMock.swift
//  MemorizeTests
//
//  Created by Вика on 11/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import Foundation
import XCTest

class MainMenuViewControllerMock: MainMenuViewInput {
    
    var repeatWordsCountArguments = [Int]()
    func show(repeatWordsCount: Int) {
        repeatWordsCountArguments.append(repeatWordsCount)
    }
    
    var showAllWordsCountArguments = [Int]()
    func show(allWordsCount: Int) {
        showAllWordsCountArguments.append(allWordsCount)
    }
    
    var enableInteractionArguments = [Bool]()
    func enableInteraction(_ enable: Bool) {
        enableInteractionArguments.append(enable)
    }
    
    func verify(repeatWordsCountArguments: [Int] = [],
                showAllWordsCountArguments: [Int] = [],
                enableInteractionArguments: [Bool] = []) {
        XCTAssertEqual(self.repeatWordsCountArguments, repeatWordsCountArguments)
        XCTAssertEqual(self.showAllWordsCountArguments, showAllWordsCountArguments)
        XCTAssertEqual(self.enableInteractionArguments, enableInteractionArguments)
    }
}
