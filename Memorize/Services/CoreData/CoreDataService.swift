//
//  CoreDataService.swift
//  Memorize
//
//  Created by Вика on 05/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit
import  CoreData

extension Date {
    var dateOnly: Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        return Calendar.current.date(from: components)!
    }
    
    func add(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
}

class CoreDataService {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext!
    
    func saveNewTranslationPair(originalWord: String,
                                translatedWord: String,
                                originalLanguage: Language,
                                translatedLanguage: Language,
                                image: UIImage?)
    {
        let newPair = MOTranslationPair(context: context)
        newPair.originalWord = originalWord
        newPair.translatedWord = translatedWord
        newPair.originalLanguage = originalLanguage.rawValue
        newPair.translatedLanguage = translatedLanguage.rawValue
        newPair.counter = 0
        newPair.nextShowDate = Date().add(days: 1).dateOnly as NSDate
        
        if let image = image, let jpegData = image.jpegData(compressionQuality: 1.0) {
            newPair.image = NSData(data: jpegData)
        }
        
        print("Storing Data..")
        do {
            try context.save()
        } catch {
            print("Storing data Failed")
        }
    }
    
    func fetchAllTranslationPairs() -> [TranslationPair]
    {
        print("Fetching Data..")
        let request: NSFetchRequest<MOTranslationPair> = MOTranslationPair.fetchRequest()
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            let translationPairs = result.compactMap { (data) -> TranslationPair? in
                guard let originalWord = data.originalWord,
                    let translatedWord = data.translatedWord,
                    let originalLanguageString = data.originalLanguage,
                    let translatedLanguageString = data.translatedLanguage,
                    let date = data.nextShowDate else { return nil }
                
                let image: UIImage?
                if let imageData = data.image {
                    image = UIImage(data: imageData as Data, scale: 1.0)
                } else {
                    image = nil
                }
                
                return TranslationPair(originalWord: originalWord, translatedWord: translatedWord, originalLanguage: Language(rawValue: originalLanguageString)!, translatedLanguage: Language(rawValue: translatedLanguageString)!, image: image, rightAnswersStreakCounter: Int(data.counter), nextShowDate: date as Date)
            }
            return translationPairs
        } catch {
            print("Fetching data Failed")
            return []
        }
    }
    
    func updateTranslationPair(oldOriginalWord: String,
                               oldTranslatedWord: String,
                               newOriginalWord: String,
                               newTranslatedWord: String,
                               image: UIImage?) {
        let request: NSFetchRequest<MOTranslationPair> = MOTranslationPair.fetchRequest()
        request.predicate = NSPredicate(format: "originalWord = %@ AND translatedWord = %@", argumentArray: [oldOriginalWord, oldTranslatedWord])
        
        do {
            let result = try context.fetch(request)
            for data in result {
                data.originalWord = newOriginalWord
                data.translatedWord = newTranslatedWord
                data.counter = 0
                data.nextShowDate = Date().add(days: 1).dateOnly as NSDate
                
                if let image = image, let jpegData = image.jpegData(compressionQuality: 1.0) {
                    data.image = NSData(data: jpegData)
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
    
    func updateCounterAndDate(originalWord: String, translatedWord: String, isMistake: Bool) {
        let request: NSFetchRequest<MOTranslationPair> = MOTranslationPair.fetchRequest()
        request.predicate = NSPredicate(format: "originalWord = %@ AND translatedWord = %@", argumentArray: [originalWord, translatedWord])
        
        do {
            let result = try context.fetch(request)
            for data in result {
                if isMistake {
                    data.counter = 0
                    data.nextShowDate = Date().add(days: 1).dateOnly as NSDate
                } else {
                    let newCounter = data.counter + 1
                    data.counter = newCounter
                    data.nextShowDate = Date().add(days: Int(pow(Double(3),Double(newCounter)))).dateOnly as NSDate
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
    
    // функция получения слов для повторения
}
