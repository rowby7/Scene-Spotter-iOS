import Foundation
import FirebaseFirestore

struct KScene: Identifiable, Codable {
    @DocumentID var id: String?
    let showName: String
    let sceneDescription: String
    let locationAddress: String
    let imageURL: String
    let latitude: Double?
    let longitude: Double?
    let uploadedBy: String // user ID
    let uploadedAt: Date
    
    init(showName: String, sceneDescription: String, locationAddress: String, imageURL: String, latitude: Double? = nil, longitude: Double? = nil, uploadedBy: String) {
        self.showName = showName
        self.sceneDescription = sceneDescription
        self.locationAddress = locationAddress
        self.imageURL = imageURL
        self.latitude = latitude
        self.longitude = longitude
        self.uploadedBy = uploadedBy
        self.uploadedAt = Date()
    }
}
