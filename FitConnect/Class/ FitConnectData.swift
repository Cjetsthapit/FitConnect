//
//  FitConnect.swift
//   FitConnectData
//
//  Created by Srijeet Sthapit on 2024-02-19.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class  FitConnectData: ObservableObject{
    
    @Published var fitConnectData: FitConnectResponse?
    @Published var userId : String?
    @Published var totalProtein: Double = 0
    @Published var totalCarb: Double = 0
    @Published var totalFat: Double = 0
    @Published var filteredIntakes: [Macro] = []
    @Published var selectedMacroDate = Date(){
        didSet {
            filterMacroIntakes()
        }
    }
    
    init() {
        fetchFitConnectData()
        filterMacroIntakes()
    }
    
    func filterMacroIntakes() {
        print("here")
        guard let fitConnect = fitConnectData else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let food = fitConnect.food {
                // Filter macro intakes based on selectedMacroDate
            let selectedDateString = dateFormatter.string(from: selectedMacroDate)
            
                // Filter macro intakes based on the date strings with only year, month, and day components
            filteredIntakes = food.filter { foodDate in
                let foodDateString = dateFormatter.string(from: foodDate.date)
                print(foodDateString, selectedDateString)
                return foodDateString == selectedDateString
            }
            print(filteredIntakes)
                // Update total nutrients based on filtered intakes
            totalProtein = filteredIntakes.reduce(0) { $0 + $1.protein }
            totalCarb = filteredIntakes.reduce(0) { $0 + $1.carb }
            totalFat = filteredIntakes.reduce(0) { $0 + $1.fat }
        } else {
                // Handle case where food array is nil or empty
            print("Food data is nil or empty")
            totalProtein = 0
            totalCarb = 0
            totalFat = 0
        }
    }
    
    func fetchFitConnectData() {
        if let currentUser = Auth.auth().currentUser {
            self.userId = currentUser.uid
            let db = Firestore.firestore()
            let userRef = db.collection("users").document(currentUser.uid)
            print("userRef", userRef)
            userRef.getDocument { document, error in
                if let error = error {
                    print("Error fetching users data:", error.localizedDescription)
                    return
                }
                
                guard let document = document, document.exists else {
                    print("User document not found")
                    return
                }
                
                do {
                    self.fitConnectData = try document.data(as: FitConnectResponse.self)
                    self.filterMacroIntakes()
//                    self.calculateTotalNutrients()
                    print("FitConnect data fetched:", self.fitConnectData ?? "nil")
                    
                } catch {
                    print("Error decoding user data:", error.localizedDescription)
                }
            }
        }
    }
    
    private func calculateTotalNutrients() {
        guard let fitConnect = fitConnectData else { return }
        
        if let food = fitConnect.food {
            totalProtein = food.reduce(0) { $0 + $1.protein }
            totalCarb = food.reduce(0) { $0 + $1.carb }
            totalFat = food.reduce(0) { $0 + $1.fat }
        } else {
                // Handle case where food array is nil or empty
            print("Food data is nil or empty")
            totalProtein = 0
            totalCarb = 0
            totalFat = 0
        }
    }

}

struct FitConnectResponse: Decodable{
    let fullName: String
    let contactNumber: String
    let email: String
    let height: Double
    let weight: Double
    let gender: String
    let dob: Date?
    let food: [Macro]?
    let macroLimit: MacroLimitSettings
//    let settings: FitConnectSettings
}

struct MacroLimitSettings: Decodable{
    let protein: Int
    let fat: Int
    let carb: Int
}

struct Macro: Decodable, Hashable{
    let food: String
    let date: Date
    let protein: Double
    let carb: Double
    let fat: Double
}



