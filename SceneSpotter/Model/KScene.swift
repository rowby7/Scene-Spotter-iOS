import Foundation
import FirebaseFirestore
import Firebase

struct KScene: Identifiable, Codable {
    
    
    @DocumentID var id:     String?
    var showName:           String
    var sceneDescription:   String
    var locationAddress:    String
    var imageURL:           String
    var uploadedBy:         String
    var uploadDate:         Date
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case showName
        case sceneDescription
        case locationAddress
        case imageURL
        case uploadedBy
        case uploadDate
    }
    init(showName: String, sceneDescription: String, locationAddress: String, imageURL: String, uploadedBy: String) {
        self.showName = showName
        self.sceneDescription = sceneDescription
        self.locationAddress = locationAddress
        self.imageURL = imageURL
        self.uploadedBy = uploadedBy
        self.uploadDate = Date()
    }
    
}
