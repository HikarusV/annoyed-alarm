//
//  AlarmScheduler.swift
//  annoyed-alarm
//
//  Created by Nazwa Sapta Pradana on 19/03/26.
//


import UserNotifications

class AlarmScheduler {
    static let shared = AlarmScheduler()

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound]
        ) { _, _ in }
    }

    func schedule(alarm: Alarm) {
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

    func cancel(alarm: Alarm) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(
                withIdentifiers: [alarm.id.uuidString]
            )
    }
}
