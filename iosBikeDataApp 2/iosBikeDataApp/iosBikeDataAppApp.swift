//
//  iosBikeDataAppApp.swift
//  iosBikeDataApp
//
//  Created by user245042 on 8/26/23.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct iosBikeDataAppApp: App {
    @StateObject var locationViewModel = LocationSearchViewModel()
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        
        @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
        WindowGroup {
            ContentView()
                .environmentObject(locationViewModel)
        }
    }
}
