//
//  CoreDataService.swift
//  Memorize
//
//  Created by Вика on 05/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit
import CoreData

extension Date {
    var dateOnly: Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        return Calendar.current.date(from: components)!
    }
    
    func add(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    static var tomorrow: NSDate {
        return Date().add(days: 1).dateOnly as NSDate
    }
}

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
            let translatedLanguage = Language(rawValue: translatedLanguageString),
            let date = moPair.nextShowDate
            else { return nil }
        
        var image: UIImage?
        if let imageData = moPair.image {
            image = UIImage(data: imageData as Data, scale: 1.0)
        }
        
        self.init(originalWord: originalWord,
                  translatedWord: translatedWord,
                  originalLanguage: originalLanguage,
                  translatedLanguage: translatedLanguage,
                  image: image,
                  rightAnswersStreakCounter: Int(moPair.counter),
                  nextShowDate: date as Date)
    }
}

class CoreDataService {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func checkExistenceOfTranslationPair(originalWord: String,
                                         translatedWord: String,
                                         completion: @escaping (Bool) -> ()) {
        appDelegate.persistentContainer.performBackgroundTask { (context) in
            let request: NSFetchRequest<MOTranslationPair> = MOTranslationPair.fetchRequest()
            request.predicate = NSPredicate(format: "originalWord =[c] %@ AND translatedWord =[c] %@",
                                            argumentArray: [originalWord, translatedWord])
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
            newPair.originalWord = originalWord
            newPair.translatedWord = translatedWord
            newPair.originalLanguage = originalLanguage.rawValue
            newPair.translatedLanguage = translatedLanguage.rawValue
            newPair.counter = 0
            newPair.nextShowDate = Date.tomorrow
            
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
//                request.predicate = NSPredicate(format: "nextShowDate <= %@", Date().dateOnly as NSDate)
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
//                request.predicate = NSPredicate(format: "nextShowDate <= %@", Date().dateOnly as NSDate)
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
                               oldTranslatedWord: String,
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
            request.predicate = NSPredicate(format: "originalWord = %@ AND translatedWord = %@",
                                            argumentArray: [oldOriginalWord, oldTranslatedWord])
            do {
                if let result = try context.fetch(request).first {
                    result.originalWord = newOriginalWord
                    result.translatedWord = newTranslatedWord
                    result.counter = 0
                    result.nextShowDate = Date.tomorrow
                    
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
                              translatedWord: String,
                              isMistake: Bool,
                              completion: @escaping () -> ()) {
        appDelegate.persistentContainer.performBackgroundTask { (context) in
            defer {
                DispatchQueue.main.async {
                    completion()
                }
            }
            
            let request: NSFetchRequest<MOTranslationPair> = MOTranslationPair.fetchRequest()
            request.predicate = NSPredicate(format: "originalWord = %@ AND translatedWord = %@",
                                            argumentArray: [originalWord, translatedWord])
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
                               translatedWord: String,
                               completion: @escaping () -> ()) {
        appDelegate.persistentContainer.performBackgroundTask { (context) in
            defer {
                DispatchQueue.main.async {
                    completion()
                }
            }
            let request: NSFetchRequest<MOTranslationPair> = MOTranslationPair.fetchRequest()
            request.predicate = NSPredicate(format: "originalWord = %@ AND translatedWord = %@",
                                            argumentArray: [originalWord, translatedWord])
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
