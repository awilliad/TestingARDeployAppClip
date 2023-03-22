//
//  SceneTestView.swift
//  TestingARDeployAppClip
//
//  Created by Arie Williams on 3/21/23.
//

import SwiftUI
import RealityKit
import ARKit

struct SceneTestView: View {
    @State private var modelLoaded = false
    @State private var modelEntity: ModelEntity?
    
    var body: some View {
        ZStack {
            MyARViewContainer(modelLoaded: $modelLoaded, modelEntity: $modelEntity)
                .edgesIgnoringSafeArea(.all)
            if !modelLoaded {
                ProgressView("Loading model...")
                    .foregroundColor(.white)
            }
        }
    }
}

struct MyARViewContainer: UIViewRepresentable {
    @Binding var modelLoaded: Bool
    @Binding var modelEntity: ModelEntity?
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        arView.session.delegate = context.coordinator
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        guard let modelURL = URL(string: "https://github.com/awilliad/misc/blob/main/Chair/chair.usdz") else { return }
    
        
        if !modelLoaded {
            let anchor = AnchorEntity(plane: .horizontal)
            uiView.scene.addAnchor(anchor)
            let modelEntity = try! ModelEntity.load(contentsOf: modelURL)
            self.modelEntity = modelEntity as? ModelEntity
            anchor.addChild(modelEntity)
            modelLoaded = true
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, ARSessionDelegate {
        var parent: MyARViewContainer

        init(_ parent: MyARViewContainer) {
            self.parent = parent
        }

        func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        }
    }
}

struct SceneTestView_Previews: PreviewProvider {
    static var previews: some View {
        SceneTestView()
    }
}
