//
//  FaceARContainer.swift
//  annoyed-alarm
//
//  Created by Nazwa Sapta Pradana on 24/03/26.
//


internal import SwiftUI
import ARKit

struct FaceARContainer: UIViewRepresentable {
    @ObservedObject var viewModel: FaceARViewModel
    
    func makeUIView(context: Context) -> ARSCNView {
        let view = ARSCNView()
        view.delegate = context.coordinator
        
        guard ARFaceTrackingConfiguration.isSupported else {
            print("Face tracking not supported")
            return view
        }
        
        let config = ARFaceTrackingConfiguration()
        view.session.run(config)
        
        return view
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {}
    
    func makeCoordinator() -> CoordinatorFaceChallenge {
        CoordinatorFaceChallenge(viewModel: viewModel)
    }
}
