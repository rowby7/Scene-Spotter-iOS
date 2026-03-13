//
//  SceneViewModel.swift
//  SceneSpotter
//
//  Created by Rowby Villanueva on 2/5/26.
//

import Foundation
import Firebase
import SwiftUI
import Combine
import FirebaseFirestore

class SceneViewModel: ObservableObject {
    
    @Published var scene = KScene()
    @Published var isUploading = false
    @Published var uploadError: Error?

    private let firebaseManager = FirebaseManager.shared
    
        
    
    func saveScene( with image: UIImage) async throws {
        isUploading = true
        uploadError = nil
        
        do {
            try await firebaseManager.storeScene(scene, image: image)
            isUploading = false
        } catch {
            
            isUploading = false
            uploadError = error
            
        }
        
        
    }
    
    //TODO: Add fetch scenes
 
}
