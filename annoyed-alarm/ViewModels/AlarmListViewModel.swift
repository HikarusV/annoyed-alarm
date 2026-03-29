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
    @Published var alarms: [AlarmData] = []

    func load() {
        // Fetch data dari Core Data
        let fetchedEntities = DatabaseManager.shared.fetchAlarms() // [AlarmEntity]
        
        if fetchedEntities.isEmpty {
            alarms = []
        } else {
            // Convert AlarmEntity ke Alarm struct
            alarms = fetchedEntities.map { AlarmData(entity: $0) }
        }
    }

    func toggle(alarm: AlarmData) async {
        // Cari index alarm di array
        guard let index = alarms.firstIndex(where: { $0.id == alarm.id }) else { return }

        // Toggle value
        alarms[index].isEnabled.toggle()

        // Update Core Data
        DatabaseManager.shared.update(alarm: alarms[index])

        // Schedule / cancel
        if alarms[index].isEnabled {
            do {
                try await AlarmScheduler.shared.setAlarm(alarm: alarms[index])
            } catch {
                print(error.localizedDescription)
            }
        } else {
            do {
                try await AlarmScheduler.shared.cancelAlarm(alarm: alarms[index])
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - Extension untuk convert Core Data entity ke struct
extension AlarmData {
    init(entity: AlarmEntity) {
        self.id = entity.id ?? UUID()
        self.time = entity.time ?? Date()
        self.label = entity.label ?? ""
        self.isEnabled = entity.isEnabled
        self.difficulty = entity.difficulty?.toChallengeDifficulty() ?? .medium
    }
}
