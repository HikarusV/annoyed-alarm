internal import SwiftUI

struct AlarmListView: View {
    @StateObject var vm = AlarmListViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var activeSheet: ActiveSheet?

    var body: some View {
        ZStack {
            Color.backgroundDefault
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // MARK: - Custom Navigation Bar
                HStack {

                    Text("Alarm")
                        .foregroundColor(.textPrimary)
                        .font(.system(size: 28, weight: .bold))

                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)
                .padding(.bottom, 18)

                // MARK: - Alarm List
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(vm.alarms) { alarm in
                            alarmRow(alarm: alarm)
                        }
                    }
                    .padding(.horizontal)
                }

                Spacer()

                // MARK: - Add Alarm Button
                HStack {
                    Button(action: {
                        activeSheet = .add
                    }) {
                        Text("Add Alarm")
                            .foregroundColor(.textPrimary)
                            .font(.system(size: 17, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.surface500)
                            .cornerRadius(24)
                            .padding(.horizontal)
                            .padding(.bottom, 20)
                    }
                    
//                    Button(action: {
//                            let id = UUID()
//
//                            let content = UNMutableNotificationContent()
//                            content.title = "Test Alarm"
//                            content.body = "Dynamic Island should appear, notif..."
//                            content.sound = .default
//                            
//                            // ✅ kirim data ke handler
//                            content.userInfo = [
//                                "alarmId": id.uuidString,
//                                "label": "Test DyIsland"
//                            ]
//
//                            let trigger = UNTimeIntervalNotificationTrigger(
//                                timeInterval: 5,
//                                repeats: false
//                            )
//
//                            let request = UNNotificationRequest(
//                                identifier: id.uuidString,
//                                content: content,
//                                trigger: trigger
//                            )
//
//                            UNUserNotificationCenter.current().add(request)
                    Button(action: {
                            let alarm = AlarmData(
                                id: UUID(),
                                time: Date(),
                                isEnabled: true,
                                label: "Test DyIsland",
                                difficulty: ChallengeDifficulty.medium
                            )
//                            
//                            // 🔹 Panggil Live Activity
//                            Task {
                                AlarmLiveActivityManager.shared.start(alarm: alarm)
                                print("🔥 Dynamic Island started for:", alarm.label)
//                            }
                    }) {
                        Text("Test DyIsland")
                            .foregroundColor(.textPrimary)
                            .font(.system(size: 17, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.surface500)
                            .cornerRadius(24)
                            .padding(.horizontal)
                            .padding(.bottom, 20)

                    }
                    
                    Button(action: {
//
//                            // 🔹 Panggil Live Activity
                            Task {
                                await AlarmLiveActivityManager.shared.endAllActivities()
                            }
                    }) {
                        Text("X")
                            .foregroundColor(.textPrimary)
                            .font(.system(size: 17, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.surface500)
                            .cornerRadius(24)
                            .padding(.horizontal)
                            .padding(.bottom, 20)

                    }
                }
            }
        }
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .add:
                AlarmEditorView(onDone: {
                    vm.load()
                })
            case .edit(let alarm):
                AlarmEditorView(alarm: alarm, onDone: {
                    vm.load()
                })
            }
        }
        .onAppear {
            vm.load()
        }
        .presentationDetents([.large])
    }

    // MARK: - Alarm Row
    @ViewBuilder
    private func alarmRow(alarm: AlarmData) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(timeString(alarm.time))
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.textPrimary)

                Text(alarm.label.isEmpty ? "Alarm" : alarm.label)
                    .font(.system(size: 13))
                    .foregroundColor(.textSecondary)
            }
            .onTapGesture {
                activeSheet = .edit(alarm)
            }

            Spacer()

            Toggle("", isOn: Binding(
                get: { alarm.isEnabled },
                set: { _ in
                    Task {
                        await vm.toggle(alarm: alarm)
                        vm.load()
                    }
                }
            ))
            .tint(Color.success)
        }
        .padding()
        .background(Color.backgroundSecondary)
        .cornerRadius(16)
    }
    
    // MARK: - Time Formatter
    func timeString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

enum ActiveSheet: Identifiable {
    case add
    case edit(AlarmData)

    var id: String {
        switch self {
        case .add: return "add"
        case .edit(let alarm): return alarm.id.uuidString
        }
    }
}
