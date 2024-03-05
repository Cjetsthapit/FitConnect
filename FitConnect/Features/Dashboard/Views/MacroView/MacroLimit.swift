import SwiftUI
import Foundation
import Firebase

struct MacroLimit: View {
    @State private var protein: String = ""
    @State private var fat: String = ""
    @State private var carb: String = ""
    @State private var isProteinValid = true
    @State private var isFatValid = true
    @State private var isCarbValid = true
    @EnvironmentObject var fitConnect: FitConnectData
    
    var body: some View {
        VStack{
            Text("Set macro limit")
                .font(.title)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            Text("Let's get started on your fitness journey! Set your limit on the amount of nutrients you want to intake.").padding()
                .padding()
                .foregroundColor(.gray)
                .font(.body)
                .italic()
            Form {
                Section(header: Text("Macronutrients (grams)")) {
                    TextField("Protein (g)", text: $protein)
                        .keyboardType(.numberPad)
                        .onChange(of: protein, perform: { value in
                            isProteinValid = isValidInteger(value)
                        })
                        .foregroundColor(isProteinValid ? .primary : .red)
                        .overlay(
                            Text(isProteinValid ? "" : "Invalid protein amount")
                                .foregroundColor(.red)
                                .opacity(isProteinValid ? 0 : 1)
                                .animation(.easeInOut(duration: 0.2))
                                .padding(.horizontal, 15)
                        )
                    
                    TextField("Fat (g)", text: $fat)
                        .keyboardType(.numberPad)
                        .onChange(of: fat, perform: { value in
                            isFatValid = isValidInteger(value)
                        })
                        .foregroundColor(isFatValid ? .primary : .red)
                        .overlay(
                            Text(isFatValid ? "" : "Invalid fat amount")
                                .foregroundColor(.red)
                                .opacity(isFatValid ? 0 : 1)
                                .animation(.easeInOut(duration: 0.2))
                                .padding(.horizontal, 5)
                        )
                    
                    TextField("Carb (g)", text: $carb)
                        .keyboardType(.numberPad)
                        .onChange(of: carb, perform: { value in
                            isCarbValid = isValidInteger(value)
                        })
                        .foregroundColor(isCarbValid ? .primary : .red)
                        .overlay(
                            Text(isCarbValid ? "" : "Invalid carb amount")
                                .foregroundColor(.red)
                                .opacity(isCarbValid ? 0 : 1)
                                .animation(.easeInOut(duration: 0.2))
                                .padding(.horizontal, 5)
                        )
                }
                
                Button(action: {
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
        }
    }
    
    private func submitForm() {
        if let currentUser = Auth.auth().currentUser {
            let uid = currentUser.uid
            let userData: [String: Any] = [
                "protein": Int(protein) ?? 0,
                "fat": Int(fat) ?? 0,
                "carb": Int(carb) ?? 0
            ]
            Firestore.firestore().collection("users").document(uid).updateData(["macroLimit":userData]) { error in
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
    
    private func isValidInteger(_ value: String) -> Bool {
        guard let number = Int(value), number >= 0 else {
            return false
        }
        return true
    }
    
    private func isFormValid() -> Bool {
        return isValidInteger(protein) && isValidInteger(fat) && isValidInteger(carb)
    }
}

