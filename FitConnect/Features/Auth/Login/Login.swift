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
    @State var email : String = ""
    @State var password : String = ""
    var body: some View {
            VStack {
                TextField(/*@START_MENU_TOKEN@*/"Placeholder"/*@END_MENU_TOKEN@*/, text: $email) .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField("Placeholder", text: $password) .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                    Button("Login"){
                    }
                     
            }
            .padding()
       
    }
}

#Preview {
    Login(email: "", password: "")
}
