//
//  CoreDataService.swift
//  Memorize
//
//  Created by Вика on 05/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit
import CoreData

extension String {
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private var myComparable: String {
        return self
            .lowercased()
            .replacingOccurrences(of: "ё", with: "е")
            .trimmed
    }
    
    func isAlmostEqual(to other: String) -> Bool {
        return self.myComparable == other.myComparable
    }
}

extension Date {
    /// Возвращает текущую дату со времаенем 0:00
    var dateOnly: Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        return Calendar.current.date(from: components)!
    }
    
    /// Прибавляет к текущей дате указанное количество дней
    ///
    /// - Parameter days: количество прибавляемых дней
    /// - Returns: дата, полученная прибавлением указанного количества дней к текущей
    func add(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    /// Дата завтрашнего дня со временем 0:00
    static var tomorrow: NSDate {
        return Date().add(days: 1).dateOnly as NSDate
    }
    
    /// Сегодняшняя дата со временем 0:00
    static var today: NSDate {
        return Date().dateOnly as NSDate
    }
}

/// Тип пар слов
///
/// - allPairs: все пары из кордаты
/// - repeatPairs: пары для повторения сегодня из кордаты
enum TranslationPairType {
    case allPairs
    case repeatPairs
}

private extension TranslationPair {
    convenience init?(_ moPair: MOTranslationPair) {
        guard
            let originalWord = moPair.originalWord,
            let translatedWord = moPair.translatedWord,
            let originalLanguageString = moPair.originalLanguage,
            let originalLanguage = Language(rawValue: originalLanguageString),
            let translatedLanguageString = moPair.translatedLanguage,
            let translatedLanguage = Language(rawValue: translatedLanguageString)
            else { return nil }
        
        var image: UIImage?
        if let imageData = moPair.image {
            image = UIImage(data: imageData as Data, scale: 1.0)
        }
        
        self.init(originalWord: originalWord,
                  translatedWord: translatedWord,
                  originalLanguage: originalLanguage,
                  translatedLanguage: translatedLanguage,
                  image: image)
    }
}

/// Интерфейс для работы с кордатой
protocol CoreDataServiceProtocol {
    /// Проверяет, есть ли уже в кордате данное слово
    ///
    /// - Parameters:
    ///   - originalWord: данное слово
    ///   - completion: сообщает о конце выполнения функции
    /// - Returns: true, если такое слово есть, или false, если его нет
    func checkExistenceOfTranslationPair(originalWord: String,
                                         completion: @escaping (Bool) -> ())
    
    /// Сохраняет в кордату слово
    ///
    /// - Parameters:
    ///   - originalWord: слово
    ///   - translatedWord: его перевод
    ///   - originalLanguage: язык слова
    ///   - translatedLanguage: язык его перевода
    ///   - image: картинка к слову
    ///   - completion: сообщает о конце выполнения функции
    func saveNewTranslationPair(originalWord: String,
                                translatedWord: String,
                                originalLanguage: Language,
                                translatedLanguage: Language,
                                image: UIImage?,
                                completion: @escaping () -> ())
    
    /// Возвращает количество пар слов указанного типа из кордаты
    ///
    /// - Parameters:
    ///   - type: тип пар слов
    ///   - completion: сообщает о конце выполнения функции
    /// - Returns: кол-во таких пар
    func countOfTranslationPairs(of type: TranslationPairType, completion: @escaping (Int) -> ())
    
    /// Возвращает массив пар слов указанного типа из кордаты
    ///
    /// - Parameters:
    ///   - type: тип пар слов
    ///   - completion: сообщает о конце выполнения функции
    /// - Returns: массив пар слов указанного типа
    func fetchTranslationPairs(of type: TranslationPairType, completion: @escaping ([TranslationPair]) -> ())
    
    /// Обновляет пару слов в кордате после редактирования
    ///
    /// - Parameters:
    ///   - oldOriginalWord: слово в кордате
    ///   - newOriginalWord: новое значение слова
    ///   - newTranslatedWord: новое значение перевода слова
    ///   - image: новая картинка
    ///   - completion: сообщает о конце выполнения функции
    func updateTranslationPair(oldOriginalWord: String,
                               newOriginalWord: String,
                               newTranslatedWord: String,
                               image: UIImage?,
                               completion: @escaping () -> ())
    
    /// Обновляет дату следующего показа и счетчик правильных ответов подряд слова в кордате при повторении
    ///
    /// - Parameters:
    ///   - originalWord: само слово
    ///   - isMistake: была ли допущена ошибка
    ///   - completion: сообщает о конце выполнения функции
    func updateCounterAndDate(originalWord: String,
                              isMistake: Bool,
                              completion: @escaping () -> ())
    
    /// Удаляет указанное слово из кордаты
    ///
    /// - Parameters:
    ///   - originalWord: само слово
    ///   - completion: сообщает о конце выполнения функции
    func deleteTranslationPair(originalWord: String,
                               completion: @escaping () -> ())
}

/// Класс для работы с кордатой
class CoreDataService: CoreDataServiceProtocol {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func checkExistenceOfTranslationPair(originalWord: String,
                                         completion: @escaping (Bool) -> ()) {
        appDelegate.persistentContainer.performBackgroundTask { (context) in
            let request: NSFetchRequest<MOTranslationPair> = MOTranslationPair.fetchRequest()
            request.predicate = NSPredicate(format: "originalWord =[c] %@", originalWord.trimmed)
            do {
                let count = try context.count(for: request)
                DispatchQueue.main.async {
                    completion(count > 0)
                }
            } catch {
                print("Fetching data Failed")
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    
    func saveNewTranslationPair(originalWord: String,
                                translatedWord: String,
                                originalLanguage: Language,
                                translatedLanguage: Language,
                                image: UIImage?,
                                completion: @escaping () -> ()) {
        appDelegate.persistentContainer.performBackgroundTask { (context) in
            defer {
                DispatchQueue.main.async {
                    completion()
                }
            }
            
            let newPair = MOTranslationPair(context: context)
            newPair.originalWord = originalWord.trimmed
            newPair.translatedWord = translatedWord.trimmed
            newPair.originalLanguage = originalLanguage.rawValue
            newPair.translatedLanguage = translatedLanguage.rawValue
            newPair.counter = 0
            newPair.nextShowDate = Date.today
            
            if let image = image,
                let jpegData = image.jpegData(compressionQuality: 1.0) {
                newPair.image = NSData(data: jpegData)
            }
            
            print("Storing Data..")
            do {
                try context.save()
            } catch {
                print("Storing data Failed")
            }
        }
    }
 
    func countOfTranslationPairs(of type: TranslationPairType, completion: @escaping (Int) -> ()) {
        appDelegate.persistentContainer.performBackgroundTask { (context) in
            let request: NSFetchRequest<MOTranslationPair> = MOTranslationPair.fetchRequest()
            
            if type == .repeatPairs {
                request.predicate = NSPredicate(format: "nextShowDate <= %@", Date().dateOnly as NSDate)
            }
            
            do {
                let result = try context.count(for: request)
                DispatchQueue.main.async {
                    completion(result)
                }
            } catch {
                print("Fetching data Failed")
                DispatchQueue.main.async {
                    completion(0)
                }
            }
        }
    }

    func fetchTranslationPairs(of type: TranslationPairType, completion: @escaping ([TranslationPair]) -> ()) {
        appDelegate.persistentContainer.performBackgroundTask { (context) in
            print("Fetching Data..")
            let request: NSFetchRequest<MOTranslationPair> = MOTranslationPair.fetchRequest()
            
            if type == .repeatPairs {
                request.predicate = NSPredicate(format: "nextShowDate <= %@", Date().dateOnly as NSDate)
            }
            
            request.returnsObjectsAsFaults = false
            do {
                let pairs = try context.fetch(request)
                let convertedPairs = pairs.compactMap { TranslationPair($0) }
                DispatchQueue.main.async {
                    completion(convertedPairs)
                }
            } catch {
                print("Fetching data Failed")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
    
    func updateTranslationPair(oldOriginalWord: String,
                               newOriginalWord: String,
                               newTranslatedWord: String,
                               image: UIImage?,
                               completion: @escaping () -> ()) {
        appDelegate.persistentContainer.performBackgroundTask { (context) in
            defer {
                DispatchQueue.main.async {
                    completion()
                }
            }
            
            let request: NSFetchRequest<MOTranslationPair> = MOTranslationPair.fetchRequest()
            request.predicate = NSPredicate(format: "originalWord =[c] %@", oldOriginalWord.trimmed)
            do {
                if let result = try context.fetch(request).first {
                    result.originalWord = newOriginalWord.trimmed
                    result.translatedWord = newTranslatedWord.trimmed
                    result.counter = 0
                    result.nextShowDate = Date.today
                    
                    if let image = image,
                        let jpegData = image.jpegData(compressionQuality: 1.0) {
                        result.image = NSData(data: jpegData)
                    }
                    
                    do {
                        try context.save()
                    } catch {
                        print("Storing data Failed")
                    }
                }
            } catch {
                print("Fetching data Failed")
            }
        }
    }
    
    func updateCounterAndDate(originalWord: String,
                              isMistake: Bool,
                              completion: @escaping () -> ()) {
        appDelegate.persistentContainer.performBackgroundTask { (context) in
            defer {
                DispatchQueue.main.async {
                    completion()
                }
            }
            
            let request: NSFetchRequest<MOTranslationPair> = MOTranslationPair.fetchRequest()
            request.predicate = NSPredicate(format: "originalWord =[c] %@", originalWord.trimmed)
            do {
                if let result = try context.fetch(request).first {
                    
                    if isMistake {
                        result.counter = 0
                        result.nextShowDate = Date.tomorrow
                    } else {
                        let newCounter = result.counter + 1
                        result.counter = newCounter
                        result.nextShowDate = Date().add(days: Int(round(pow(Double(3), Double(newCounter))))).dateOnly as NSDate
                    }
                    
                    do {
                        try context.save()
                    } catch {
                        print("Storing data Failed")
                    }
                }
            } catch {
                print("Fetching data Failed")
            }
        }
    }

    func deleteTranslationPair(originalWord: String,
                               completion: @escaping () -> ()) {
        appDelegate.persistentContainer.performBackgroundTask { (context) in
            defer {
                DispatchQueue.main.async {
                    completion()
                }
            }
            let request: NSFetchRequest<MOTranslationPair> = MOTranslationPair.fetchRequest()
            request.predicate = NSPredicate(format: "originalWord =[c] %@", originalWord.trimmed)
            do {
                if let result = try context.fetch(request).first {
                    context.delete(result)
                }
                do {
                    try context.save()
                } catch {
                    print("Storing data Failed")
                }
            } catch {
                print("Fetching data Failed")
            }
        }
    }
}
