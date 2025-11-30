//
//  ContentView.swift
//  SceneSpotter
//
//  Created by Rowby Villanueva on 11/24/25.
//

import SwiftUI

struct LoginView: View {
    
    @Environment(AuthManager.self) var authManager
    
    @State private var username: String = ""
    @State private var password: String = ""
    var body: some View {
        NavigationStack{
            VStack {
                Text("Scene Spotter")
                    .font(.largeTitle)
                    .bold()
            }
            VStack (spacing: 20){
                TextField("username", text: $username)
                    .textFieldStyle(.roundedBorder)
                
                SecureField("password", text: $password)
                    .textFieldStyle(.roundedBorder)
                
                HStack (spacing: 20){
                    Button("Login"){
                        authManager.signIn(email: username, password: password)
                    }
                    .buttonStyle(.bordered)
                    
                    NavigationLink("Sign Up", destination: SignUpView())
                        .buttonStyle(.bordered)
                }
            }
            .padding()
        }
    }
}

#Preview {
    LoginView()
}
