//
//  FaceChallengeViewModel.swift
//  annoyed-alarm
//
//  Created by Nazwa Sapta Pradana on 24/03/26.
//

import ARKit
import Combine

class FaceARViewModel: ObservableObject {
    
    // Output
    @Published var currentExpression: FaceExpression = .neutral
    @Published var isMatch: Bool = false
    @Published var isCompleted: Bool = false
    
    // Game state
    @Published var targetExpressions: [FaceExpression] = []
    @Published var currentIndex: Int = 0
    
    // Stabilizer
    private var history: [FaceExpression] = []
    
    // Control biar ga double trigger
    private var isAdvancing: Bool = false
    
    init(difficulty: ChallengeDifficulty) {
        self.targetExpressions = generateUniqueRandomExpressions(
            count: difficulty == .hard ? 3 : 1
        )
    }
    
    func processBlendShapes(_ blendShapes: [ARFaceAnchor.BlendShapeLocation: NSNumber]) {
        
        let detected = detectExpression(blendShapes: blendShapes)
        let stable = stabilizedExpression(new: detected)
        
        DispatchQueue.main.async {
            self.currentExpression = stable
            
            if let target = self.currentTarget {
                self.isMatch = (stable == target)
            } else {
                self.isMatch = false
            }
            
            self.handleMatchIfNeeded()
        }
    }
    
    var currentTarget: FaceExpression? {
        guard currentIndex < targetExpressions.count else { return nil }
        return targetExpressions[currentIndex]
    }
    
    func handleMatchIfNeeded() {
        guard isMatch, !isAdvancing, !isCompleted else { return }
        
        isAdvancing = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            self.currentIndex += 1
            
            if self.currentIndex >= self.targetExpressions.count {
                self.isCompleted = true
                self.isMatch = false
                print("🎉 Challenge selesai")
            } else {
                // lanjut ke target berikutnya
                self.isMatch = false
            }
            
            self.isAdvancing = false
        }
    }
    
    // MARK: - Detection
    private func detectExpression(blendShapes: [ARFaceAnchor.BlendShapeLocation: NSNumber]) -> FaceExpression {
        
        let smileL = blendShapes[.mouthSmileLeft]?.floatValue ?? 0
        let smileR = blendShapes[.mouthSmileRight]?.floatValue ?? 0
        let jawOpen = blendShapes[.jawOpen]?.floatValue ?? 0
        let browDownL = blendShapes[.browDownLeft]?.floatValue ?? 0
        let browDownR = blendShapes[.browDownRight]?.floatValue ?? 0
        let browUp = blendShapes[.browInnerUp]?.floatValue ?? 0
        let eyeBlinkL = blendShapes[.eyeBlinkLeft]?.floatValue ?? 0
        let eyeBlinkR = blendShapes[.eyeBlinkRight]?.floatValue ?? 0
        let mouthPucker = blendShapes[.mouthPucker]?.floatValue ?? 0
        let frownL = blendShapes[.mouthFrownLeft]?.floatValue ?? 0
        let frownR = blendShapes[.mouthFrownRight]?.floatValue ?? 0
        
        let smileAvg = (smileL + smileR) / 2
        let frownAvg = (frownL + frownR) / 2
        
        if smileAvg > 0.7 { return .bigSmile }
        if smileAvg > 0.4 { return .smile }
        
        if jawOpen > 0.7 && browUp > 0.5 { return .surprised }
        
        if browDownL > 0.5 && browDownR > 0.5 { return .angry }
        
        if frownAvg > 0.5 { return .sad }
        
        if eyeBlinkL > 0.7 && eyeBlinkR < 0.3 { return .winkLeft }
        if eyeBlinkR > 0.7 && eyeBlinkL < 0.3 { return .winkRight }
        
        if eyeBlinkL > 0.7 && eyeBlinkR > 0.7 { return .blink }
        
        if jawOpen > 0.5 { return .mouthOpen }
        
        if mouthPucker > 0.6 { return .kiss }
        
        if browUp > 0.6 { return .eyebrowRaise }
        
        return .neutral
    }
    
    // MARK: - Stabilizer
    private func stabilizedExpression(new: FaceExpression) -> FaceExpression {
        history.append(new)
        
        if history.count > 5 {
            history.removeFirst()
        }
        
        let counts = Dictionary(grouping: history, by: { $0 })
            .mapValues { $0.count }
        
        return counts.max(by: { $0.value < $1.value })?.key ?? .neutral
    }
    
    // MARK: - Game Logic
    func generateUniqueRandomExpressions(count: Int) -> [FaceExpression] {
        let pool = FaceExpression.allCases.filter { $0 != .neutral }
        return Array(pool.shuffled().prefix(count))
    }
}
