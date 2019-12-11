//
//  RepeatAssemblyTests.swift
//  MemorizeTests
//
//  Created by Вика on 11/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import XCTest

class RepeatAssemblyTests: XCTestCase {
    
    var assembly: RepeatAssembly!
    
    override func setUp() {
        super.setUp()
        
        assembly = RepeatAssembly()
    }
    
    override func tearDown() {
        assembly = nil
        
        super.tearDown()
    }
    
    func testThatAssemblyCreatesRepeatScreen() {
        // act
        let view = assembly.create(isMistakes: false) as? RepeatViewController
        
        // assert
        let presenter = view?.presenter as? RepeatPresenter
        let coreData = presenter?.coreData as? CoreDataService
        
        XCTAssertNotNil(view)
        XCTAssertNotNil(presenter)
        XCTAssertNotNil(coreData)
        
        XCTAssertTrue(presenter?.view === view)
    }
    
    func testThatAssemblyCreatesErrorCorrectionScreen() {
        // act
        let view = assembly.create(isMistakes: true) as? RepeatViewController
        
        // assert
        let presenter = view?.presenter as? RepeatPresenter
        let coreData = presenter?.coreData as? CoreDataService
        
        XCTAssertNotNil(view)
        XCTAssertNotNil(presenter)
        XCTAssertNotNil(coreData)
        
        XCTAssertTrue(presenter?.view === view)
    }
}

