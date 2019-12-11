//
//  ResultAssemblyTests.swift
//  MemorizeTests
//
//  Created by Вика on 11/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import XCTest

class ResultAssemblyTests: XCTestCase {
    
    var assembly: ResultAssembly!
    
    override func setUp() {
        super.setUp()
        
        assembly = ResultAssembly()
    }
    
    override func tearDown() {
        assembly = nil
        
        super.tearDown()
    }
    
    func testThatAssemblyCreatesResultScreenOfMistakesCorrection() {
        // act
        let view = assembly.create(resultScreenType: .mistakesCorrectionEnded) as? ResultViewController
        
        // assert
        let presenter = view?.presenter as? ResultPresenter
        
        XCTAssertNotNil(view)
        XCTAssertNotNil(presenter)
        
        XCTAssertTrue(presenter?.view === view)
    }
    
    func testThatAssemblyCreatesResultScreenOfRepeatingWithMistakes() {
        // act
        let view = assembly.create(resultScreenType: .repeatingEnded(withMistakes: true)) as? ResultViewController
        
        // assert
        let presenter = view?.presenter as? ResultPresenter
        
        XCTAssertNotNil(view)
        XCTAssertNotNil(presenter)
        
        XCTAssertTrue(presenter?.view === view)
    }
    
    func testThatAssemblyCreatesResultScreenOfRepeatingWithoutMistakes() {
        // act
        let view = assembly.create(resultScreenType: .repeatingEnded(withMistakes: false)) as? ResultViewController
        
        // assert
        let presenter = view?.presenter as? ResultPresenter
        
        XCTAssertNotNil(view)
        XCTAssertNotNil(presenter)
        
        XCTAssertTrue(presenter?.view === view)
    }
}
