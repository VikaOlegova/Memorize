//
//  CoreDataServiceMock.swift
//  MemorizeTests
//
//  Created by Вика on 11/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit
import XCTest

class CoreDataServiceMock: CoreDataServiceProtocol {
    func checkExistenceOfTranslationPair(originalWord: String, completion: @escaping (Bool) -> ()) {
        fatalError()
    }
    
    func saveNewTranslationPair(originalWord: String, translatedWord: String, originalLanguage: Language, translatedLanguage: Language, image: UIImage?, completion: @escaping () -> ()) {
        fatalError()
    }
    
    var allPairsCounter = 0
    var repeatPairsCounter = 0
    func countOfTranslationPairs(of type: TranslationPairType, completion: @escaping (Int) -> ()) {
        switch type {
        case .allPairs:
            allPairsCounter += 1
            completion(allPairsCounter)
        case .repeatPairs:
            repeatPairsCounter += 1
            completion(repeatPairsCounter)
        }
    }
    
    var stubbedOutTranslationPairs = [TranslationPair]()
    func fetchTranslationPairs(of type: TranslationPairType, completion: @escaping ([TranslationPair]) -> ()) {
        switch type {
        case .allPairs:
            completion(stubbedOutTranslationPairs)
        default:
            completion([])
        }
    }
    
    func updateTranslationPair(originalWord: String, newTranslatedWord: String, completion: @escaping () -> ()) {
        fatalError()
    }
    
    func updateCounterAndDate(originalWord: String, isMistake: Bool, completion: @escaping () -> ()) {
        fatalError()
    }
    
    var deleteTranslationPairCounter = 0
    func deleteTranslationPair(originalWord: String, completion: @escaping () -> ()) {
        deleteTranslationPairCounter += 1
        completion()
    }
    
    func verify(allPairsCounter: Int = 0,
                repeatPairsCounter: Int = 0,
                deleteTranslationPairCounter: Int = 0,
                stubbedOutTranslationPairs: [TranslationPair] = []) {
        XCTAssertEqual(self.allPairsCounter, allPairsCounter)
        XCTAssertEqual(self.repeatPairsCounter, repeatPairsCounter)
        XCTAssertEqual(self.deleteTranslationPairCounter, deleteTranslationPairCounter)
        XCTAssertEqual(self.stubbedOutTranslationPairs, stubbedOutTranslationPairs)
    }
}
