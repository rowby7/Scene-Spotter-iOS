//
//  FirebaseManager.swift
//  SceneSpotter
//
//  Created by Rowby Villanueva on 11/30/25.
//

import SwiftUI
import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth
import UIKit
import Combine

class FirebaseManager {
    private var progress: Double?
    static let shared = FirebaseManager()
    
    private let storage = Storage.storage()
    private let dataBase = Firestore.firestore()
    
    
    func storeSceneImage(_ image: UIImage) async throws -> URL{
        
        let imageID = UUID().uuidString
        let imageReference = Storage.storage().reference().child("SceneImage/\(imageID).jpg")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw NSError(domain: "FirebaseManager", code: 100, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to Jpeg data"]
        )}
        let _ = try await imageReference.putDataAsync(imageData, metadata: metadata)

        let imageUrl = try await imageReference.downloadURL()
        
        return imageUrl
    }
    
    func storeScene(_ scene: KScene, image: UIImage) async throws {
        
        let imageUrl = try await storeSceneImage(image)
        
        var updatedScene = scene.withImage(imageUrl.absoluteString)
        
        do{
            try dataBase.collection("Scenes").document().setData(from: updatedScene)
        } catch {
            print("Failed to store scene to Firestore: \(error.localizedDescription)")
            throw error
        }
        
    }
}
