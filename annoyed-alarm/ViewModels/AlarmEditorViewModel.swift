//
//  AlarmEditorViewModel.swift
//  annoyed-alarm
//
//  Created by Nazwa Sapta Pradana on 19/03/26.
//

import Foundation
import Combine

class AlarmEditorViewModel: ObservableObject {
    @Published var time = Date()
    @Published var label = ""
    @Published var difficulty = "Medium"
    
    private var existingAlarm: Alarm?
    
    init(alarm: Alarm? = nil) {
        if let alarm = alarm {
            // EDIT MODE
            self.existingAlarm = alarm
            self.time = alarm.time
            self.label = alarm.label
            self.difficulty = alarm.difficulty
        }
    }
    
    // MARK: - Save (Create / Edit)
    func save() {
        if var alarm = existingAlarm {
            // EDIT
            alarm.time = time
            alarm.label = label
            alarm.difficulty = difficulty
            
            DatabaseManager.shared.update(alarm: alarm)
        } else {
            // CREATE
            let newAlarm = Alarm(
                time: time,
                isEnabled: true,
                label: label.isEmpty ? "Alarm" : label,
                difficulty: difficulty
            )
            
            DatabaseManager.shared.save(alarm: newAlarm)
        }
    }
    
    // MARK: - Delete
    func delete() {
        guard let alarm = existingAlarm else { return } // cuma bisa delete kalau edit mode
        DatabaseManager.shared.delete(alarm: alarm)
    }
}
