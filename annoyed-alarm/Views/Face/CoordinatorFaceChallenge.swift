//
//  CoordinatorFaceChallenge.swift
//  annoyed-alarm
//
//  Created by Nazwa Sapta Pradana on 24/03/26.
//


import ARKit

class CoordinatorFaceChallenge: NSObject, ARSCNViewDelegate {
    
    var viewModel: FaceARViewModel
    private var lastUpdate = Date()
    
    init(viewModel: FaceARViewModel) {
        self.viewModel = viewModel
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        let now = Date()
        guard now.timeIntervalSince(lastUpdate) > 0.1 else { return }
        lastUpdate = now
        
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        
        viewModel.processBlendShapes(faceAnchor.blendShapes)
    }
}
