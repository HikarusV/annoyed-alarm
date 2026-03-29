//
//  ARViewContainer.swift
//  annoyed-alarm
//
//  Created by Nazwa Sapta Pradana on 23/03/26.
//

import SwiftUI
import RealityKit
import ARKit
import Combine

struct ARViewContainer: UIViewRepresentable {
    
    let target: SIMD3<Float>
    var viewModel: ChallengeViewModel?
    var onReachTarget: (() -> Void)?
    var onLeaveArea: (() -> Void)?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(target: target, viewModel: viewModel, onReachTarget: onReachTarget, onLeaveTarget: onLeaveArea)
    }
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        // ✅ Config AR
        let config = ARWorldTrackingConfiguration()
        config.worldAlignment = .gravity
        config.planeDetection = [.horizontal] // penting biar detect lantai
        
        arView.session.run(config)
        
        context.coordinator.arView = arView
        
        arView.scene.subscribe(to: SceneEvents.Update.self) { _ in
            context.coordinator.checkDistance()
        }
        
        // ⏳ Delay dikit biar plane kebaca dulu
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            placeAnchor(arView: arView, context: context)
        }
        
        // ✅ Timer cek jarak
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
            context.coordinator.checkDistance()
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            trySnapToPlane(arView: arView, context: context)
        }
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    // MARK: - Placement
    
    private func placeAnchor(arView: ARView, context: Context) {
        
        // 1️⃣ Coba raycast ke lantai
        if let query = arView.makeRaycastQuery(
            from: arView.center,
            allowing: .estimatedPlane,
            alignment: .horizontal
        ),
        let result = arView.session.raycast(query).first {
            
            print("✅ Pakai lantai")
            
            let position = SIMD3<Float>(
                result.worldTransform.columns.3.x,
                result.worldTransform.columns.3.y,
                result.worldTransform.columns.3.z
            )
            
            createAnchor(at: position, arView: arView, context: context, isFloating: false)
            
        } else {
            // ❌ fallback ke target awal
            print("❌ Gagal detect lantai → pakai target awal")
            
            createAnchor(at: target, arView: arView, context: context, isFloating: true)
        }
    }
    
    private func createAnchor(
        at position: SIMD3<Float>,
        arView: ARView,
        context: Context,
        isFloating: Bool
    ) {
        let anchor = AnchorEntity(world: position)
        context.coordinator.anchor = anchor
        
        // 🔴 Cone
        let point = ModelEntity(
            mesh: .generateCone(height: 0.3, radius: 0.1),
            materials: [SimpleMaterial(color: .red, isMetallic: false)]
        )
        
        point.orientation = simd_quatf(angle: .pi, axis: [1, 0, 0])
        
        // Kalau di lantai → duduk
        // Kalau floating → biarin di tengah
        point.position.y = isFloating ? 0 : 0.15
        
        anchor.addChild(point)
        
        // 🔵 Radius
        let acceptanceRadius: Float = 1.5
        let circle = ModelEntity(
            mesh: .generateCylinder(height: 0.01, radius: acceptanceRadius),
            materials: [SimpleMaterial(color: .blue.withAlphaComponent(0.3), isMetallic: false)]
        )
        
        anchor.addChild(circle)
        
        arView.scene.addAnchor(anchor)
        
        // ✨ Animasi tetap jalan
        animatePoint(point)
    }
    
    // MARK: - Animation
    
    private func animatePoint(_ entity: ModelEntity) {
        let baseY: Float = 0.15
        let floatHeight: Float = 0.4
        
        func loopUp() {
            var upTransform = entity.transform
            upTransform.translation.y = baseY + floatHeight
            
            entity.move(
                to: upTransform,
                relativeTo: entity.parent,
                duration: 1.0,
                timingFunction: .easeInOut
            )
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                loopDown()
            }
        }
        
        func loopDown() {
            var downTransform = entity.transform
            downTransform.translation.y = baseY
            
            entity.move(
                to: downTransform,
                relativeTo: entity.parent,
                duration: 1.0,
                timingFunction: .easeInOut
            )
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                loopUp()
            }
        }
        
        loopUp()
    }
    
    private func trySnapToPlane(arView: ARView, context: Context) {
        
        // ❌ kalau sudah pernah berhasil → stop
        if context.coordinator.hasSnappedToPlane { return }
        
        guard let query = arView.makeRaycastQuery(
            from: arView.center,
            allowing: .estimatedPlane,
            alignment: .horizontal
        ) else { return }
        
        let results = arView.session.raycast(query)
        
        guard let result = results.first,
              let anchor = context.coordinator.anchor else { return }
        
        print("🎯 Berhasil detect lantai → snapping")
        
        let newPosition = SIMD3<Float>(
            result.worldTransform.columns.3.x,
            result.worldTransform.columns.3.y,
            result.worldTransform.columns.3.z
        )
        
        // ✨ Smooth move ke lantai
        var transform = anchor.transform
        transform.translation = newPosition
        
        anchor.move(
            to: transform,
            relativeTo: nil,
            duration: 0.5,
            timingFunction: .easeInOut
        )
        
        context.coordinator.hasSnappedToPlane = true
    }
}

