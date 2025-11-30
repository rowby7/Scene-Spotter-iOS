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

class FirebaseManager {
    static let shared = FirebaseManager()
    
    private let storage = Storage.storage()
    private let db = Firestore.firestore()
    
    private init() {}
    
    // Upload image to Firebase Storage
    func uploadImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not convert image to data"])))
            return
        }
        
        let imageName = UUID().uuidString
        let storageRef = storage.reference().child("scene-images/\(imageName).jpg")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        storageRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let downloadURL = url?.absoluteString {
                    completion(.success(downloadURL))
                }
            }
        }
    }
    
    // Upload scene data to Firestore
    func uploadScene(_ scene: KScene, completion: @escaping (Result<String, Error>) -> Void) {
        do {
            let docRef = try db.collection("scenes").addDocument(from: scene)
            completion(.success(docRef.documentID))
        } catch {
            completion(.failure(error))
        }
    }
    
    // Complete upload process: image + data
    func uploadSceneWithImage(image: UIImage, showName: String, sceneDescription: String, locationAddress: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user logged in"])))
            return
        }
        
        // First upload the image
        uploadImage(image) { [weak self] result in
            switch result {
            case .success(let imageURL):
                // Then create and upload the scene data
                let scene = KScene(
                    showName: showName,
                    sceneDescription: sceneDescription,
                    locationAddress: locationAddress,
                    imageURL: imageURL,
                    uploadedBy: userId
                )
                
                self?.uploadScene(scene) { result in
                    completion(result)
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
