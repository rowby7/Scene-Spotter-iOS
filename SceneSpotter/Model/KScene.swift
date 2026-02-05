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
//    let showName: String
//    let sceneDescription: String
//    let locationAddress: String
//    let imageURL: String
//    let latitude: Double?
//    let longitude: Double?
//    let uploadedBy: String // user ID
//    let uploadedAt: Date
//    
//    init(showName: String, sceneDescription: String, locationAddress: String, imageURL: String, latitude: Double? = nil, longitude: Double? = nil, uploadedBy: String) {
//        self.showName = showName
//        self.sceneDescription = sceneDescription
//        self.locationAddress = locationAddress
//        self.imageURL = imageURL
//        self.latitude = latitude
//        self.longitude = longitude
//        self.uploadedBy = uploadedBy
//        self.uploadedAt = Date()
    }

