    //
    //  Signup.swift
    //  FitConnect
    //
    //  Created by Srijeet Sthapit on 2024-02-02.
    //

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct Register: View {
    @State var fullname: String = ""
    @State var address: String = ""
    @State var contactNumber: String = ""
    @State var username: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    let db = Firestore.firestore()

    var body: some View {
        ZStack {
            Color(hex: 0xF2F2F2) // Background color
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Image("Logo") // Replace "your_logo" with the name of your logo image asset
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                
                Text("Your All-In-One\nFitness Companion")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .padding()
                    .overlay(
                        VStack(spacing: 22) {
                            FCTextField(placeholder: "Fullname", value: $fullname)
                                .frame(height: 30)
                                .frame(width: 280)
                            
                            FCTextField(placeholder: "Address", value: $address)
                                .frame(height: 30)
                                .frame(width: 280)
                            
                            FCTextField(placeholder: "Contact number", value: $contactNumber)
                                .frame(height: 30)
                                .frame(width: 280)
                            
                            FCTextField(placeholder: "Email", value: $email)
                                .frame(height: 30)
                                .frame(width: 280)
                            
                            FCTextField(placeholder: "Username", value: $username)
                                .frame(height: 30)
                                .frame(width: 280)
                            
                            FCTextField(placeholder: "Password", value: $password)
                                .frame(height: 30)
                                .frame(width: 280)
                            
                            FCTextField(placeholder: "Confirm Password", value: $confirmPassword)
                                .frame(height: 30)
                                .frame(width: 280)
                            
                            Button("Register") {
                                Task {
                                    do {
                                        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
                                        if let user = Auth.auth().currentUser {
                                            let uid = user.uid
                                            do {
                                                try await Firestore.firestore().collection("users").document(uid).setData([
                                                    "email": email,
                                                    "fullName": fullname,
                                                    "address": address,
                                                    "contactNumber": contactNumber,
                                                    "userName": username
                                                ])
                                                print("Sign-up and Firestore data addition successful")
                                            } catch {
                                                print("Firestore error: \(error.localizedDescription)")
                                            }
                                        }
                                    } catch {
                                        print("Sign-up error: \(error.localizedDescription)")
                                    }
                                }
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(Color(hex: 0x00AB53))
                            .cornerRadius(10)
                            
                            HStack {
                                Text("Already a member?")
                            }
                        }
                    )
            }
            .padding()
        }
    }
}

struct Register_Previews: PreviewProvider {
    static var previews: some View {
        Register()
    }
}
