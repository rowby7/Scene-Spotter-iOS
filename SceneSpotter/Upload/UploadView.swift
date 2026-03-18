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
import FirebaseStorage

struct UploadView: View {
    @StateObject var sceneViewModel: SceneViewModel
    @StateObject var locationManager: LocationSearchManager
    @State private var selectedImage: Image? = Image(systemName: "photo.artframe")
    @State private var selectedUIImage: UIImage?
    @State private var isPresentingImagePicker: Bool = false
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selection: String = ""

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
                            
                            TextField("Name of Show", text: $sceneViewModel.scene.showName)
                                .textFieldStyle(.roundedBorder)
                        }
                        .padding(.bottom, 16)
                        
                        
                        VStack(alignment: .leading){
                            Text("Scene Description")
                            TextEditor(text: $sceneViewModel.scene.sceneDescription)
                                .frame(height: 100)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                )
                        }
                        .padding(.bottom, 16)
                        
                        
                        
                        VStack(alignment: .leading){

                            Text("Location address")
                            TextField("Location Address", text: $sceneViewModel.scene.locationAddress)
                                .onChange(of: sceneViewModel.scene.locationAddress) {_, newValue in locationManager.updateQuery(newValue)
                                    
                                }
                                        .background(Color.white)
                                        .shadow(radius: 5)
                                        .offset(y: 50)
                            
                            ScrollView{
                                if !locationManager.results.isEmpty {
                                    ForEach(locationManager.results, id: \.self) { result in
                                        Button {
                                            
                                        } label: {
                                            Text(result.title)
                                        }
                                    }
                                }
                            }
                            .padding(.top, 55)
                            .background(Color.white)
                            .shadow(radius: 5)
                            .offset(y: 50)
                                }
                                .textFieldStyle(.roundedBorder)
                           
                        }
                   
                    }
                
                
                Button(action: handleUploadTapped) {
                    if sceneViewModel.isUploading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Upload Scene")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(sceneViewModel.isUploading ? Color.gray : Color.blue)
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
    
    
    func handleUploadTapped() {
        guard let uiImage = selectedUIImage else {
            alertMessage = "Please select an image first"
            showAlert = true
            return
        }
        
        // Validate that we have required data
        guard !sceneViewModel.scene.showName.isEmpty else {
            alertMessage = "Please enter the show name"
            showAlert = true
            return
        }
        
        guard !sceneViewModel.scene.locationAddress.isEmpty else {
            alertMessage = "Please enter the location address"
            showAlert = true
            return
        }
        
       
        
        Task {
            await sceneViewModel.saveScene(with: uiImage)
            
            
            if sceneViewModel.uploadError == nil {
                resetForm()
            } else {alertMessage = "Upload failed: \(sceneViewModel.uploadError?.localizedDescription ?? "Unknown error")"
                showAlert = true
            }
        }
    }
    
    func resetForm() {
        selectedImage = Image(systemName: "photo.artframe")
        selectedUIImage = nil
        selectedPhoto = nil
        
        // Reset the scene data in ViewModel
        sceneViewModel.scene = KScene()
    }
    
    
    
}

#Preview {
    UploadView(sceneViewModel: SceneViewModel(), locationManager: LocationSearchManager())
}

