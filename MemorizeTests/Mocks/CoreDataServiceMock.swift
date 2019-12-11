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
    
    func fetchTranslationPairs(of type: TranslationPairType, completion: @escaping ([TranslationPair]) -> ()) {
        fatalError()
    }
    
    func updateTranslationPair(oldOriginalWord: String, newOriginalWord: String, newTranslatedWord: String, image: UIImage?, completion: @escaping () -> ()) {
        fatalError()
    }
    
    func updateCounterAndDate(originalWord: String, isMistake: Bool, completion: @escaping () -> ()) {
        fatalError()
    }
    
    func deleteTranslationPair(originalWord: String, completion: @escaping () -> ()) {
        fatalError()
    }
    
    func verify(allPairsCounter: Int = 0,
                repeatPairsCounter: Int = 0) {
        XCTAssertEqual(self.allPairsCounter, allPairsCounter)
        XCTAssertEqual(self.repeatPairsCounter, repeatPairsCounter)
    }
}
