//
//  CoreDataManager.swift
//  annoyed-alarm
//
//  Created by Nazwa Sapta Pradana on 20/03/26.
//


internal import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let container: NSPersistentContainer
    
    private init() {
        container = NSPersistentContainer(name: "Model") // harus sama dengan nama .xcdatamodeld
        container.loadPersistentStores { desc, error in
            if let error = error {
                fatalError("Core Data failed to load: \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do { try context.save() }
            catch { print("Failed to save context: \(error)") }
        }
    }
}
