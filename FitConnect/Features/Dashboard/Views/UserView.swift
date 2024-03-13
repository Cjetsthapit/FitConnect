import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct UserView: View {
    @EnvironmentObject var fitConnect: FitConnectData
    @State private var newWeightString = ""
    @State private var isShowingSheet = false
    @State private var isShowingProfile = false // New state for showing profile popup

    var body: some View {
        VStack {
            // User Information Section
            Form {
                Section(header: Text("User Information")) {
                    Button(action: {
                        isShowingProfile.toggle() // Toggle profile popup visibility
                    }) {
                        HStack {
                            Text("User Information")
                            Spacer()
                            Image(systemName: "person.fill")
                        }
                    }
                }

                // Update Weight Section
                Section(header: Text("Update Weight")) {
                    Button(action: {
                        isShowingSheet.toggle()
                    }) {
                        HStack {
                            Text("Enter New Weight")
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
            .popover(isPresented: $isShowingProfile) {
                UserProfileView() // Show user profile popup
            }
            Spacer()
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

// User profile popup view
struct UserProfileView: View {
    @EnvironmentObject var fitConnect: FitConnectData

    var body: some View {
        // Customize user profile popup content as needed
        VStack {
            Text("User Profile Information")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            Text("Name: \(fitConnect.fitConnectData?.fullName ?? "Unknown")")
            Text("Email: \(fitConnect.fitConnectData?.email ?? "Unknown")")
            // Add more user profile information here as needed
            Spacer()
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
