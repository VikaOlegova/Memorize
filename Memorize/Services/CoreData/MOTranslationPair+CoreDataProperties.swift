//
//  MOTranslationPair+CoreDataProperties.swift
//  Memorize
//
//  Created by Вика on 05/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//
//

import Foundation
import CoreData


extension MOTranslationPair {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MOTranslationPair> {
        return NSFetchRequest<MOTranslationPair>(entityName: "TranslationPair")
    }

    @NSManaged public var counter: Int32
    @NSManaged public var image: NSData?
    @NSManaged public var nextShowDate: NSDate?
    @NSManaged public var originalLanguage: String?
    @NSManaged public var originalWord: String?
    @NSManaged public var translatedLanguage: String?
    @NSManaged public var translatedWord: String?
    
    convenience init(context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "TranslationPair", in: context)
        self.init(entity: entity!, insertInto: context)
    }
}
