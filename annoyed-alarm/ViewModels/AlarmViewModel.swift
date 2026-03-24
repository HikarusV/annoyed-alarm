//
//  AlarmViewModel.swift
//  annoyed-alarm
//
//  Created by Nazwa Sapta Pradana on 20/03/26.
//


//import SwiftUI
//import Combine
//
//class AlarmViewModel: ObservableObject {
//    
//    @Published var isAlarmRinging = false
//
//    init() {
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(handleAlarm),
//            name: .alarmTriggered,
//            object: nil
//        )
//    }
//
//    @objc private func handleAlarm() {
//        isAlarmRinging = true
//    }
//
//    func stopAlarm() {
//        isAlarmRinging = false
//        AlarmLiveActivityManager.shared.stop()
//    }
//}
