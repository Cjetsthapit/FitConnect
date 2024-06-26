
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct AddMacro: View {
    @State private var foodName: String = ""
    @State private var date: Date = Date()
    @Binding var showingForm: Bool
    @EnvironmentObject var fitConnect: FitConnectData
    @State private var showingErrorPopover = false
    @State private var errorMessage = ""
    @State private var isSubmitting = false
    
    private var today: Date{
        return Calendar.current.startOfDay(for: Date())
    }
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Food Details")) {
                    TextField("Food Name", text: $foodName)
                        .padding()
                    DatePicker("Date", selection: $date,  in: ...today, displayedComponents: .date)
                        .padding()
                }
                Section {
                    Button("Submit") {
                        submitData()
                    }.disabled(isSubmitting)
                    .padding()
                }
            }
            .navigationBarTitle("Add Food")
            .navigationBarItems(trailing: Button("Cancel") {
                self.showingForm = false
            })
            .alert("Error", isPresented: $showingErrorPopover) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            
        }
    }
    
    func submitData() {
        isSubmitting = true
        Task {
            do {
                print("Food is ", foodName)
                let resp = try await OpenAiService.shared.sendPromptToChatGPT(message: foodName)
                try await addMacro(macro: resp, date: date)
                showingForm = false
            } catch {
                errorMessage = error.localizedDescription
                showingErrorPopover = true
            }
        }
        isSubmitting = false
    }
    
    func addMacro(macro: MacroResponse, date: Date) async throws {
        guard let currentUser = Auth.auth().currentUser else {
            print("User not logged in")
            return // Exit if user is not logged in
        }
        
        let uid = currentUser.uid
        let macroDict: [String: Any] = [
            "food": macro.food,
            "fat": macro.fat,
            "carb": macro.carb,
            "protein": macro.protein,
            "date": Timestamp(date: date) // Use Timestamp for Firestore
        ]
        
        do {
            try await Firestore.firestore().collection("users").document(uid).updateData([
                "food": FieldValue.arrayUnion([macroDict]),
            ])
            fitConnect.fetchFitConnectData()
            fitConnect.filterMacroIntakes()
            fitConnect.selectedMacroYear = String(Calendar.current.component(.year, from: Date()))
            print("Firestore data addition successful")
        } catch {
            throw error
        }
    }
}

