import Foundation
import FirebaseFirestore
import Firebase

struct KScene: Identifiable, Codable {
    
    
    @DocumentID var id:     String? = ""
    var showName:           String  = ""
    var sceneDescription:   String  = ""
    var locationAddress:    String  = ""
    var imageURL:           String  = ""
    var uploadedBy:         String  = ""
    var uploadDate:         Date    = Date()
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case showName
        case sceneDescription
        case locationAddress
        case imageURL
        case uploadedBy
        case uploadDate
    }
    
    func withImage(_ url: String) -> KScene {
        var copy = self
        copy.imageURL = url
        return copy
    }
    
}
