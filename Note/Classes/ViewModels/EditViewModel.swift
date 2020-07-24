//
//  EditViewModel.swift
//  Note
//
//  Created by Yefga on 23/07/20.
//  Copyright © 2020 Yefga. All rights reserved.
//

import CoreData

struct EditViewModel {
    
    private var title: String = ""
    private var text: String = ""

    private let context = Persistence.context
    
    var note: Note?
  
    
    mutating func getTitle(_ string: String) {
        self.title = string
    }
    
    
    mutating func getNote(_ string: String) {
        self.text = string
    }
    
    
    lazy var id: String = {
        return (UserDefaults.standard.string(forKey: "noteID") ?? "empty")
    }()
    
    /// To validate title is not empty, at least you should type title to create your note
    func validate() -> Bool {
        return title.isEmpty
    }
    
    /// Fetching saved note by ID
    mutating func fetch() {
        let fetch: NSFetchRequest<Note> = Note.fetchRequest()
        fetch.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let data = try Persistence.context.fetch(fetch)
            self.note = data.first
            
            self.title = note?.title ?? ""
            self.text = note?.text ?? ""
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    /// Action to by from state, if state (add) then it will make request to save, else it will update existing note
    func action(from state: Bool, completion: @escaping () -> ()) {
        if state {
            save()
            completion()
        } else {
            update()
            completion()
        }
    }
    
    
}

extension EditViewModel {
    private func save() {
        let fetch: NSFetchRequest<Result> = Result.fetchRequest()
        fetch.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        
        do {
            let data = try Persistence.context.fetch(fetch)
            let resultToday = data.filter { $0.date!.toString == Date().toString }
            /// This will check if today note isn't created.
            if resultToday.isEmpty {
                let section = Result(context: context)
                section.date = Date()
                section.id = UUID()
                
                let item = Note(context: context)
                item.id = UUID()
                item.title = title
                item.text = text
                item.origin = section
                
            } else {
                data.forEach { (result) in
                    /// Add to existing section && prevent duplication on previous note
                    if Date().toString == result.date!.toString {
                        let item = Note(context: context)
                        item.id = UUID()
                        item.title = title
                        item.text = text
                        item.origin = result
                    } else {
                        let item = Note(context: context)
                        item.id = UUID()
                        item.title = title
                        item.text = text
                    }
                    
                }
                
            }
            
            /// Saving to Core Data
            try context.save()
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        
    }
    
    private func update() {
        do {
            /// Set new value
            note?.setValue(title, forKey: "title")
            note?.setValue(text, forKey: "text")
            
            /// Saving with new Value
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
}
