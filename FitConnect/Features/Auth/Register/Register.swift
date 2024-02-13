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
    @State var contactNumber: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State private var isFullNameValid: Bool = true
    @State private var isEmailValid: Bool = true
    @State private var isContactValid: Bool = true
    @State private var isPasswordValid: Bool = true
    @State private var isConfirmPasswordValid: Bool = true
    @State private var isRegisterButtonDisabled: Bool = true
    @State private var backendError: String = ""
    let toggleView: () -> Void
    
    let db = Firestore.firestore()
    private func isValidFullName(_ fullName: String) -> Bool {
        return fullName.count >= 3
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    private func isValidContact(_ contact: String) -> Bool {
        return contact.count >= 10
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
    
    private func isValidConfirmPassword(_ confirmPassword: String) -> Bool {
        return confirmPassword == password
    }
    
    private func updateRegisterButtonState() {
        isRegisterButtonDisabled = !isFullNameValid || !isEmailValid || !isContactValid || !isPasswordValid || !isConfirmPasswordValid
    }
    private func register() async {
        await signUpAndAddUserData(email: email,
                                   password: password,
                                   fullname: fullname,
                                   contactNumber: contactNumber
        )
        
        
    }
    var body: some View {
        ZStack {
            Color(hex: 0xF2F2F2)
                .edgesIgnoringSafeArea(.all)
                .ignoresSafeArea()
         
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
                        .foregroundColor(Color.black)
                        .padding()
                        .overlay(
                            VStack(spacing: 22) {
                                TextField("Full Name", text: $fullname)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                                    .padding(.horizontal, 20)
                                    .foregroundColor(.black)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(isFullNameValid ? Color.clear : Color.red, lineWidth: 2)
                                            .padding(.horizontal, 20)// Border color changes based on the error state
                                    )
                                    .onChange(of: fullname, perform: { newValue in
                                        isFullNameValid = isValidFullName(newValue)
                                        updateRegisterButtonState()
                                    })
                                
                                if !isFullNameValid {
                                    Text("Must be greater than 3 characters")
                                        .foregroundColor(.red)
                                        .font(.caption) // Smaller font size
                                    
                                }
                                
                                TextField("Email", text: $email)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                                    .padding(.horizontal, 20)
                                    .foregroundColor(.black)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(isEmailValid ? Color.clear : Color.red, lineWidth: 2)
                                            .padding(.horizontal, 20)// Border color changes based on the error state
                                    )
                                    .onChange(of: email, perform: { newValue in
                                        isEmailValid = isValidEmail(newValue)
                                        updateRegisterButtonState()
                                    })
                                if !isEmailValid {
                                    Text("Invalid email format")
                                        .foregroundColor(.red)
                                        .font(.caption) // Smaller font size
                                    
                                }
                                
                                
                                TextField("Contact", text: $contactNumber)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                                    .padding(.horizontal, 20)
                                    .foregroundColor(.black)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(isContactValid ? Color.clear : Color.red, lineWidth: 2)
                                            .padding(.horizontal, 20)// Border color changes based on the error state
                                    )
                                    .onChange(of: contactNumber, perform:{ newValue in
                                        isContactValid = isValidContact(newValue)
                                        updateRegisterButtonState()
                                    })
                                if !isContactValid {
                                    Text("Invalid phone number")
                                        .foregroundColor(.red)
                                        .font(.caption) // Smaller font size
                                    
                                }
                                
                                SecureField("Password", text: $password)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                                    .padding(.horizontal, 20)
                                    .foregroundColor(.black)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke((isPasswordValid) ? Color.clear : Color.red, lineWidth: 2)
                                            .padding(.horizontal, 20)// Border color changes based on the error state
                                    )
                                    .onChange(of: password, perform: { newValue in
                                        isPasswordValid = isValidPassword(newValue)
                                        updateRegisterButtonState()
                                    })
                                if !isPasswordValid {
                                    Text("must be greater than 6 characters")
                                        .foregroundColor(.red)
                                        .font(.caption) // Smaller font size
                                    
                                }
                                
                                SecureField("Confirm Password", text: $confirmPassword)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                                    .padding(.horizontal, 20)
                                    .foregroundColor(.black)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(( isConfirmPasswordValid) ? Color.clear : Color.red, lineWidth: 2)
                                            .padding(.horizontal, 20)// Border color changes based on the error state
                                    )
                                    .onChange(of: confirmPassword, perform: { newValue in
                                        isConfirmPasswordValid = isValidConfirmPassword(newValue)
                                        updateRegisterButtonState()
                                    })
                                if !isConfirmPasswordValid {
                                    Text("Does not match with password")
                                        .foregroundColor(.red)
                                        .font(.caption) // Smaller font size
                                    
                                }
                                if(backendError.count > 0){
                                    Text(backendError).foregroundColor(.red) .font(.caption)
                                }
                                
                                
                                Button(action: {Task{await register()}}, label: {
                                    Text("Register")
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(isRegisterButtonDisabled ? Color.gray.opacity(0.5) : Color("Primary"))
                                        .cornerRadius(8)
                                        .padding(.horizontal, 20)
                                })
                                .disabled(isRegisterButtonDisabled)
                                .padding(.top, 20)
                                HStack {
                                    Text("Not a member yet?")
                                    Button("Register"){
                                        toggleView()
                                    }
                                }
                            }
                                .padding()
                                .cornerRadius(10)
                            
                        )
                }
            }
        
        
        
    }
    func signUpAndAddUserData(email: String, password: String, fullname: String, contactNumber: String ) async {
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            
            if let user = Auth.auth().currentUser {
                let uid = user.uid
                
                    // Perform Firestore data addition concurrently with authentication
                async let firestoreTask: () = addUserDataToFirestore(uid: uid, email: email, fullname: fullname, contactNumber: contactNumber)
                
                    // Wait for both tasks to complete
                _ = try await (authResult, firestoreTask)
                backendError = "Sign-up and Firestore data addition successful"
                print("Sign-up and Firestore data addition successful")
                toggleView()
            }
        } catch {
            backendError = error.localizedDescription
            print("Sign-up error: \(error.localizedDescription)")
        }
        
    }
    
    func addUserDataToFirestore(uid: String, email: String, fullname: String, contactNumber: String) async throws {
        do {
            try await Firestore.firestore().collection("users").document(uid).setData([
                "email": email,
                "fullName": fullname,
                "contactNumber": contactNumber,
                
            ])
            
            print("Firestore data addition successful")
        } catch {
            throw error
        }
        
    }
}






//struct Register_Previews: PreviewProvider {
//    static var previews: some View {
//        Register()
//    }
//}
