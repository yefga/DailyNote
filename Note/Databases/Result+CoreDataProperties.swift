//
//  Result+CoreDataProperties.swift
//  
//
//  Created by Yefga on 23/07/20.
//
//

import Foundation
import CoreData


extension Result {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Result> {
        return NSFetchRequest<Result>(entityName: "Result")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var note: NSSet?

    public var savedDate: Date {
        return date!
    }
    
    var savedDateString: String {
        return savedDate.toString
    }
    
    public var notesArray: [Note] {
        let set = note as? Set<Note> ?? []
        
        return set.sorted {
            $0.title! < $1.title!
        }
    }
}

// MARK: Generated accessors for note
extension Result {

    @objc(addNoteObject:)
    @NSManaged public func addToNote(_ value: Note)

    @objc(removeNoteObject:)
    @NSManaged public func removeFromNote(_ value: Note)

//    @objc(addNote:)
//    @NSManaged public func addToNote(_ values: NSSet)
//
//    @objc(removeNote:)
//    @NSManaged public func removeFromNote(_ values: NSSet)

}
