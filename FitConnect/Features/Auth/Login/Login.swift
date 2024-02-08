    //
    //  Login.swift
    //  FitConnect
    //
    //  Created by Srijeet Sthapit on 2024-02-01.
    //

import Foundation
import SwiftUI
import FirebaseAuth

struct Login: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var path = NavigationPath()

    var body: some View {
        ZStack {
            Color(hex: 0xF2F2F2) // Background color
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                
                Image("Logo") // Replace "your_logo" with the name of your logo image asset
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(.top, 30)
                
                Text("Your All-In-One\nFitness Companion")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .padding(.top,100)
                    .padding(.bottom,100)
                    .overlay(
                        VStack(spacing: 15) {
                            TextField("Email", text: $email)
                                .textFieldStyle(.roundedBorder)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                                }
                                .padding(.horizontal)
                            
                            SecureField("Password", text: $password)
                                .textFieldStyle(.roundedBorder)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                                }
                                .padding(.horizontal)
                            
                            Button("Login") {
                                loginWithEmailPassword(email: email, password: password)
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(Color(hex: 0x00AB53))
                            .cornerRadius(10)
                            
                            HStack {
                                Text("Not a member yet?")
                                Button("Register") {
                                    print("Here")
                                    path.append("Register")
                                }
                            }
                        }
                    )
            }
            .padding()
        }
    }

    // Function to handle login with email and password
    func loginWithEmailPassword(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("Login error:", error.localizedDescription)
                // Handle login errors here
                return
            }
            // User successfully logged in
            if let user = authResult?.user {
                print("User logged in:", user)
                // You can redirect or perform any other actions here after successful login
            }
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
