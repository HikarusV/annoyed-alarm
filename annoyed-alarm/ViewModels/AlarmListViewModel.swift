//
//  AlarmListViewModel.swift
//  annoyed-alarm
//
//  Created by Nazwa Sapta Pradana on 19/03/26.
//


import SwiftUI
import Foundation
import Combine

class AlarmListViewModel: ObservableObject {
    @Published var alarms: [Alarm] = []

    func load() {
        // Fetch data dari Core Data
        let fetchedEntities = DatabaseManager.shared.fetchAlarms() // [AlarmEntity]
        
        if fetchedEntities.isEmpty {
            alarms = []
        } else {
            // Convert AlarmEntity ke Alarm struct
            alarms = fetchedEntities.map { Alarm(entity: $0) }
        }
    }

    func toggle(alarm: Alarm) {
        // Cari index alarm di array
        guard let index = alarms.firstIndex(where: { $0.id == alarm.id }) else { return }

        // Toggle value
        alarms[index].isEnabled.toggle()

        // Update Core Data
        DatabaseManager.shared.update(alarm: alarms[index])

        // Schedule / cancel
        if alarms[index].isEnabled {
            AlarmScheduler.shared.schedule(alarm: alarms[index])
        } else {
            AlarmScheduler.shared.cancel(alarm: alarms[index])
        }
    }
}

// MARK: - Extension untuk convert Core Data entity ke struct
extension Alarm {
    init(entity: AlarmEntity) {
        self.id = entity.id ?? UUID()
        self.time = entity.time ?? Date()
        self.label = entity.label ?? ""
        self.isEnabled = entity.isEnabled
        self.difficulty = entity.difficulty ?? "Easy"
    }
}
