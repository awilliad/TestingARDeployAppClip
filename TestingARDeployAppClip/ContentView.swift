//
//  ContentView.swift
//  TestingARDeployAppClip
//
//  Created by Arie Williams on 1/3/23.
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    @Binding var frameColor: Color
    var body: some View {
        ARViewContainer(theFrameColor: self.$frameColor).edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var theFrameColor: Color 
    func hasObjReference()-> Bool {
        if false {
            return true
        }
        else{
            return false
        }
    }
    func makeUIView(context: Context) -> ARView {
        //Set up for session to begin
        let arView = ARView(frame: .zero)
        let placeConfiguration = ARWorldTrackingConfiguration()
        let session = arView.session
        
        let tempConfig = ARObjectScanningConfiguration()
        // Add the Confiugration for the world's plane detection
        placeConfiguration.planeDetection = [.vertical]
        placeConfiguration.environmentTexturing = .automatic
        placeConfiguration.sceneReconstruction = .mesh
        
        session.run(placeConfiguration)
        
        //create the object reference
//        createReferenceObject
        
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
                action: #selector(Coordinator.handleTap)
            )
        )
        
        //handle sesison events via delegate
        context.coordinator.view = arView
        context.coordinator.myFrameColor = theFrameColor

        return arView
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}



class Coordinator: NSObject, ARSessionDelegate {
    weak var view: ARView?
    var modelEntity: ModelEntity?
    var myFrameColor: Color = Color.blue
    
    func session( session: ARSession, didAnchor anchors: [ARAnchor]) {
        guard self.view != nil else {return}
        debugPrint("Anchors have been added to scene: ", anchors)
    }
    
    @objc func handleTap(touch: UITapGestureRecognizer) {
        guard let view = self.view else { return }
        
        //Find Location of Touch
        let results = view.raycast(from: touch.location(in: view), allowing: .estimatedPlane, alignment: .vertical)
        
        //config door model
        let doorEntity = try! DoorModel.load_DoorModel()
        doorEntity.scale = [1,1,1]
        var material = SimpleMaterial()
        
        material.color = .init(tint: UIColor(myFrameColor))
        
        if let result = results.first {
            let anchorEntity = AnchorEntity(world: result.worldTransform)
            
            
            anchorEntity.addChild(doorEntity)
            view.scene.addAnchor(anchorEntity)
        }
        
    }
}

#if DEBUG
//struct ContentView_Previews : PreviewProvider {
//    static var previews: some View {
//        ContentView(frameColor: UIColor(Color.blue))
//    }
//}
#endif
