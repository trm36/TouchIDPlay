//
//  EntryController.swift
//  TouchIDPlay
//
//  Created by Taylor Mott on 9/28/16.
//  Copyright © 2016 Mott Applications. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    static let sharedController = EntryController()
    
    var entries = [Entry]()
    
    //C
    
    func createEntry() -> Entry {
        let entry = NSEntityDescription.insertNewObject(forEntityName: "Entry", into: Stack.sharedStack.managedObjectContext) as! Entry
        
        entries.append(entry)
        
        return entry
    }
    
    //R
    @discardableResult
    func loadEntries() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        let entries = try? Stack.sharedStack.managedObjectContext.fetch(fetchRequest)
        
        if let entries = entries {
            self.entries = entries
            return entries
        } else {
            self.entries = []
            return []
        }
    }
    
    //U
    @discardableResult
    static func saveToPersistentStore() -> Bool {
        do {
            _ = try Stack.sharedStack.managedObjectContext.save()
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    //D
    func deleteEntry(entry: Entry) {
        if let index = self.entries.index(of: entry) {
            entries.remove(at: Int(index))
            entry.managedObjectContext?.delete(entry)
        }
    }
    
    func clearEntries() {
        entries = []
    }
    
    
}
