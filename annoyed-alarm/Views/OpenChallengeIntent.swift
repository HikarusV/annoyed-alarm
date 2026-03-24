//
//  OpenChallengeIntent.swift
//  annoyed-alarm
//
//  Created by Nazwa Sapta Pradana on 23/03/26.
//

import AppIntents

struct OpenChallengeIntent: AppIntent {
    static var title: LocalizedStringResource = "Open Challenge"
    static var openAppWhenRun: Bool = true

    @Parameter(title: "Difficulty Challange")
    var challengeDifficulty: ChallengeDifficulty

    // Wajib ada init kosong
    init() {}

    // Perbaikan: Inisialisasi parameter dengan nilai string
    init(challengeDifficulty: ChallengeDifficulty) {
        self.challengeDifficulty = challengeDifficulty
    }

    @MainActor
    func perform() async throws -> some IntentResult {
        // Simpan ke UserDefaults atau kirim Notification
        NotificationCenter.default.post(
            name: .openChallengeNotification,
            object: challengeDifficulty.rawValue.capitalized
        )
        return .result()
    }
}

extension Notification.Name {
    static let openChallengeNotification = Notification.Name("openChallengeNotification")
}
