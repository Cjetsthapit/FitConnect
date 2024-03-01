import SwiftUI
import FirebaseAuth
import Firebase

struct UserValues: View {
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var selectedSexIndex = 0
    @State private var dob: Date = Date()
    let sexes = ["Male", "Female", "Other"]
    @State private var isHeightValid = true
    @State private var isWeightValid = true
    @State private var isDobValid = true // Corrected name to match function
    @EnvironmentObject var fitConnect: FitConnectData
    
    var body: some View {

            VStack(alignment: .leading, spacing: 0){
                Text("User Information")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)
 
                Text("Let's get started on your fitness journey! We'll need some key details to tailor your experience just for you. Share your date of birth, height, weight, and gender to kickstart your personalized fitness adventure!").padding()
                    .padding()
                    .foregroundColor(.gray)
                    .font(.body)
                    .italic()
                Form {
                    
                    Section(header: Text("Personal Information")) {
                        TextField("Height (cm)", text: $height)
                            .keyboardType(.numberPad)
                            .onChange(of: height, perform: { value in
                                isHeightValid = isValidNumber(value)
                            })
                            .foregroundColor(isHeightValid ? .primary : .red)
                            .overlay(
                                Text(isHeightValid ? "" : "Invalid height")
                                    .foregroundColor(.red)
                                    .opacity(isHeightValid ? 0 : 1)
                                    .animation(.easeInOut(duration: 0.2))
                                    .padding(.horizontal, 5)
                            )
                        
                        TextField("Weight (kg)", text: $weight)
                            .keyboardType(.numberPad)
                            .onChange(of: weight, perform: { value in
                                isWeightValid = isValidNumber(value)
                            })
                            .foregroundColor(isWeightValid ? .primary : .red)
                            .overlay(
                                Text(isWeightValid ? "" : "Invalid weight")
                                    .foregroundColor(.red)
                                    .opacity(isWeightValid ? 0 : 1)
                                    .animation(Animation.easeInOut(duration: 0.2))
                                    .padding(.horizontal, 5)
                            )
                        
                        Picker("Sex", selection: $selectedSexIndex) {
                            ForEach(0 ..< sexes.count) {
                                Text(self.sexes[$0])
                            }
                        }
                    }
                    
                    Section(header: Text("Date of Birth")) {
                        DatePicker("Date of Birth", selection: $dob, displayedComponents: .date)
                            .onChange(of: dob, perform: { _ in
                                isDobValid = isDobLessThanCurrentDate(dob)
                            })
                        if !isDobValid {
                            Text("Invalid date")
                                .foregroundColor(.red)
                                .animation(.easeInOut(duration: 0.2))
                                .padding(.horizontal, 5)
                        }
                    }
                    
                    Button(action: {
                            // Add action for submit button
                        if isFormValid() {
                            submitForm()
                        }
                    }) {
                        Text("Submit")
                            .padding()
                            .foregroundColor(.white)
                            .background(isFormValid() ? Color.blue : Color.gray)
                            .cornerRadius(8)
                    }
                    .disabled(!isFormValid())

            
                }

//            }
          
//            .navigationBarTitle("User Information")
        }
    }
    
    private func submitForm() {
        if let currentUser = Auth.auth().currentUser {
            let uid = currentUser.uid
            let userData: [String: Any] = [
                "height": Double(height) ?? 0,
                "weight": Double(weight) ?? 0,
                "gender": sexes[selectedSexIndex],
                "dob": dob
            ]
            Firestore.firestore().collection("users").document(uid).updateData(userData) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    fitConnect.fetchFitConnectData()
                    print("Document successfully updated")
                }
            }
        } else {
                // User not logged in
        }
    }
    
    private func isValidNumber(_ value: String) -> Bool {
        guard let number = Double(value), number > 0 else {
            return false
        }
        return true
    }
    
    private func isDobLessThanCurrentDate(_ dob: Date) -> Bool {
        let currentDate = Date()
        return dob < currentDate
    }
    
    private func isFormValid() -> Bool {
        return !height.isEmpty && !weight.isEmpty && isDobLessThanCurrentDate(dob)
    }
}

struct UserValues_Previews: PreviewProvider {
    static var previews: some View {
        UserValues()
    }
}

