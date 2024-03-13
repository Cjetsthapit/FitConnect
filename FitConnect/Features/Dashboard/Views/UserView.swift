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
            
                Text("User Information")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom)
            

            // Update Weight Section
            Form {
                Section(header: Text("User Profile")) {
                    Button(action: {
                        isShowingProfile.toggle()
                    }) {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.blue)
                            Text("View Profile")
                        }
                    }
                }

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
                UserProfileView()
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
        VStack {
            Text("User Profile")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 20)
            
            // Display user information
            VStack(alignment: .leading, spacing: 10) {
                            Text("Name: \(fitConnect.fitConnectData?.fullName ?? "Unknown")")
                            Text("Email: \(fitConnect.fitConnectData?.email ?? "Unknown")")
                            Text("Contact Number: \(fitConnect.fitConnectData?.contactNumber ?? "Unknown")")
                            Text("Height: \(fitConnect.fitConnectData?.height ?? 0) inches")
                            Text("Weight: \(fitConnect.fitConnectData?.weight ?? 0) lbs")
                            Text("Gender: \(fitConnect.fitConnectData?.gender ?? "Unknown")")
                            if let dob = fitConnect.fitConnectData?.dob {
                                Text("Date of Birth: \(dob, formatter: dateFormatter)")
                            } else {
                                Text("Date of Birth: Unknown")
                            }
                            // Add more user profile information here as needed
                        }
            .padding()
            .foregroundColor(.black)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            
            Spacer()
        }
        .padding()
        .frame(width: 300, height: 200)
    }
    private let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter
        }()
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
