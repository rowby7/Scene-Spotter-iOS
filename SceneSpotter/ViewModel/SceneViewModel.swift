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
    
    @Published var scene: KScene = KScene(showName: <#T##String#>, sceneDescription: <#T##String#>, locationAddress: <#T##String#>, imageURL: <#T##String#>, uploadedBy: <#T##String#>, uploadDate: <#T##Date#>)
    
   private var db = Firestore.firestore()

    func addScene(scene: KScene) {
        do {
            let _ = try db.collection("scenes").addDocument(from: scene)
        }
        catch {
            print(error)
        }
    }
    
    func save() {
        addScene(scene: scene)
    }
 
}
