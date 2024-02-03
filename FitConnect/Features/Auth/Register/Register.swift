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
    @State var fullname : String = ""
    @State var address : String = ""
    @State var contactNumber : String = ""
    @State var username : String = ""
    @State var email : String = ""
    @State var password : String = ""
    @State var confirmPassword : String = ""
    let db = Firestore.firestore()
    var body: some View {
        Color("Background") // Replace with your desired background color
            .edgesIgnoringSafeArea(.all) // This ensures the color fills the entire screen
            .overlay(
                VStack {
                    FCTextField(placeholder: "Fullname", value: $fullname)
                    
                    FCTextField(placeholder:"Address", value: $address)
                    
                    FCTextField(placeholder:"Contact number", value: $contactNumber)
                    
                    FCTextField(placeholder:"Email", value: $email)
                    
                    FCTextField(placeholder:"Username", value: $username)
                    
                    FCTextField(placeholder:"Password", value: $password)
                    
                    FCTextField(placeholder:"Confirm Password", value: $confirmPassword)
                    
                    Button("Register"){
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
                    .background(Color(hex: 0x00AB53)) // Custom RGB values
                    .cornerRadius(10)
                    
                }
                    .padding()
            )
    }
    
}

#Preview {
    Register()
}
