//
//  AlarmManager.swift
//  annoyed-alarm
//
//  Created by Nazwa Sapta Pradana on 20/03/26.
//


import SwiftUI
import Combine
internal import CoreData

class AlarmManager: ObservableObject {
    static let shared = AlarmManager()
    
    @Published var alarms: [AlarmEntity] = []
    private let context = CoreDataManager.shared.context
    
    init() { fetchAlarms() }
    
    func fetchAlarms() {
        let request: NSFetchRequest<AlarmEntity> = AlarmEntity.fetchRequest()
        do { alarms = try context.fetch(request) }
        catch { print("Fetch failed: \(error)"); alarms = [] }
    }
    
    func addAlarm(time: Date, label: String, isEnabled: Bool, difficulty: String) {
        let newAlarm = AlarmEntity(context: context)
        newAlarm.id = UUID()
        newAlarm.time = time
        newAlarm.label = label
        newAlarm.isEnabled = isEnabled
        newAlarm.difficulty = difficulty
        saveAndRefresh()
    }
    
    func deleteAlarm(alarm: AlarmEntity) { context.delete(alarm); saveAndRefresh() }
    
    private func saveAndRefresh() {
        CoreDataManager.shared.saveContext()
        fetchAlarms()
    }
}
