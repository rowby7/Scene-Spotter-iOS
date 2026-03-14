//
//  SceneSpotterApp.swift
//  SceneSpotter
//
//  Created by Rowby Villanueva on 11/24/25.
//

import SwiftUI
import FirebaseCore

@main
struct SceneSpotterApp: App {
    @State private var authManager: AuthManager
    
    init() {
        // Configure Firebase
        if FirebaseApp.app() == nil {
            if let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") {
                FirebaseApp.configure()
            } else {
                print("⚠️ WARNING: GoogleService-Info.plist not found!")
                print("Please download it from https://console.firebase.google.com/")
            }
        }
        self.authManager = AuthManager()
    }
    
    var body: some Scene {
        WindowGroup {
            if authManager.user != nil { // <-- Check if you have a non-nil user (means there is a logged in user)
                
                // We have a logged in user, go to ChatView
                NavigationStack {
                    MapView()
                }
            } else {
                
                // No logged in user, go to LoginView
                LoginView()
                    .environment(authManager)
            }
        }
    }
}

