//
//  ChallengeType.swift
//  annoyed-alarm
//
//  Created by Nazwa Sapta Pradana on 23/03/26.
//


internal import SwiftUI
import CoreLocation
import AppIntents

enum ChallengeType {
    case ar
    case face
    case finish
}

enum ChallengeDifficulty: String, CaseIterable, Codable, AppEnum {
    case easy
    case medium
    case hard
    
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Difficulty")

    static var caseDisplayRepresentations: [ChallengeDifficulty: DisplayRepresentation] = [
        .easy: "Easy",
        .medium: "Medium",
        .hard: "Hard"
    ]
}

extension String {
    func toChallengeDifficulty() -> ChallengeDifficulty? {
        return ChallengeDifficulty(rawValue: self.lowercased())
    }
}

struct ChallangeProcess: Identifiable {
    let id = UUID()
    var currentChallangeType: ChallengeType = .ar
    var allChallangeFinished: Bool = false
    var difficultyChallenge: ChallengeDifficulty
}

//struct Challenge: Identifiable {
//    let id = UUID()
//    let title: String
//    var type: ChallengeType
//    var isCompleted: Bool = false
//}
