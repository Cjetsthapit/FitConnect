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
            VStack {
                TextField("Fullname", text: $fullname) .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Address", text: $address) .textFieldStyle(RoundedBorderTextFieldStyle())
                  
                TextField("Contact number", text: $contactNumber) .textFieldStyle(RoundedBorderTextFieldStyle())
             
                TextField("Email", text: $email) .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                TextField("Username", text: $username) .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Password", text: $password) .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                TextField("Confirm Password", text: $confirmPassword) .textFieldStyle(RoundedBorderTextFieldStyle())
                   
              

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
                     
            }
            .padding()
       
    }
}

#Preview {
    Register()
}
