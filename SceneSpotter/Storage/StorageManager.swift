//
//  StorageManager.swift
//  SceneSpotter
//
//  Created by Rowby Villanueva on 12/4/25.
//

import Foundation
import FirebaseStorage

class StorageManager {
    static let shared = StorageManager()
    private init() {}
    
    private let storage = Storage.storage().reference()
    
    
    func saveImage(data: Data) async throws -> (path: String, name: String) {
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        let path = "\(UUID().uuidString).jpeg"
        let returnedMetadata = try await storage.child(path).putDataAsync(data, metadata: meta)
        
        
        guard let returnedPath = returnedMetadata.path, let returnedName = returnedMetadata.name else {
            throw URLError(.badServerResponse)
        }
        
        return (returnedPath, returnedName)
    }
    
    
    
}
