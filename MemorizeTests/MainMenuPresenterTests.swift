//
//  MemorizeTests.swift
//  MemorizeTests
//
//  Created by Вика on 25/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import XCTest

class MainMenuPresenterTests: XCTestCase {

    var presenter: MainMenuPresenter!

    var coreDataService: CoreDataServiceMock!
    var router: RouterMock!
    var session: RepeatingSessionMock!
    var view: MainMenuViewControllerMock!

    override func setUp() {
        super.setUp()
        
        coreDataService = CoreDataServiceMock()
        view = MainMenuViewControllerMock()
        router = RouterMock()
        session = RepeatingSessionMock()

        presenter = MainMenuPresenter(coreData: coreDataService,
                                      router: router,
                                      session: session)
        presenter.view = view
    }

    override func tearDown() {
        coreDataService = nil
        view = nil
        router = nil
        session = nil
        presenter = nil
        
        super.tearDown()
    }

    func testThatPresenterShowsWordsCountFromCoreData() {
        // arrange
        presenter.allWordsCount = 100500
        presenter.repeatWordsCount = 100500

        // act
        presenter.viewWillAppear()

        // assert
        coreDataService.verify(allPairsCounter: 1, repeatPairsCounter: 1)
        view.verify(repeatWordsCountArguments: [1], showAllWordsCountArguments: [1])
        session.verify()
        router.verify()
        
        XCTAssertEqual(presenter.repeatWordsCount, 1)
        XCTAssertEqual(presenter.allWordsCount, 1)
    }

    func testThatPresenterShowsRepeatScreenWithDownloadedWords() {
        // arrange
        presenter.repeatWordsCount = 100500
        presenter.allWordsCount = 0

        // act
        presenter.repeatWordsButtonTapped()

        // assert
        coreDataService.verify()
        session.verify(resetMistakesCounter: 1,
                       resetAnsweredPairsCounter: 1,
                       loadCounter: 1)
        router.verify(showRepeatArguments: [false])
        view.verify(enableInteractionArguments: [false, true])
    }
    
    func testThatPresenterShowsAlertIfNoWordsAtAll() {
        // arrange
        presenter.repeatWordsCount = 0
        presenter.allWordsCount = 0
        
        // act
        presenter.repeatWordsButtonTapped()
        
        // assert
        coreDataService.verify()
        session.verify()
        router.verify(showCreatePairCounter: 1,
                      showAlertArguments: ["Сначала добавьте слова;)"])
        view.verify()
    }
    
    func testThatPresenterShowsAlertIfNoWordsForToday() {
        // arrange
        presenter.repeatWordsCount = 0
        presenter.allWordsCount = 100500
        
        // act
        presenter.repeatWordsButtonTapped()
        
        // assert
        coreDataService.verify()
        session.verify()
        router.verify(showAlertArguments: ["На сегодня все!"])
        view.verify()
    }
    
    func testThatPresenterShowsAllWords() {
        // act
        presenter.allWordsButtonTapped()
        
        // assert
        coreDataService.verify()
        session.verify()
        router.verify(showAllWordsCounter: 1)
        view.verify()
    }
}
