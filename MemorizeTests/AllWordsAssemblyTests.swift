//
//  AllWordsAssemblyTests.swift
//  MemorizeTests
//
//  Created by Вика on 11/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import XCTest

class AllWordsAssemblyTests: XCTestCase {
    
    var assembly: AllWordsAssembly!
    
    override func setUp() {
        super.setUp()
        
        assembly = AllWordsAssembly()
    }
    
    override func tearDown() {
        assembly = nil
        
        super.tearDown()
    }
    
    func testThatAssemblyCreatesScreen() {
        // act
        let view = assembly.create() as! AllWordsViewController
        
        // assert
        let presenter = view.presenter as! AllWordsPresenter
        let coreData = presenter.coreData as! CoreDataService
        
        XCTAssertNotNil(presenter)
        XCTAssertNotNil(coreData)
        
        XCTAssertTrue(presenter.view === view)
    }
}
