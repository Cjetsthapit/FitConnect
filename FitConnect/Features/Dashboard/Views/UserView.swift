//
//  UserView.swift
//  FitConnect
//
//  Created by Nibha Maharjan on 2024-02-14.
//
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct UserView: View {
    @EnvironmentObject var fitConnect: FitConnectData
    @State private var newWeightString = ""
    @State private var isShowingSheet = false
    @State private var isShowingMacroUpdate = false
    @State private var isShowingProfile = false // New state for showing profile screen

    var body: some View {
        NavigationView {
            VStack {
                Text("User Information")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom)
                
                Form {
                    Section(header: Text("User Profile")) {
                        NavigationLink(destination: UserProfileView()) {
                            HStack {
                                Text("View Profile")
                            }
                        }
                        NavigationLink(destination: WeightTracker()) {
                            HStack {
                                Text("Weight Tracker")
                            }
                        }
                    }
                    
                    Section(header: Text("Macro Settings")) {
                        Button(action: {
                            isShowingMacroUpdate.toggle()
                        }) {
                            HStack {
                                Text("Enter New Macro Limit")
                                Spacer()
                                Image(systemName: "arrow.right.circle.fill")
                            }
                        }
                    }

                    Section(header: Text("Logout")) {
                        Button(action: {
                            signOut()
                        }) {
                            Text("Logout")
                                .foregroundColor(.red)
                        }
                    }
                }
                .padding()
                .sheet(isPresented: $isShowingSheet) {
                    UpdateWeightSheet(newWeightString: $newWeightString, updateWeight: updateWeight, isShowingSheet: $isShowingSheet)
                        .modifier(CustomSheetModifier(size: CGSize(width: 300, height: 200)))
                }
                .sheet(isPresented: $isShowingMacroUpdate) {
                    MacroLimit(isShowingMacroUpdate: $isShowingMacroUpdate)
                }
                Spacer()
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
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
        .modifier(CustomSheetModifier(size: CGSize(width: 300, height: 200)))
    }
}

struct CustomSheetModifier: ViewModifier {
    let size: CGSize

    func body(content: Content) -> some View {
        content
            .frame(width: size.width, height: size.height)
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
            .environmentObject(FitConnectData()) // Add this line for preview
    }
}
