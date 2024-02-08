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
    @State private var isEmailValid: Bool = false
    @State private var isPasswordValid: Bool = false
    @State private var isLoginButtonDisabled: Bool = true
    @State var path = NavigationPath()
    
    var body: some View {
        ZStack {
            Color(hex: 0xF2F2F2) // Background color
                .edgesIgnoringSafeArea(.all)
                .ignoresSafeArea()
            
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
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                                .padding(.horizontal, 20)
                                .onChange(of: email,initial:true) { value,newValue in
                                    isEmailValid = isValidEmail(newValue)
                                    updateLoginButtonState()
                                }
                            
                            SecureField("Password", text: $password)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                                .padding(.horizontal, 20)
                                .onChange(of: password, initial:true) {value, newValue in
                                    isPasswordValid = isValidPassword(newValue)
                                    updateLoginButtonState()
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
                                Button("Register") {
                                    print("Here")
                                    
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
        return password.count >= 6 // You can add more complex validation rules as needed
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
