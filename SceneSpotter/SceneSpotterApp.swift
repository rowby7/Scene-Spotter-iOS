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
        FirebaseApp.configure()
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

