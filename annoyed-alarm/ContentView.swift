//
//  ContentView.swift
//  annoyed-alarm
//
//  Created by Nazwa Sapta Pradana on 19/03/26.
//

internal import SwiftUI
import CoreLocation
import AlarmKit

struct ContentView: View {
    @State private var alarmIsAuthorized: Bool = false
    // 1. State untuk mengontrol navigasi
    @State private var path = NavigationPath()
    @State private var challengeToOpen: String?

    var body: some View {
        NavigationStack(path: $path) {
            AlarmListView()
                .navigationDestination(for: String.self) { challengeDifficulty in
                    ChallengeView(
                        viewModel: ChallengeViewModel(
                            challangeProcess: ChallangeProcess(
                                difficultyChallenge: challengeDifficulty.toChallengeDifficulty() ?? .medium
                            )
                        ),
                        faceViewModel: FaceARViewModel(
                            difficulty: challengeDifficulty.toChallengeDifficulty() ?? .medium
                        ),
                        path: $path
                    )
                }
        }
        // 3. Dengarkan notifikasi dari AppIntent
        .onReceive(NotificationCenter.default.publisher(for: .openChallengeNotification)) { obj in
            if let type = obj.object as? String {
                // Bersihkan path dulu jika ingin reset, lalu push halaman baru
                path.removeLast(path.count)
                path.append(type)
            }
        }
    }
}
//        NavigationStack {
//            if alarmIsAuthorized {
//                AlarmListView()
//            } else {
//                Text("You Need to allow alarms in settings to use this apps")
//                    .multilineTextAlignment(.center)
//                    .padding()
//                    .glassEffect()
//            }
//        }
//        .task {
//            do {
//                try await checkAndAuthorizedAlarmKit()
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//    }
    
//    private func checkAndAuthorizedAlarmKit() async throws {
//        switch AlarmManager.shared.authorizationState {
//        case .notDetermined:
//            let status = try await AlarmManager.shared.requestAuthorization()
//            self.alarmIsAuthorized = status == .authorized
//        case .authorized:
//            self.alarmIsAuthorized = true
//        case .denied:
//            self.alarmIsAuthorized = false
//        @unknown default:
//            fatalError()
//        }
//    }
//}

//#Preview {
//    ContentView()
//}
