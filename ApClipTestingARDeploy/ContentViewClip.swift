//
//  ContentView.swift
//  TestingARDeployAppClip
//
//  Created by Arie Williams on 1/3/23.
//

import SwiftUI
import RealityKit
import ARKit

struct ContentViewClip : View {
    var body: some View {
        ARViewContainerClip().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainerClip: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        //Set up for session to begin
        let arView = ARView(frame: .zero)
        let placeConfiguration = ARWorldTrackingConfiguration()
        let session = arView.session
        
        // Add the Confiugration for the world's plane detection
        placeConfiguration.planeDetection = [.vertical]
        
        session.run(placeConfiguration)
        
        // Add Coaching Overlay
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.session = session
        coachingOverlay.goal = .verticalPlane
        arView.addSubview(coachingOverlay)
        
        //Set Debug options
#if DEBUG
        arView.debugOptions = [.showAnchorGeometry]
#endif
  
        //handle taps
        arView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: context.coordinator,
                action: #selector(CoordinatorClip.handleTap)
            )
        )
        
        //handle sesison events via delegate
        context.coordinator.view = arView

        return arView
        
    }
    
    func makeCoordinator() -> CoordinatorClip {
        CoordinatorClip()
    }
    
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}



class CoordinatorClip: NSObject, ARSessionDelegate {
    weak var view: ARView?
    var modelEntity: ModelEntity?
    
    func session( session: ARSession, didAnchor anchors: [ARAnchor]) {
        guard let view = self.view else {return}
        debugPrint("Anchors have been added to scene: ", anchors)
    }
    
    @objc func handleTap(touch: UITapGestureRecognizer) {
        guard let view = self.view else { return }
        
        //Find Location of Touch
        let results = view.raycast(from: touch.location(in: view), allowing: .estimatedPlane, alignment: .vertical)
        
        //config door model
        let doorEntity = try! DoorModel.load_DoorModel()
        doorEntity.scale = [1,1,1]
        
        if let result = results.first {
            let anchorEntity = AnchorEntity(world: result.worldTransform)
            anchorEntity.addChild(doorEntity)
            view.scene.addAnchor(anchorEntity)
        }
        
    }
}

#if DEBUG
struct ContentsView_Previews : PreviewProvider {
    static var previews: some View {
        ContentViewClip()
    }
}
#endif
