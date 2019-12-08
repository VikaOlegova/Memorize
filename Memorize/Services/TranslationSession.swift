//
//  TranslationSession.swift
//  Memorize
//
//  Created by Вика on 01/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

class TranslationSession {
    static let shared = TranslationSession()
    
    private(set) var mistakes = [TranslationPair]()
    private(set) var repeatPairs = [TranslationPair]()
    private(set) var answeredPairs = [TranslationPair]()
    
    private init() { }
    
    func load(completion: @escaping () -> ()) {
        let coreData = CoreDataService()
        coreData.fetchTranslationPairs(of: .repeatPairs, completion: { [weak self] in
            self?.repeatPairs = $0
            completion()
        })
    }
    
    func removeFirstPairFromRepeatPairs() {
        repeatPairs.removeFirst()
    }
    
    func addMistake(mistake: TranslationPair) {
        mistakes.append(mistake)
    }
    
    func resetMistakes() {
        mistakes.removeAll()
    }
    
    func addAnsweredPair(pair: TranslationPair) {
        answeredPairs.append(pair)
    }
    
    func reset() {
        mistakes.removeAll()
        repeatPairs.removeAll()
    }
}
