//
//  AuthManager.swift
//  SceneSpotter
//
//  Created by Rowby Villanueva on 11/30/25.
//

import SwiftUI
import FirebaseAuth

@Observable // <-- Make class observable
class AuthManager {
    // A property to store the logged in user. User is an object provided by FirebaseAuth framework
    var user: User?
    var isSignedIn: Bool = false
    
    var userEmail: String? {
        user?.email
    }
    
    private var handle: AuthStateDidChangeListenerHandle?
    
    init() {
        // Listen for auth state changes
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.user = user
            self?.isSignedIn = user != nil
        }
    }
    
    deinit {
        // Remove listener when AuthManager is deallocated
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    // Sign up new users
    func signUp(email: String, password: String) {
        Task {
            do {
                let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
                self.user = authResult.user
            } catch {
                print("Error signing up: \(error)")
            }
        }
    }
    
    // Sign in existing users
    func signIn(email: String, password: String) {
        Task {
            do {
                let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
                self.user = authResult.user
            } catch {
                print("Error signing in: \(error)")
            }
        }
    }
    
    // Sign out current user
    func signOut() {
        do {
            try Auth.auth().signOut()
            user = nil
        } catch {
            print("Error signing out: \(error)")
        }
    }
}
