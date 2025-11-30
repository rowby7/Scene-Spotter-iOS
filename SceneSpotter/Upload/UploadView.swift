//
//  UploadView.swift
//  SceneSpotter
//
//  Created by Rowby Villanueva on 11/26/25.
//

import SwiftUI
import PhotosUI

struct UploadView: View {
    @State private var selectedImage: Image? = Image(systemName: "photo.artframe")
    @State private var selectedUIImage: UIImage?
    @State private var isPresentingImagePicker: Bool = false
    @State private var selectedPhoto: PhotosPickerItem?

    @State private var showName: String = ""
    @State private var showDescription: String = ""
    @State private var location: String = ""
    
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
                .disabled(isUploading || !isFormValid())
                   
            }
            .padding(.horizontal, 20)
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
            .onChange(of: selectedPhoto) { oldValue, newValue in
                guard oldValue != newValue else { return }
                Task {
                    if let data = try? await newValue?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        selectedUIImage = uiImage
                        selectedImage = Image(uiImage: uiImage)
                    }
                }
            }
            .alert("Upload Status", isPresented: $showAlert) {
                Button("OK") {
                    if !alertMessage.contains("Error") {
                        clearForm()
                    }
                }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    func isFormValid() -> Bool {
        !showName.isEmpty && !location.isEmpty && selectedUIImage != nil
    }
    
    func uploadScene() {
        guard let image = selectedUIImage else { return }
        
        isUploading = true
        
        FirebaseManager.shared.uploadSceneWithImage(
            image: image,
            showName: showName,
            sceneDescription: showDescription,
            locationAddress: location
        ) { result in
            isUploading = false
            
            switch result {
            case .success:
                alertMessage = "Scene uploaded successfully!"
                showAlert = true
            case .failure(let error):
                alertMessage = "Error uploading scene: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }
    
    func clearForm() {
        showName = ""
        showDescription = ""
        location = ""
        selectedImage = Image(systemName: "photo.artframe")
        selectedUIImage = nil
        selectedPhoto = nil
    }
}
#Preview {
    UploadView()
}

