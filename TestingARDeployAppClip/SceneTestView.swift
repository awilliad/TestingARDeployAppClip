//
//  SceneTestView.swift
//  TestingARDeployAppClip
//
//  Created by Arie Williams on 3/21/23.
//

import SwiftUI
import ModelIO
import SceneKit.ModelIO
import SceneKit

struct SceneTestView: View {
    var body: some View {
        if let url = URL.init(string: "https://github.com/awilliad/misc/tree/main/Chair/Chair.obj") {
            let asset = MDLAsset(url: url)
            let object = asset.object(at: 0)
            
        }
        
    }
}

struct SceneTestView_Previews: PreviewProvider {
    static var previews: some View {
        SceneTestView()
    }
}
