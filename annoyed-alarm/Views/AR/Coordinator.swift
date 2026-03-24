//
//  Coordinator.swift
//  annoyed-alarm
//
//  Created by Nazwa Sapta Pradana on 23/03/26.
//

//import SwiftUI
import RealityKit
import ARKit
import Combine

class Coordinator {
    weak var arView: ARView?
    var anchor: AnchorEntity?
    
    let target: SIMD3<Float>
    var viewModel: ChallengeViewModel?
    let onReachTarget: (() -> Void)?
    let onLeaveTarget: (() -> Void)?
    
    private var hasReached = false
    var hasSnappedToPlane = false // 🔥 penting
    
    init(target: SIMD3<Float>,
         viewModel: ChallengeViewModel?,
         onReachTarget: (() -> Void)?,
         onLeaveTarget: (() -> Void)?
    ) {
        self.target = target
        self.viewModel = viewModel
        self.onReachTarget = onReachTarget
        self.onLeaveTarget = onLeaveTarget
    }
    
    func checkDistance() {
        guard
            let arView = arView,
            let frame = arView.session.currentFrame,
            let anchor = anchor
        else { return }
        
        let cameraTransform = frame.camera.transform
        
        DispatchQueue.main.async {
            self.viewModel?.currentCameraTransform = cameraTransform
        }
        
        let cameraPosition = SIMD3<Float>(
            cameraTransform.columns.3.x,
            cameraTransform.columns.3.y,
            cameraTransform.columns.3.z
        )
        
        let targetPosition = anchor.position(relativeTo: nil)
        let distance = simd_distance(cameraPosition, targetPosition)
        
        DispatchQueue.main.async {
            self.viewModel?.distanceToTarget = distance
        }
        
        if distance < 1.5 && !hasReached {
            hasReached = true
            onReachTarget?()
        }
        
        if distance > 1.5 {
            hasReached = false
            onLeaveTarget?()
        }
    }
}
