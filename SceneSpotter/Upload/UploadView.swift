//
//  UploadView.swift
//  SceneSpotter
//
//  Created by Rowby Villanueva on 11/26/25.
//

import SwiftUI
import PhotosUI
import CoreLocation
import MapKit

struct UploadView: View {
    @State private var selectedImage: Image? = Image(systemName: "photo.artframe")
    @State private var selectedUIImage: UIImage?
    @State private var isPresentingImagePicker: Bool = false
    @State private var selectedPhoto: PhotosPickerItem?
    
    @State private var showName: String = ""
    @State private var showDescription: String = ""
    @State private var location: String = ""
    @State private var coordinates: CLLocationCoordinate2D?
    @State private var coordinateInText: String = ""
    
    @State private var isUploading: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom){
                ScrollView{
                    VStack(){
                        
                        selectedImage?
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(12)
                            .padding(.bottom, 50)
                        
                        
                        VStack(alignment: .leading){
                            Text("Name of show")
                            
                            TextField("Name of Show", text: $showName)
                                .textFieldStyle(.roundedBorder)
                        }
                        .padding(.bottom, 16)
                        
                        
                        VStack(alignment: .leading){
                            Text("Scene Description")
                            TextEditor(text: $showDescription)
                                .frame(height: 100)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                )
                        }
                        .padding(.bottom, 16)
                        
                        
                        
                        VStack(alignment: .leading){
                            
                            Text("Location address")
                            TextField("Location Address", text: $location)
                                .textFieldStyle(.roundedBorder)
                            Button(action:{
                                Task{
                                    await geoAddress(location)
                                }}, label: {
                                Text("Find on map")
                            })
                            
                            TextField ("Coordinates", text: $coordinates)
                        }
                    }
                }
                
                Button(action: uploadScene) {
                    if isUploading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Upload Scene")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(isUploading ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                
            }
            .padding(.horizontal, 20)
            .onChange(of: selectedPhoto) { _, newItem in
                guard let newItem else { return }
                Task {
                    do {
                        if let data = try await newItem.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            // Update your state
                            selectedUIImage = uiImage
                            selectedImage = Image(uiImage: uiImage)
                        }
                    } catch {
                        // Optionally present your alert
                        print("Failed to load UIImage: \(error)")
                        alertMessage = "Couldn't load the selected photo."
                        showAlert = true
                    }
                }
            }
            .navigationTitle("Upload Scene")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack{
                        PhotosPicker(selection: $selectedPhoto, matching: .images) {
                            Image(systemName: "photo")
                                .imageScale(.large)
                        }
                        
                        Button(action: {
                            // Camera functionality - you can add this later
                        }) {
                            Image(systemName: "camera")
                                .imageScale(.large)
                        }
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Notice"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    
    func geoAddress(_ address: String) async -> CLLocationCoordinate2D? {
        
        guard let request = MKGeocodingRequest(addressString : address) else {
            return nil
        }
        
        do {
            let items = try await request.mapItems
            return items.first?.location.coordinate
        } catch {
            print("Geocoding error: \(error)")
            return nil
        }
    }
    func uploadScene() {
        guard let item = selectedPhoto else {
            alertMessage = "Please select a photo first."
            showAlert = true
            return
        }
        isUploading = true
        Task {
            do {
                guard let data = try await item.loadTransferable(type: Data.self) else {
                    await MainActor.run {
                        isUploading = false
                        alertMessage = "Couldn't load the selected photo."
                        showAlert = true
                    }
                    return
                }
                _ = try await StorageManager.shared.saveImage(data: data)
                await MainActor.run {
                    isUploading = false
                    alertMessage = "Upload complete!"
                    showAlert = true
                }
            } catch {
                await MainActor.run {
                    isUploading = false
                    alertMessage = "Upload failed: \(error.localizedDescription)"
                    print("Upload failed: \(error.localizedDescription)")
                    showAlert = true
                }
            }
        }
    }
}
#Preview {
    UploadView()
}

