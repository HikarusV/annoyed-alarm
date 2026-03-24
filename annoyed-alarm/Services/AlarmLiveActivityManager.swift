//
//  AlarmLiveActivityManager.swift
//  annoyed-alarm
//
//  Created by Nazwa Sapta Pradana on 20/03/26.
//


import ActivityKit
internal import SwiftUI

class AlarmLiveActivityManager {
    static let shared = AlarmLiveActivityManager()
    
    private var activity: Activity<AlarmAttributesData>?
    
    func endAllActivities() async {
            for activity in Activity<AlarmAttributesData>.activities {
                await activity.end(
                    ActivityContent(state: activity.content.state, staleDate: nil),
                    dismissalPolicy: .immediate
                )
                
                print("Activity ended \(activity.id)")
            }
        }

    func start(alarm: AlarmData) {
        // ❗️ cek support device
        print("Cek activity support")
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("❌ Live Activities not enabled")
            return
        }
        print("✅ Live Activities enabled")

        // 🔹 Attributes (static)
        let attributes = AlarmAttributesData(alarmName: alarm.label)
        
        // 🔹 ContentState (dynamic, ditampilkan di widget / island)
        let state = AlarmAttributesData.ContentState(
            isRinging: true,
            label: alarm.label,      // tampil di Dynamic Island
            countdown: 60,
            challengeDifficulty: alarm.difficulty
        )

        do {
//            Task {
//                await endAllActivities()
//            }
            let activities = Activity<AlarmAttributesData>.activities
                
            print("🔍 Active Live Activities count:", activities.count)
            
            for activity in activities {
                print("🆔 ID:", activity.id)
                print("📊 State:", activity.content.state)
                print("🕒 Push Token:", activity.pushToken ?? "nil")
                print("------")
            }
            
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

            let finalState = AlarmAttributesData.ContentState(
                isRinging: false,
                label: "",
                countdown: nil,
                challengeDifficulty: .medium
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
