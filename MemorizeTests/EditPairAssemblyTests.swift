//
//  EditPairAssemblyTests.swift
//  MemorizeTests
//
//  Created by Вика on 11/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import XCTest

class EditPairAssemblyTests: XCTestCase {
    
    var assembly: EditPairAssembly!
    
    override func setUp() {
        super.setUp()
        
        assembly = EditPairAssembly()
    }
    
    override func tearDown() {
        assembly = nil
        
        super.tearDown()
    }
    
    func testThatAssemblyCreatesEditPairScreen() {
        // arrange
        let pair = TranslationPair(originalWord: "Cat", translatedWord: "Кот", originalLanguage: .EN, translatedLanguage: .RU)
        
        // act
        let view = assembly.create(translationPair: pair) as? EditPairViewController
        
        // assert
        let presenter = view?.presenter as? EditPairPresenter
        let coreData = presenter?.coreData as? CoreDataService
        let imageService = presenter?.imageService as? FacadeImageService
        let networkService = imageService?.networkService as? NetworkService
        let yandexTranslateService = presenter?.translateService as? YandexTranslateService
        
        XCTAssertNotNil(view)
        XCTAssertNotNil(presenter)
        XCTAssertNotNil(coreData)
        XCTAssertNotNil(imageService)
        XCTAssertNotNil(networkService)
        XCTAssertNotNil(yandexTranslateService)
        XCTAssertNotNil(pair)
        
        XCTAssertTrue(presenter?.view === view)
        XCTAssertEqual(presenter?.translationPair, pair)
    }
    
    func testThatAssemblyCreatesCreatePairScreen() {
        // arrange
        let pair: TranslationPair? = nil
        
        // act
        let view = assembly.create(translationPair: pair) as? EditPairViewController
        
        // assert
        let presenter = view?.presenter as? EditPairPresenter
        let coreData = presenter?.coreData as? CoreDataService
        let imageService = presenter?.imageService as? FacadeImageService
        let networkService = imageService?.networkService as? NetworkService
        let yandexTranslateService = presenter?.translateService as? YandexTranslateService
        
        XCTAssertNotNil(view)
        XCTAssertNotNil(presenter)
        XCTAssertNotNil(coreData)
        XCTAssertNotNil(imageService)
        XCTAssertNotNil(networkService)
        XCTAssertNotNil(yandexTranslateService)
        XCTAssertNil(pair)
        
        XCTAssertTrue(presenter?.view === view)
        XCTAssertEqual(presenter?.translationPair, pair)
    }
}
