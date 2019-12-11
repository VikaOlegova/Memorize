//
//  AllWordsViewControllerMock.swift
//  MemorizeTests
//
//  Created by Вика on 11/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import Foundation
import XCTest

class AllWordsViewControllerMock: AllWordsViewInput {
    var showAllWordsArguments = [TranslationPairViewModel]()
    func show(allWords: [TranslationPairViewModel]) {
        showAllWordsArguments += allWords
    }
    
    var showPlaceholderArguments = [Bool]()
    func showPlaceholder(isHidden: Bool) {
        showPlaceholderArguments.append(isHidden)
    }
    
    func verify(showPlaceholderArguments: [Bool] = [],
                showAllWordsArguments: [TranslationPairViewModel] = []) {
        XCTAssertEqual(self.showPlaceholderArguments, showPlaceholderArguments)
        XCTAssertEqual(self.showAllWordsArguments, showAllWordsArguments)
    }
}
