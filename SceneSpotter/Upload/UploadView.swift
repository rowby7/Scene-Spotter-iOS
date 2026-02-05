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
    @StateObject var viewModel: SceneViewModel
    @State private var selectedImage: Image? = Image(systemName: "photo.artframe")
    @State private var selectedUIImage: UIImage?
    @State private var isPresentingImagePicker: Bool = false
    @State private var selectedPhoto: PhotosPickerItem?

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
                            
                            TextField("Name of Show", text: $viewModel.scene.showName)
                                .textFieldStyle(.roundedBorder)
                        }
                        .padding(.bottom, 16)
                        
                        
                        VStack(alignment: .leading){
                            Text("Scene Description")
                            TextEditor(text: $viewModel.scene.sceneDescription)
                                .frame(height: 100)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                )
                        }
                        .padding(.bottom, 16)
                        
                        
                        
                        VStack(alignment: .leading){
                            
                            Text("Location address")
                            TextField("Location Address", text: $viewModel.scene.locationAddress)
                                .textFieldStyle(.roundedBorder)
                           
                        }
                    }
                }
                
                Button(action: handleUploadTapped) {
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
    
    
    func handleUploadTapped() {
        
        }
    
}
#Preview {
    
}

