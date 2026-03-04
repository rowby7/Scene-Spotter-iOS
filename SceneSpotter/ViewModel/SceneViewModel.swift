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
    
    @Published var scene: KScene = KScene(showName: "", sceneDescription: "", locationAddress: "", imageURL: "", uploadedBy: "")
    
   private var db = Firestore.firestore()

    
    //create upload image function
    
    func addScene(scene: KScene) {
        do {
            let _ = try db.collection("scenes").addDocument(from: scene)
        }
        catch {
            print(error)
        }
    }
    
    //call the upload image function here
    //then connect the url recieved into the kscene
    //by doing let scene Kscene then fill that out
    //after connecting the url to KScene call the addscene function
    func save() {
        addScene(scene: scene)
    }
 
}
