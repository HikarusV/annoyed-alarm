//
//  annoyed_alarmApp.swift
//  annoyed-alarm
//
//  Created by Nazwa Sapta Pradana on 19/03/26.
//

import SwiftUI

@main
struct annoyed_alarmApp: App {
    
    init() {
        let center = UNUserNotificationCenter.current()
        center.delegate = NotificationHandler.shared
        
        AlarmScheduler.shared.requestPermission()
        
        print("Hello Wordl!")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
