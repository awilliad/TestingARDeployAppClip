//
//  ApClipTestingARDeployApp.swift
//  ApClipTestingARDeploy
//
//  Created by Arie Williams on 1/5/23.
//

import SwiftUI

@main
struct ApClipTestingARDeployApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentViewClip()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
