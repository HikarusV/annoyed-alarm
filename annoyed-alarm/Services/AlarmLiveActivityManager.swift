//
//  AlarmLiveActivityManager.swift
//  annoyed-alarm
//
//  Created by Nazwa Sapta Pradana on 20/03/26.
//


import ActivityKit
import SwiftUI

class AlarmLiveActivityManager {
    static let shared = AlarmLiveActivityManager()
    
    private var activity: Activity<AlarmAttributes>?

    func start(alarm: Alarm) {
        // ❗️ cek support device
        print("Cek activity support")
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("❌ Live Activities not enabled")
            return
        }
        print("✅ Live Activities enabled")

        // 🔹 Attributes (static)
        let attributes = AlarmAttributes(alarmName: alarm.label)
        
        // 🔹 ContentState (dynamic, ditampilkan di widget / island)
        let state = AlarmAttributes.ContentState(
            isRinging: true,
            label: alarm.label,      // tampil di Dynamic Island
            countdown: nil           // optional, bisa diisi untuk timer
        )

        do {
            let content = ActivityContent(
                state: state,
                staleDate: nil
            )

            activity = try Activity.request(
                attributes: attributes,
                content: content,
                pushType: nil
            )
            print("✅ Live Activity started: \(activity?.id ?? "nil")")
        } catch {
            print("❌ Failed to start Live Activity: \(error)")
        }
    }

    func stop() {
        Task {
            guard let activity = activity else { return }

            let finalState = AlarmAttributes.ContentState(
                isRinging: false,
                label: "",
                countdown: nil
            )
            
            let finalContent = ActivityContent(
                state: finalState,
                staleDate: nil
            )

            await activity.end(
                finalContent,
                dismissalPolicy: .immediate
            )
            print("🛑 Live Activity ended")
        }
    }
}
