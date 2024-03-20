//
//  AddWeight.swift
//  FitConnect
//
//  Created by Srijeet Sthapit on 2024-03-19.
//



import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct AddWeight: View {
    @EnvironmentObject var fitConnect: FitConnectData
    @State private var weight: String = ""
    @State private var date: Date = Date()
    @Binding var showingForm: Bool
     var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Weight Details")) {
                    TextField("Weight", text: $weight)
                        .keyboardType(.decimalPad) // Ensure numeric input
                        .padding()
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                        .padding()
                }
                Section {
                    Button("Submit") {
                        submitData()
                    }
                    .padding()
                }
            }
            .navigationBarTitle("Add Weight", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                self.showingForm = false
            })
        }
    }
    func submitData() {
        guard let user = Auth.auth().currentUser else {
            print("No authenticated user found")
            return
        }
        
        guard let weight = Double(weight) else {
            print("Invalid weight input")
            return
        }
        
        let dateString = dateFormatter.string(from: date)
        
            // Now, construct the update data with weight as a Double
        let weightEntry: [String: Any] = [
            "weights.\(dateString)": [
                "date": dateString,
                "weight": weight // Store weight as Double
            ]
        ]
        
        let userDocRef = Firestore.firestore().collection("users").document(user.uid)
        
        userDocRef.updateData(weightEntry) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated with new weight entry")
                DispatchQueue.main.async {
                    fitConnect.fetchFitConnectData()
                    self.showingForm = false // Dismiss form on successful update
                }
            }
        }
    }
}

