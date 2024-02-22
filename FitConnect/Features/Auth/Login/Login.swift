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
    @State private var isEmailValid: Bool = true
    @State private var isPasswordValid: Bool = true
    @State private var isLoginButtonDisabled: Bool = true
    @State var path = NavigationPath()
    @State var message = ""
    @EnvironmentObject var fitConnect:  FitConnectData
    
    let toggleView: () -> Void
    
    var body: some View {

        ZStack {
            Color(hex: 0xF2F2F2)
                .edgesIgnoringSafeArea(.all)
                .ignoresSafeArea()
   
             
            VStack {
                
                Image("Logo")
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
                    .foregroundColor(Color.black)
                    .padding(.top,100)
                    .padding(.bottom,100)
                    .overlay(
                        VStack(spacing: 15) {
                    
                            TextField("Email", text: $email)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                                .padding(.horizontal, 20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke((isEmailValid) ? Color.clear : Color.red, lineWidth: 2)
                                        .padding(.horizontal, 20)
                                )
                                .onChange(of: email,initial:false) { value,newValue in
                                    isEmailValid = isValidEmail(newValue)
                                    updateLoginButtonState()
                                }
                            if !isEmailValid {
                                Text("Invalid email format")
                                    .foregroundColor(.red)
                                    .font(.caption)
                                
                            }
                            
                            SecureField("Password", text: $password)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                                .padding(.horizontal, 20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke((isPasswordValid) ? Color.clear : Color.red, lineWidth: 2)
                                        .padding(.horizontal, 20)
                                )
                                .onChange(of: password, initial:false) {value, newValue in
                                    isPasswordValid = isValidPassword(newValue)
                                    updateLoginButtonState()
                                }
                            
                            if !isPasswordValid {
                                Text("must be greater than 6 characters")
                                    .foregroundColor(.red)
                                    .font(.caption)
                                
                            }
                            if(message.count > 0){
                                Text(message).foregroundColor(.red) .font(.caption)
                            }
                            
                            Button(action: login, label: {
                                Text("Login")
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(isLoginButtonDisabled ? Color.gray.opacity(0.5) : Color("Primary"))
                                    .cornerRadius(8)
                                    .padding(.horizontal, 20)
                            })
                            .disabled(isLoginButtonDisabled)
                            .padding(.top, 20)
                            
                            HStack {
                                Text("Not a member yet?")
                                Button("Register"){
                                    toggleView()
                                }
                            }
                        }
                    )
            }
            .padding()
             
                
            
        }
    }
    private func login() {
        loginWithEmailPassword(email: email, password: password)
        print("Login with email: \(email) and password: \(password)")
    }
    
    private func updateLoginButtonState() {
        isLoginButtonDisabled = !isEmailValid || !isPasswordValid
    }
    
    func loginWithEmailPassword(email: String, password: String) {
            // Validate email format
        guard isValidEmail(email) else {
            print("Invalid email format")
            return
        }
        
            // Validate password
        guard isValidPassword(password) else {
            print("Invalid password")
            return
        }
        
            // Proceed with authentication
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                message = error.localizedDescription
                print("Login error:", error.localizedDescription)
                return
            }
                // User successfully logged in
            if let authUser = authResult?.user {
                message = "Successfully Logged in"
                fitConnect.userId = authUser.uid
   
                    
            }
        }
    }
    
        // Function to validate email format
    func isValidEmail(_ email: String) -> Bool {
            // Basic email format validation
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
        // Function to validate password strength
    func isValidPassword(_ password: String) -> Bool {
            // Basic password length validation
        return password.count >= 6
    }
}
