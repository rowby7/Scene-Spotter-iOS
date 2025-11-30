//
//  SignUpView.swift
//  SceneSpotter
//
//  Created by Rowby Villanueva on 11/24/25.
//

import SwiftUI

struct SignUpView: View {
    @Environment(AuthManager.self) var authManager
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword:String = ""
    @State private var email: String = ""
    @State private var signUpError: String?
    
    var body: some View {
        VStack{
            Text("Scene Spotter")
                .font(.largeTitle)
                .bold()
        }
        VStack(spacing: 20){
            TextField("Username", text: $username)
                .textFieldStyle(
                    .roundedBorder)
            
            SecureField("Password", text: $password)
                .textFieldStyle(
                    .roundedBorder)
            
            SecureField("Confirm Password", text: $confirmPassword)
                .textFieldStyle(
                    .roundedBorder)
            
            TextField("Email", text:$email)
                .textFieldStyle(
                    .roundedBorder)
            
            Button("Sign Up") {
                
                authManager.signUp(email: email, password: password)
                
            }
        }
    }
}

#Preview {
    SignUpView()
}
