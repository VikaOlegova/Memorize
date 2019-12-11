//
//  CorrectAnswerAssemblyTests.swift
//  MemorizeTests
//
//  Created by Вика on 11/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import XCTest

class CorrectAnswerAssemblyTests: XCTestCase {
    
    var assembly: CorrectAnswerAssembly!
    
    override func setUp() {
        super.setUp()
        
        assembly = CorrectAnswerAssembly()
    }
    
    override func tearDown() {
        assembly = nil
        
        super.tearDown()
    }
    
    func testThatAssemblyCreatesScreenForCorrectAnswer() {
        // act
        let view = assembly.create(isCorrect: true,
                                   correctTranslation: "Cat",
                                   correctTranslationLanguage: .EN,
                                   didTapNextCallback: { }) as! CorrectAnswerViewController
        
        // assert
        let presenter = view.presenter as! CorrectAnswerPresenter
        
        XCTAssertNotNil(presenter)
        
        XCTAssertTrue(presenter.view === view)
    }
    
    func testThatAssemblyCreatesScreenForIncorrectAnswer() {
        // act
        let view = assembly.create(isCorrect: false,
                                   correctTranslation: "Cat",
                                   correctTranslationLanguage: .EN,
                                   didTapNextCallback: { }) as! CorrectAnswerViewController
        
        // assert
        let presenter = view.presenter as! CorrectAnswerPresenter
        
        XCTAssertNotNil(presenter)
        
        XCTAssertTrue(presenter.view === view)
    }
}

