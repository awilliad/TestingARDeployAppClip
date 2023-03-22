//
//  AppDelegate.swift
//  TestingARDeployAppClip
//
//  Created by Arie Williams on 1/3/23.
//

import UIKit
import SwiftUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        //GET URL Components from the incoming user activity
//        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
//              let incomingURL = userActivity.webpageURL,
//              let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true) else {
//            return false
//        }
//         debugPrint("The iincomingURL is:  ", components)
//
//        @State var modelURL: String = "Empty"
//        //Get the URL scheme set-up
//        if url.scheme == "https" && url.host == "ostusa.com" && url.path == "/ar" {
//            guard let myModel = getQueryStringParameter(url: url.absoluteString!, param: "model") else {return false}
//            modelURL = myModel
//            return true
//        }
        // Create the SwiftUI view that provides the window contents.
        let contentView = SceneTestView()
    
        //let contentView = ContentView(frameColor: <#Binding<Color>#>)
        
        
       
        
        // Use a UIHostingController as window root view controller.
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIHostingController(rootView: contentView)
        self.window = window
        window.makeKeyAndVisible()
        return true
    }
    
    func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else {return nil}
        return url.queryItems?.first(where: {$0.name == param})?.value
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    
}

