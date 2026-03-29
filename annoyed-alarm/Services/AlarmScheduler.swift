//
//  AlarmScheduler.swift
//  annoyed-alarm
//
//  Created by Nazwa Sapta Pradana on 19/03/26.
//


import UserNotifications
import AlarmKit
import SwiftUI

class AlarmScheduler {
    static let shared = AlarmScheduler()
    
    func requestLocalNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound]
        ) { _, _ in }
    }
    
    func setAlarm(alarm: AlarmData) async throws {
        
        let alert = AlarmPresentation.Alert(
            title: "Title Alarm Kit Presentation",
            stopButton: .init(text: "Start Challange", textColor: .red, systemImageName: "play.fill"),
        )
        
//        let alert2 = AlarmPresentation.
        
        let presentation = AlarmPresentation(alert: alert)
        
        let attributes = AlarmAttributes<CountDownAttribute>(presentation: presentation, metadata: .init(), tintColor: .orange)
        
//        let scheduledAlarm = Alarm.Schedule.fixed(alarm.time)
        let scheduledAlarm = Alarm.Schedule.fixed((.now.addingTimeInterval(10)))
        
        let config = AlarmManager.AlarmConfiguration(
            schedule: scheduledAlarm,
            attributes: attributes
        )
        
        let _ = try await AlarmManager.shared.schedule(id: alarm.id, configuration: config)
        print("Alarm Set \(alarm.time) Successfully!!")
    }
    
    func cancelAlarm(alarm: AlarmData) async throws {
        try AlarmManager.shared.cancel(id: alarm.id)
        print("Alarm \(alarm.time) Cancelled Successfully!!")
    }
    
    func scheduleLocalNotificationMethod(alarm: AlarmData) {
        guard alarm.isEnabled else { return }

        let content = UNMutableNotificationContent()
        content.title = alarm.label
        content.body = "Wake up!"
        content.sound = .default
        
        // ❗️ penting: kirim data alarm
        content.userInfo = [
            "alarmId": alarm.id.uuidString,
            "label": alarm.label,
            "time": alarm.time.timeIntervalSince1970
        ]

        let dateComponents = Calendar.current.dateComponents(
            [.hour, .minute],
            from: alarm.time
        )

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true
        )

        let request = UNNotificationRequest(
            identifier: alarm.id.uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }

    func cancelLocalNotificationMethod(alarm: AlarmData) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(
                withIdentifiers: [alarm.id.uuidString]
            )
    }
}
