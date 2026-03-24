//
//  ChallengeView.swift
//  annoyed-alarm
//
//  Created by Nazwa Sapta Pradana on 23/03/26.
//

internal import SwiftUI
internal import _LocationEssentials
import Combine
import simd

struct ChallengeView: View {
    @ObservedObject var viewModel: ChallengeViewModel
    @ObservedObject var faceViewModel: FaceARViewModel
    @Environment(\.dismiss) var dismiss
    @State var currentInArea: Bool = false
    
    @State private var arrowAngle: Double = 0.0
    
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                if !faceViewModel.isCompleted {
                    VStack {
                        Text({
                            switch viewModel.challangeProcess.currentChallangeType {
                            case .face:
                                return "Follow the facial expressions below"
                            case .ar:
                                return "Follow the arrows to reach the checkpoint"
                            case .finish:
                                return "Error"
                            }
                        }())
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 150)
                        .multilineTextAlignment(.center)
                        
                        Text(viewModel.challangeProcess.currentChallangeType == .ar
                             ? "\(viewModel.distanceToTarget, specifier: "%.2f") m"
                             : "\(faceViewModel.currentIndex + 1) / \(faceViewModel.targetExpressions.count)"
                        )
                            .foregroundColor(currentInArea ? .green : .white)
                            .font(.headline)
                    }
                }
                
                switch viewModel.challangeProcess.currentChallangeType {
                case .ar:
                    ZStack {
                        //MARK: - ARView
                        ARViewContainer(
                            target: ChallengeViewModel.generateTargetPoint(),
                            viewModel: viewModel,
                            onReachTarget: {
                                currentInArea = true
                                
                                switch viewModel.challangeProcess.difficultyChallenge {
                                case .medium, .hard:
                                    viewModel.updateChallangeType(to: .face)
                                case .easy:
                                    break
                                }
                                
                            },
                            onLeaveArea: {
                                currentInArea = false
                            }
                        )
                        .ignoresSafeArea()
                        
                        //MARK: - Overlay compass
                        GeometryReader { geo in
                            CompassArrow(angle: arrowAngle)
                                .frame(width: 50, height: 50)
                                .position(
                                    x: geo.size.width / 2,
                                    y: geo.size.height - 80
                                )
                        }
                        .allowsHitTesting(false) // biar touch tetap ke ARView
                    }
                    .onAppear {
                        // Timer update arrow setiap 0.1 detik
                        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                            updateArrowAngle()
                        }
                    }
                    
                case .face:
                    ZStack {
                        
                        // AR Camera
                        FaceARContainer(
                            viewModel: faceViewModel
                        )
                        .ignoresSafeArea()
                        
                        // Overlay UI
                        VStack {
                            Text(faceViewModel.currentTarget?.rawValue.uppercased() ?? "-")
                                .font(.largeTitle)
                                .bold()
                            
                            Text("Current: \(faceViewModel.currentExpression.rawValue)")
                                .font(.caption)
                            
                            Text(faceViewModel.isMatch ? "✅ MATCH!" : "Follow the image")
                                .font(.title2)
                                .foregroundColor(faceViewModel.isMatch ? .green : .red)
                        }
                        .foregroundColor(.white)
                    }
                case .finish:
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Text("🎉 Challenge Complete")
                            .font(.largeTitle)
                            .bold()
                        
                        Text("⏰ Alarm Turn Off")
                            .font(.title2)
                        
                        Text("Happy Nice Day!")
                            .font(.title3)
                        
                        Spacer()
                        
                        Button(action: {
                            path.removeLast(path.count)
                        }) {
                            Text("Finish")
                                .foregroundColor(.textPrimary)
                                .font(.system(size: 17, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.surface500)
                                .cornerRadius(24)
                                .padding(.horizontal)
                                .padding(.bottom, 20)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $faceViewModel.isCompleted) {
            VStack(spacing: 20) {
                Spacer()
                
                Text("🎉 Challenge Complete")
                    .font(.largeTitle)
                    .bold()
                
                Text("⏰ Alarm Turn Off")
                    .font(.title2)
                
                Text("Happy Nice Day!")
                    .font(.title3)
                
                Spacer()
                
                Button(action: {
                    path.removeLast(path.count)
                }) {
                    Text("Finish")
                        .foregroundColor(.textPrimary)
                        .font(.system(size: 17, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.surface500)
                        .cornerRadius(24)
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            .padding()
            .onAppear() {
                Task {
                    await AlarmLiveActivityManager.shared.endAllActivities()
                }
            }
        }
    }
    
    // MARK: - Hitung angle horizontal
    func updateArrowAngle() {
        guard let transform = viewModel.currentCameraTransform else { return }

        let cameraPos = transform.translation
        let cameraForward = transform.forward
        let targetPos = ChallengeViewModel.targetPosition

        let toTarget = targetPos - cameraPos

        // Flatten ke horizontal
        let forward2D = SIMD2<Float>(cameraForward.x, cameraForward.z)
        let target2D = SIMD2<Float>(toTarget.x, toTarget.z)

        let angle = atan2(
            forward2D.x * target2D.y - forward2D.y * target2D.x,
            forward2D.x * target2D.x + forward2D.y * target2D.y
        )

        DispatchQueue.main.async {
            let newAngle = Double(angle)
            
            // Hitung selisih sudut (biar gak loncat)
            var delta = newAngle - self.arrowAngle
            
            // Wrap ke range -π ... π
            if delta > .pi {
                delta -= 2 * .pi
            } else if delta < -.pi {
                delta += 2 * .pi
            }
            
            // Smooth (low-pass filter)
            let smoothing: Double = 0.15
            self.arrowAngle += delta * smoothing
        }
    }

    func computeYawAngle(camera: SIMD3<Float>, target: SIMD3<Float>) -> Double {
        var dir = target - camera
        dir.y = 0
        let len = simd_length(dir)
        if len < 0.001 { return 0 }
        dir = dir / len
        return Double(atan2(dir.x, dir.z)) // horizontal only
    }
}

struct CompassArrow: View {
    var angle: Double

    var body: some View {
        ZStack {
            // Background circle biar keliatan kayak compass
            Circle()
                .fill(Color.black.opacity(0.4))
                .frame(width: 80, height: 80)

            // Arrow
            Image(systemName: "location.north.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.red)
                .rotationEffect(.radians(angle))
                .animation(.easeOut(duration: 0.1), value: angle)
        }
    }
}

extension simd_float4x4 {
    var translation: SIMD3<Float> {
        SIMD3(columns.3.x, columns.3.y, columns.3.z)
    }

    var forward: SIMD3<Float> {
        -SIMD3(columns.2.x, columns.2.y, columns.2.z)
    }
}

//#Preview {
//    let arChallenge = Challenge(
//        title: "AR Challenge",
//        type: .ar(pointCoordinate: .init(latitude: 0, longitude: 0)),
//        isCompleted: false
//    )
//    let vm = ChallengeViewModel(challenge: arChallenge)
//    
//    // KUNCI: Harus return View
//    return ChallengeView(viewModel: vm)
//}
