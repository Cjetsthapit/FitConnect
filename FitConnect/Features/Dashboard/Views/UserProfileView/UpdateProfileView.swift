//
//  UpdateProfileView.swift
//  FitConnect
//
//  Created by Nibha Maharjan on 2024-03-13.
//
import SwiftUI
import FirebaseFirestore

struct UpdateProfileView: View {
    @EnvironmentObject var fitConnect: FitConnectData
    @State private var newName = ""
    @State private var newContactNumber = ""
    @State private var newHeightString = ""
    @State private var newWeightString = ""
    @Binding var isShowingUpdateProfile: Bool
    
    @State private var validationMessage = ""

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Personal Information")) {
                        VStack(alignment: .leading) {
                            Text("Name")
                                .font(.headline)
                                .padding(.bottom, 5)
                            TextField("Name", text: $newName)
                                .textContentType(.name)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Contact Number")
                                .font(.headline)
                                .padding(.bottom, 5)
                            TextField("Contact Number", text: $newContactNumber)
                                .keyboardType(.phonePad)
                        }
                    }
                    
                    Section(header: Text("Physical Information")) {
                        VStack(alignment: .leading) {
                            Text("Height (cm)")
                                .font(.headline)
                                .padding(.bottom, 5)
                            TextField("Height (cm)", text: $newHeightString)
                                .keyboardType(.decimalPad)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Weight (kg)")
                                .font(.headline)
                                .padding(.bottom, 5)
                            TextField("Weight (kg)", text: $newWeightString)
                                .keyboardType(.decimalPad)
                        }
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
        newContactNumber = fitConnect.fitConnectData?.contactNumber ?? ""
        newHeightString = fitConnect.fitConnectData?.height.formattedString() ?? ""
        newWeightString = fitConnect.fitConnectData?.weight.formattedString() ?? ""
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
        if !newContactNumber.isEmpty {
            updatedData["contactNumber"] = newContactNumber
        }
        if let newHeight = Double(newHeightString) {
            updatedData["height"] = newHeight
        }
        if let newWeight = Double(newWeightString) {
            updatedData["weight"] = newWeight
        }

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
        
        if newName.isEmpty || newContactNumber.isEmpty || newHeightString.isEmpty || newWeightString.isEmpty {
            validationMessage = "Please fill in all fields."
            isValid = false
        }
        else {
            validationMessage = ""
        }
        
        return isValid
    }
}

struct UpdateProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateProfileView(isShowingUpdateProfile: .constant(true))
    }
}
