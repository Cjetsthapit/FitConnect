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
    @State var path = NavigationPath()
    var body: some View {

            VStack {
                Group{
                    TextField("Email", text: $email)
                    SecureField("Password", text: $password)
                }
                .textFieldStyle(.roundedBorder)
                .overlay{
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray.opacity(0.5), lineWidth: 2)
                }
                .padding(.horizontal)
                
                Button("Login"){
                    loginWithEmailPassword(email: email, password: password)
                }
                HStack{
                    Text("Not a member yet?")
                    Button("Register"){
                        print("Here")
                        path.append("Register")
                    }
                }
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




#Preview {
    Login(email: "", password: "")
}
