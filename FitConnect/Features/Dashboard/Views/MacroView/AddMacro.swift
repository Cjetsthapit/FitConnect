//
//  AddMacro.swift
//  FitConnect
//
//  Created by Srijeet Sthapit on 2024-02-19.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct AddMacro: View {
    @Binding var foodName: String
    @Binding var date: Date
    @Binding var showingForm: Bool
    @EnvironmentObject var fitConnect:  FitConnectData
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Food Details")) {
                    TextField("Food Name", text: $foodName)
                        .padding()
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                        .padding()
                }
                Section {
                    Button("Submit") {
                        Task{
                            do{
                                print("FOod is ", foodName)
                                let resp = try await OpenAiService.shared.sendPromptToChatGPT( message: foodName)
                                try await addMacro(macro: resp, date: date)
                                
                                showingForm = false
                            }catch{
                                print(error.localizedDescription)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitle("Add Food")
            .navigationBarItems(trailing: Button("Cancel") {
                self.showingForm = false
            })
        }
    }
    
    func addMacro(macro: MacroResponse, date: Date) async throws {
        if let currentUser = Auth.auth().currentUser {
            let uid = currentUser.uid
            let macroDict: [String: Any] = [
                "food": macro.food,
                "fat": macro.fat,
                "carb": macro.carb,
                "protein": macro.protein,
                "date":date
            ]
            do {
                
                try await Firestore.firestore().collection("users").document(uid).updateData([
                    "food": FieldValue.arrayUnion([macroDict]),
                ])
                fitConnect.fetchFitConnectData()
                fitConnect.filterMacroIntakes()
                print("Firestore data addition successful")
            } catch {
                throw error
            }
        } else {
                // User not logged in
        }
 
        
    }
}


//#Preview {
//    AddMacro()
//}
