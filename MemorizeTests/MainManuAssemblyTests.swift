//
//  MainManuAssemblyTests.swift
//  MemorizeTests
//
//  Created by Вика on 11/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import XCTest

class MainMenuAssemblyTests: XCTestCase {
    
    var assembly: MainMenuAssembly!
    
    override func setUp() {
        super.setUp()
        
        assembly = MainMenuAssembly()
    }
    
    override func tearDown() {
        assembly = nil
        
        super.tearDown()
    }
    
    func testThatAssemblyCreatesMainMenuScreen() {
        // act
        let view = assembly.create() as! MainMenuViewController
        
        // assert
        let presenter = view.presenter as! MainMenuPresenter
        let coreData = presenter.coreData as! CoreDataService
        
        XCTAssertNotNil(presenter)
        XCTAssertNotNil(coreData)
        
        XCTAssertTrue(presenter.view === view)
    }
}
