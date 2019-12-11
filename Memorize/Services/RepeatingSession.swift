//
//  RepeatingSession.swift
//  Memorize
//
//  Created by Вика on 01/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

/// Протокол сессии для повторения
protocol RepeatingSessionProtocol: class {
    
    var mistakes: [TranslationPair] { get }
    var repeatPairs: [TranslationPair] { get }
    var answeredPairs: [TranslationPair] { get }
    
    /// Загружает из кордаты слова для повторения
    ///
    /// - Parameter completion: оповещает о конце выполнения функции
    func load(completion: @escaping () -> ())
    
    /// Удаляет первое слово из массива слов для повторения
    func removeFirstPairFromRepeatPairs()
    
    /// Перемешивает пары слов для повторения
    func shuffleRepeatPairs()
    
    /// Добавляет слово в массив ошибок
    ///
    /// - Parameter mistake: слово, в котором была допущена ошибка
    func addMistake(mistake: TranslationPair)
    
    /// Очищает массив ошибок
    func resetMistakes()
    
    /// Очищает массив отвеченных слов
    func resetAnsweredPairs()
    
    /// Добавляет в массив отвеченных слов указанное слово
    ///
    /// - Parameter pair: слово для добавления
    func addAnsweredPair(pair: TranslationPair)
}

/// Класс сессии для повторения
class RepeatingSession: RepeatingSessionProtocol {
    /// singleton
    static let shared = RepeatingSession()
    
    private(set) var mistakes = [TranslationPair]()
    private(set) var repeatPairs = [TranslationPair]()
    private(set) var answeredPairs = [TranslationPair]()
    
    private init() { }
    
    /// Загружает из кордаты слова для повторения
    ///
    /// - Parameter completion: оповещает о конце выполнения функции
    func load(completion: @escaping () -> ()) {
        let coreData = CoreDataService()
        coreData.fetchTranslationPairs(of: .repeatPairs, completion: { [weak self] in
            self?.repeatPairs = $0
            completion()
        })
    }
    
    /// Удаляет первое слово из массива слов для повторения
    func removeFirstPairFromRepeatPairs() {
        repeatPairs.removeFirst()
    }
    
    /// Перемешивает пары слов для повторения
    func shuffleRepeatPairs() {
        repeatPairs.shuffle()
    }
    
    /// Добавляет слово в массив ошибок
    ///
    /// - Parameter mistake: слово, в котором была допущена ошибка
    func addMistake(mistake: TranslationPair) {
        mistakes.append(mistake)
    }
    
    /// Очищает массив ошибок
    func resetMistakes() {
        mistakes.removeAll()
    }
    
    /// Очищает массив отвеченных слов
    func resetAnsweredPairs() {
        answeredPairs.removeAll()
    }
    
    /// Добавляет в массив отвеченных слов указанное слово
    ///
    /// - Parameter pair: слово для добавления
    func addAnsweredPair(pair: TranslationPair) {
        answeredPairs.append(pair)
    }
}
