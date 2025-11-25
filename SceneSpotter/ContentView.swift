//
//  ContentView.swift
//  SceneSpotter
//
//  Created by Rowby Villanueva on 11/24/25.
//

import SwiftUI

struct ContentView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    var body: some View {
        VStack {
            Text("Scene Spotter")
                .font(.largeTitle)
                .bold()
        }
        VStack (spacing: 20){
            TextField("username", text: $username)
                .textFieldStyle(.roundedBorder)
                
            TextField("password", text: $password)
                .textFieldStyle(.roundedBorder)
            
            HStack (spacing: 20){
                Button("Login" ){
                    
                }
                .buttonStyle(.bordered)
                
                Button("Sign Up" ){
                    
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
