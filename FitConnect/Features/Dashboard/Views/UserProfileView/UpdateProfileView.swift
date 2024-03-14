//
//  UserProfileView.swift
//  FitConnect
//
//  Created by Nibha Maharjan on 2024-03-13.
//
import SwiftUI
import FirebaseFirestore

struct UpdateProfileView: View {
    @EnvironmentObject var fitConnect: FitConnectData
    @State private var newName = ""
    @State private var newEmail = ""
    @State private var newContactNumber = ""
    @State private var newHeightString = ""
    @State private var newWeightString = ""
    @State private var selectedGenderIndex = 0
    @Binding var isShowingUpdateProfile: Bool
    
    @State private var validationMessage = ""

    var genders = ["Male", "Female", "Other"]

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Personal Information")) {
                        TextField("Name", text: $newName)
                            .textContentType(.name)
                        TextField("Email", text: $newEmail)
                            .textContentType(.emailAddress)
                        TextField("Contact Number", text: $newContactNumber)
                            .keyboardType(.phonePad)
                    }
                    
                    Section(header: Text("Physical Information")) {
                        TextField("Height (cm)", text: $newHeightString)
                            .keyboardType(.decimalPad)
                        TextField("Weight (kg)", text: $newWeightString)
                            .keyboardType(.decimalPad)
                        
                        Picker(selection: $selectedGenderIndex, label: Text("Gender")) {
                            ForEach(0..<genders.count) {
                                Text(self.genders[$0])
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                }
                
                Button("Update Profile") {
                    updateProfile()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
                
                Text(validationMessage)
                    .foregroundColor(.red)
                    .padding(.bottom)
            }
            .navigationBarTitle("Update Profile", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                isShowingUpdateProfile.toggle()
            })
        }
        .onAppear {
            initializeData()
        }
    }

    private func initializeData() {
        // Initialize the form fields with existing user data
        newName = fitConnect.fitConnectData?.fullName ?? ""
        newEmail = fitConnect.fitConnectData?.email ?? ""
        newContactNumber = fitConnect.fitConnectData?.contactNumber ?? ""
        newHeightString = fitConnect.fitConnectData?.height.formattedString() ?? ""
        newWeightString = fitConnect.fitConnectData?.weight.formattedString() ?? ""
        if let gender = fitConnect.fitConnectData?.gender,
           let index = genders.firstIndex(of: gender) {
            selectedGenderIndex = index
        }
    }

    private func updateProfile() {
        // Validate input fields
        guard validateFields() else {
            return
        }
        
        guard let userId = fitConnect.userId else {
            return
        }

        var updatedData: [String: Any] = [:]

        if !newName.isEmpty {
            updatedData["fullName"] = newName
        }
        if !newEmail.isEmpty {
            updatedData["email"] = newEmail
        }
        if !newContactNumber.isEmpty {
            updatedData["contactNumber"] = newContactNumber
        }
        if let newHeight = Double(newHeightString) {
            updatedData["height"] = newHeight
        }
        if let newWeight = Double(newWeightString) {
            updatedData["weight"] = newWeight
        }
        updatedData["gender"] = genders[selectedGenderIndex]

        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)

        userRef.updateData(updatedData) { error in
            if let error = error {
                print("Error updating profile: \(error.localizedDescription)")
            } else {
                print("Profile updated successfully.")
                fitConnect.fetchFitConnectData()
                isShowingUpdateProfile.toggle()
            }
        }
    }

    private func validateFields() -> Bool {
        // Perform validation on input fields
        var isValid = true
        
        if newName.isEmpty || newEmail.isEmpty || newContactNumber.isEmpty || newHeightString.isEmpty || newWeightString.isEmpty {
            validationMessage = "Please fill in all fields."
            isValid = false
        }
        // Validate email format
        else if !isValidEmail(email: newEmail) {
            validationMessage = "Please enter a valid email address."
            isValid = false
        }
        else {
            validationMessage = ""
        }
        
        return isValid
    }
    
    private func isValidEmail(email: String) -> Bool {
        // Simple email validation regex
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
}

struct UpdateProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateProfileView(isShowingUpdateProfile: .constant(true))
    }
}
