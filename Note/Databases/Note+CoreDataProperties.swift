//
//  Note+CoreDataProperties.swift
//  
//
//  Created by Yefga on 23/07/20.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var text: String?
    @NSManaged public var title: String?
    @NSManaged public var origin: Result?

    var oid: String {
        return "\(objectID)"
    }
}
