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
    @State private var isPresentingImagePicker: Bool = false

    @State private var showName: String = ""
    @State private var showDescription: String = ""
    @State private var location: String = ""
    
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
                                .textFieldStyle(
                                    .roundedBorder)
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
                                .textFieldStyle(
                                    .roundedBorder)
                        }
                    }
                }
                Button("Upload Scene") {
                           // action
                       }
                       .frame(maxWidth: .infinity)
                       .padding()
                       .background(Color.blue)
                       .foregroundColor(.white)
                       .cornerRadius(12)
                       .padding(.horizontal, 20)
                       .padding(.bottom, 10) // spacing from bottom edge
                   
            }
            .padding(.horizontal, 20)
                .navigationTitle("Upload Scene")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack{
                            Button(action: {
                                isPresentingImagePicker = true
                            }) {
                                Image(systemName: "photo")
                                    .imageScale(.large)
                            }
                            
                            Button(action: {
                                
                            }) {
                                Image(systemName: "camera")
                                    .imageScale(.large)
                            }
                            
                        }
                        
                        
                    }
                    
                    
                }
                .photosPicker(isPresented: $isPresentingImagePicker, selection: .constant(nil))
        }
    }
}

#Preview {
    UploadView()
}


