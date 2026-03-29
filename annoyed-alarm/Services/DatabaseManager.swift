//
//  DatabaseManager.swift
//  annoyed-alarm
//
//  Created by Nazwa Sapta Pradana on 19/03/26.
//


internal import CoreData
import SwiftUI

class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let context = CoreDataManager.shared.context
    
    private init() { }
    
    // MARK: - Fetch
    func fetchAlarms() -> [AlarmEntity] {
        let request: NSFetchRequest<AlarmEntity> = AlarmEntity.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Fetch failed: \(error)")
            return []
        }
    }
    
    // MARK: - Save
    func save(alarm: AlarmData) {
        let newAlarm = AlarmEntity(context: context)
        newAlarm.id = alarm.id
        newAlarm.time = alarm.time
        newAlarm.label = alarm.label
        newAlarm.isEnabled = alarm.isEnabled
        newAlarm.difficulty = alarm.difficulty.rawValue.capitalized
        
        saveContext()
    }
    
    // MARK: - Update
    func update(alarm: AlarmData) {
        let request: NSFetchRequest<AlarmEntity> = AlarmEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", alarm.id as CVarArg)
        
        do {
            if let existingAlarm = try context.fetch(request).first {
                existingAlarm.time = alarm.time
                existingAlarm.label = alarm.label
                existingAlarm.isEnabled = alarm.isEnabled
                existingAlarm.difficulty = alarm.difficulty.rawValue.capitalized
                saveContext()
            }
        } catch {
            print("Update failed: \(error)")
        }
    }
    
    // MARK: - Delete
    func delete(alarm: AlarmData) {
        let request: NSFetchRequest<AlarmEntity> = AlarmEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", alarm.id as CVarArg)
        
        do {
            if let existingAlarm = try context.fetch(request).first {
                context.delete(existingAlarm)
                saveContext()
            }
        } catch {
            print("Delete failed: \(error)")
        }
    }
    
    // MARK: - Save Context
    private func saveContext() {
        CoreDataManager.shared.saveContext()
    }
}
