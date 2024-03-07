//
//  TabView.swift
//  FitConnect
//
//  Created by Nibha Maharjan on 2024-02-14.
//message: Text("Enter your new weight: \(String(format: "%.2f", newWeight))")

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct UserView: View {
    @EnvironmentObject var fitConnect: FitConnectData
    @State private var newWeightString = ""
    @State private var isShowingSheet = false

    var body: some View {
        VStack {
            Button("Update Weight") {
                isShowingSheet.toggle()
            }
            .padding()
            .sheet(isPresented: $isShowingSheet) {
                UpdateWeightSheet(newWeightString: $newWeightString, updateWeight: updateWeight, isShowingSheet: $isShowingSheet)
            }

            Button("Logout") {
                signOut()
            }
            .padding()
        }
        .padding()
    }

    private func updateWeight() {
        guard let userId = fitConnect.userId,
              let newWeight = Double(newWeightString) else {
            return
        }

        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)

        userRef.updateData(["weight": newWeight]) { error in
            if let error = error {
                print("Error updating weight: \(error.localizedDescription)")
            } else {
                print("Weight updated successfully.")
                fitConnect.fetchFitConnectData()
                // Add a delay before dismissing the sheet
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    isShowingSheet = false
                }
            }
        }
    }

    private func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            fitConnect.userId = nil
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }
}

struct UpdateWeightSheet: View {
    @Binding var newWeightString: String
    var updateWeight: () -> Void
    @Binding var isShowingSheet: Bool

    var body: some View {
        VStack {
            Text("Enter your new weight:")
            TextField("", text: $newWeightString)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Update") {
                updateWeight()
            }
            .padding()
        }
        .padding()
        .frame(width: 300, height: 150) // Adjust the size of the sheet
        .onAppear {
            // Add validation to not allow 0 or negative values
            let validWeight = Double(newWeightString) ?? 0
            if validWeight <= 0 {
                newWeightString = ""
            }
        }
        .onChange(of: newWeightString) { newValue in
            // Ensure that entered value during editing is not 0 or negative
            let validWeight = Double(newValue) ?? 0
            if validWeight <= 0 {
                newWeightString = ""
            }
        }
    }
}



struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
