//
//  annoyed_alarmApp.swift
//  annoyed-alarm
//
//  Created by Nazwa Sapta Pradana on 19/03/26.
//

internal import SwiftUI

@main
struct annoyed_alarmApp: App {
    
    init() {
        let center = UNUserNotificationCenter.current()
        center.delegate = NotificationHandler.shared
        
        AlarmScheduler.shared.requestLocalNotificationPermission()
        
//        print("Hello Wordl!")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
