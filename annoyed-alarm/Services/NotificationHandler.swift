//
//  NotificationHandler.swift
//  annoyed-alarm
//
//  Created by Nazwa Sapta Pradana on 20/03/26.
//

import UserNotifications
import SwiftUI
import ActivityKit

class NotificationHandler: NSObject, UNUserNotificationCenterDelegate {
    
    static let shared = NotificationHandler()
    
    // MARK: - Foreground → trigger Dynamic Island
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        
        let userInfo = notification.request.content.userInfo
        
        // Ambil data alarm dari userInfo
        let label = userInfo["label"] as? String ?? "Alarm"
        let idString = userInfo["alarmId"] as? String
        let id = UUID(uuidString: idString ?? "") ?? UUID()
        let timeInterval = userInfo["time"] as? TimeInterval ?? Date().timeIntervalSince1970
        let time = Date(timeIntervalSince1970: timeInterval)
        
        // Rekonstruksi alarm object
        let alarm = AlarmData(
            id: id,
            time: time,
            isEnabled: true,
            label: label,
            difficulty: .medium
        )
        
        print("🔥 Notification received, starting Dynamic Island for:", alarm.label)
        
        // ✅ Panggil Live Activity
        Task {
            AlarmLiveActivityManager.shared.start(alarm: alarm)
        }
        
        // Tampilkan banner + sound
        return [.banner, .sound]
    }

    // MARK: - Tap notif → trigger UI / app logic
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        
        DispatchQueue.main.async {
            // Bisa pakai notification center untuk open alarm UI
            NotificationCenter.default.post(
                name: .alarmTriggered,
                object: nil
            )
        }
    }
}
