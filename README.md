# SceneSpotter 🎬📍

SceneSpotter is an iOS app that allows users to discover and share filming locations from their favorite TV shows and movies. Users can upload scene photos, add location details, and explore real-world locations where iconic scenes were filmed.

## Features

### 🔐 Authentication
- User registration and login using Firebase Authentication
- Secure user session management
- Profile management

### 📸 Scene Upload
- Upload photos of filming locations
- Add show/movie name and scene descriptions
- Include location addresses
- Photos stored in Firebase Storage
- Scene data stored in Firebase Firestore

### 🗺️ Interactive Map
- Browse filming locations on an interactive map
- Search for specific places
- View scene details and photos
- Discover nearby filming locations

### 👤 User Profiles
- Personal profile management
- Track uploaded scenes
- Account settings

## Tech Stack

### Frameworks & Technologies
- **SwiftUI** - Modern declarative UI framework
- **Firebase Authentication** - User authentication and management
- **Firebase Firestore** - Cloud-hosted NoSQL database for scene data
- **Firebase Storage** - Cloud storage for scene images
- **MapKit** - Interactive maps and location services
- **PhotosUI** - Native photo picker integration
- **Swift Concurrency** - Async/await for asynchronous operations

### Architecture
- **MVVM (Model-View-ViewModel)** pattern
- Singleton pattern for Firebase management
- Codable models for data persistence
- Observable objects for state management

## Project Structure

```
SceneSpotter/
├── Models/
│   └── KScene.swift              # Scene data model
├── ViewModels/
│   └── SceneViewModel.swift      # Scene state management
├── Views/
│   ├── MapView.swift             # Interactive map interface
│   ├── UploadView.swift          # Scene upload interface
│   ├── LoginView.swift           # User login
│   └── SignUpView.swift          # User registration
├── Managers/
│   ├── FirebaseManager.swift    # Firebase operations (Storage & Firestore)
│   └── AuthManager.swift        # Authentication logic
└── SceneSpotterApp.swift        # App entry point
```

## Data Model

### KScene
```swift
struct KScene: Identifiable, Codable {
    var id: String?
    var showName: String           // Name of the show/movie
    var sceneDescription: String   // Description of the scene
    var locationAddress: String    # Physical location address
    var imageURL: String           // Firebase Storage URL
    var uploadedBy: String         // User who uploaded
    var uploadDate: Date           // Timestamp
}
```

## Firebase Integration

### Storage Structure
```
SceneImage/
└── {UUID}.jpg    # Compressed JPEG images (0.8 quality)
```

### Firestore Structure
```
scenes/
└── {documentID}
    ├── showName
    ├── sceneDescription
    ├── locationAddress
    ├── imageURL
    ├── uploadedBy
    └── uploadDate
```

## Setup Instructions

### Prerequisites
- Xcode 15.0 or later
- iOS 17.0 or later
- Swift 5.9 or later
- Firebase account

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/SceneSpotter.git
   cd SceneSpotter
   ```

2. **Install Firebase**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Add an iOS app to your Firebase project
   - Download `GoogleService-Info.plist`
   - Add the file to your Xcode project

3. **Enable Firebase Services**
   - Enable **Authentication** (Email/Password)
   - Enable **Cloud Firestore**
   - Enable **Storage**
   - Set up Storage security rules (see below)

4. **Open in Xcode**
   ```bash
   open SceneSpotter.xcodeproj
   ```

5. **Add Firebase SDK**
   - File → Add Package Dependencies
   - Add Firebase: `https://github.com/firebase/firebase-ios-sdk`
   - Select packages: FirebaseAuth, FirebaseFirestore, FirebaseStorage

6. **Build and Run**
   - Select your target device or simulator
   - Press `Cmd + R` to build and run

### Firebase Security Rules

**Firestore Rules:**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /scenes/{sceneId} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null 
        && request.auth.uid == resource.data.uploadedBy;
    }
  }
}
```

**Storage Rules:**
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /SceneImage/{imageId} {
      allow read: if true;
      allow write: if request.auth != null 
        && request.resource.size < 5 * 1024 * 1024
        && request.resource.contentType.matches('image/.*');
    }
  }
}
```

## Key Components

### FirebaseManager
Handles all Firebase operations:
- `storeSceneImage(_ image: UIImage) async throws -> URL` - Uploads images to Storage
- `storeScene(_ scene: KScene, image: UIImage) async throws` - Uploads complete scene data

### AuthManager
Manages user authentication:
- User registration
- Login/logout
- Session persistence

### UploadView
User interface for uploading scenes:
- Photo picker integration
- Form validation
- Upload progress tracking
- Error handling

## Usage

### Uploading a Scene

1. Tap the **+** button in the navigation bar
2. Select a photo from your library
3. Enter the show/movie name
4. Add a scene description
5. Provide the location address
6. Tap **Upload Scene**

### Browsing Scenes

1. Navigate the interactive map
2. Use the search bar to find specific locations
3. Tap on map pins to view scene details
4. View photos and information about each filming location

## Error Handling

The app implements comprehensive error handling:
- Image conversion failures
- Network errors
- Firebase upload failures
- Authentication errors
- User-friendly error messages with alerts

## Future Enhancements

- [ ] Camera integration for direct photo capture
- [ ] Scene ratings and reviews
- [ ] Social features (following users, likes)
- [ ] Advanced search and filters
- [ ] Offline support
- [ ] Push notifications


## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

Rowby Villanueva
Project Link: [https://github.com/yourusername/SceneSpotter](https://github.com/yourusername/SceneSpotter)

## Acknowledgments

- Firebase for backend infrastructure
- Apple's SwiftUI framework
- MapKit for location services
- The iOS development community

---

Built with ❤️ using SwiftUI and Firebase
