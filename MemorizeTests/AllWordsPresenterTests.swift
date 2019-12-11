//
//  AllWordsPresenterTests.swift
//  MemorizeTests
//
//  Created by Вика on 11/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import XCTest

class AllWordsPresenterTests: XCTestCase {
    
    var presenter: AllWordsPresenter!
    
    var coreDataService: CoreDataServiceMock!
    var router: RouterMock!
    var view: AllWordsViewControllerMock!
    
    override func setUp() {
        super.setUp()
        
        coreDataService = CoreDataServiceMock()
        view = AllWordsViewControllerMock()
        router = RouterMock()
        
        presenter = AllWordsPresenter(coreData: coreDataService,
                                      router: router)
        presenter.view = view
    }
    
    override func tearDown() {
        coreDataService = nil
        view = nil
        router = nil
        presenter = nil
        
        super.tearDown()
    }
    
    func testThatPresenterDeletesTranslationPairFromCoreDataAndHidesPlaceholder() {
        // arrange
        let translationPairViewModel = TranslationPairViewModel(originalWord: "Cat", originalWordLanguage: "EN", translatedWord: "Кот", translatedWordLanguage: "RU")
        let allPairsCount = 100500
        
        // act
        presenter.didDelete(pair: translationPairViewModel, allPairsCount: allPairsCount)
        
        // assert
        coreDataService.verify(deleteTranslationPairCounter: 1)
        view.verify(showPlaceholderArguments: [true])
        router.verify()
    }
    
    func testThatPresenterDeletesTranslationPairFromCoreDataAndShowsPlaceholder() {
        // arrange
        let translationPairViewModel = TranslationPairViewModel(originalWord: "Cat", originalWordLanguage: "EN", translatedWord: "Кот", translatedWordLanguage: "RU")
        let allPairsCount = 0
        
        // act
        presenter.didDelete(pair: translationPairViewModel, allPairsCount: allPairsCount)
        
        // assert
        coreDataService.verify(deleteTranslationPairCounter: 1)
        view.verify(showPlaceholderArguments: [false])
        router.verify()
    }
 
    func testThatPresenterReceivesAllPairsFromCoreDataAndShowsThemAndHidesPlaceholder() {
        // arrange
        presenter.translationPairs = []
        coreDataService.stubbedOutTranslationPairs = [TranslationPair.empty]
        let model = TranslationPairViewModel(originalWord: "", originalWordLanguage: "EN", translatedWord: "", translatedWordLanguage: "RU")
        
        // act
        presenter.viewWillAppear()
        
        // assert
        coreDataService.verify(stubbedOutTranslationPairs: [TranslationPair.empty])
        XCTAssertEqual(presenter.translationPairs, [TranslationPair.empty])
        view.verify(showPlaceholderArguments: [true], showAllWordsArguments: [model])
        router.verify()
    }
    
    func testThatPresenterReceivesZeroPairsFromCoreDataAndShowsPlaceholder() {
        // arrange
        presenter.translationPairs = [TranslationPair.empty]
        coreDataService.stubbedOutTranslationPairs = []
        
        // act
        presenter.viewWillAppear()
        
        // assert
        coreDataService.verify(stubbedOutTranslationPairs: [])
        XCTAssertEqual(presenter.translationPairs, [])
        view.verify(showPlaceholderArguments: [false])
        router.verify()
    }
    
    func testThatPresenterShowsCreateWordScreen() {
        // act
        presenter.createButtonTapped()
        
        // assert
        router.verify(showCreatePairCounter: 1)
        coreDataService.verify()
        view.verify()
    }
    
    func testThatPresenterOpensCreateWordScreen() {
        // act
        presenter.addButtonTapped()
        
        // assert
        router.verify(showCreatePairCounter: 1)
        coreDataService.verify()
        view.verify()
    }
    
    func testThatPresenterShowsEditWordScreenWithPair() {
        // arrange
        let translationPairViewModel = TranslationPairViewModel(originalWord: "Cat", originalWordLanguage: "EN", translatedWord: "Кот", translatedWordLanguage: "RU")
        let translationPair = TranslationPair(originalWord: "Cat", translatedWord: "Кот", originalLanguage: .EN, translatedLanguage: .RU)
        presenter.translationPairs.append(translationPair)
        
        // act
        presenter.cellTapped(with: translationPairViewModel)
        
        // assert
        XCTAssertNotNil(translationPair)
        router.verify(showEditTranslationPairCounter: [translationPair])
        coreDataService.verify()
        view.verify()
    }
    
    func testThatPresenterDoesNotFoundRightPair() {
        // arrange
        let translationPairViewModel = TranslationPairViewModel(originalWord: "Cat", originalWordLanguage: "EN", translatedWord: "Кот", translatedWordLanguage: "RU")
        let translationPair: TranslationPair? = nil
        
        // act
        presenter.cellTapped(with: translationPairViewModel)
        
        // assert
        XCTAssertNil(translationPair)
        router.verify()
        coreDataService.verify()
        view.verify()
    }
}
