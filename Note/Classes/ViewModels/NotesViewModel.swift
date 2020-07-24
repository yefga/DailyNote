//
//  NotesViewModel.swift
//  Note
//
//  Created by Yefga on 23/07/20.
//  Copyright © 2020 Yefga. All rights reserved.
//

import UIKit
import CoreData

struct NotesViewModel {
    
    private let context = Persistence.context
    var results: [Result] = []
    
    var sections: Int {
        return results.count
    }
    
    
    mutating func request() {
        let fetch: NSFetchRequest<Result> = Result.fetchRequest()
        fetch.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        
        do {
            let data = try Persistence.context.fetch(fetch)
            self.results = data
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        
    }
    
    /// Delete Note
    mutating func deleteNote(from tableView: UITableView, indexPath: IndexPath) {
        let result = results[indexPath.section]
        
        let note = results[indexPath.section].notesArray[indexPath.row]
        Persistence.context.delete(note)
        Persistence.saveContext()
        tableView.deleteRows(at: [indexPath], with: .fade)
        
        /// if note is empty, section also deleted
        if result.notesArray.isEmpty {
            results.remove(at: indexPath.section)
            Persistence.context.delete(result)
            Persistence.saveContext()
            tableView.deleteSections([indexPath.section], with: .fade)
        }
    }
    
    func headerTitle(section: Int) -> String {
        return results[section].savedDateString
    }
    
    func rows(section: Int) -> Int {
        return results[section].notesArray.count
    }
    
    func cellConfigure(_ cell: UITableViewCell, indexPath: IndexPath) {
        cell.textLabel?.text = results[indexPath.section].notesArray[indexPath.row].title
        cell.accessoryType = .disclosureIndicator
    }
    
}
