//
//  ChallengeViewModel.swift
//  annoyed-alarm
//
//  Created by Nazwa Sapta Pradana on 23/03/26.
//


internal import SwiftUI
import CoreLocation
import Combine
import ARKit

class ChallengeViewModel: ObservableObject {
//    @Published private(set) var challenge: Challenge
    @Published var distanceToTarget: Float = 0
    @Published var currentCameraTransform: simd_float4x4?
    @Published private(set) var challangeProcess: ChallangeProcess
    
//    weak var arView: ARView?  // reference ARView dari ARViewContainer
    static var targetPosition: SIMD3<Float> = SIMD3<Float>(0, 0, 0) // default target
    
    init(challangeProcess: ChallangeProcess) {
        self.challangeProcess = challangeProcess
    }
    
    func updateChallangeType(to newType: ChallengeType) {
        challangeProcess.currentChallangeType = newType
    }
    
//    init(challenge: Challenge) {
//        self.challenge = challenge
//    }
//    
//    func completeChallenge() {
//        challenge.isCompleted = true
//    }
//    
//    // MARK: - Computed Properties
//    
//    var title: String {
//        challenge.title
//    }
//    
//    var isCompleted: Bool {
//        challenge.isCompleted
//    }
//    
//    var type: ChallengeType {
//        challenge.type
//    }
    
    func getTargetPosition() -> SIMD3<Float> {
        Self.targetPosition
    }
    
    static func generateTargetPoint() -> SIMD3<Float> {
        let x = Float.random(in: -2...2)
        let z = Float.random(in: -2...2)
        targetPosition = SIMD3<Float>(x, 0, z)
        return targetPosition
    }
}
