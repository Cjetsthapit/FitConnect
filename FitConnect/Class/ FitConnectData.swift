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
    
    init() {
        fetchFitConnectData()
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
                    self.calculateTotalNutrients()
                    print("FitConnect data fetched:", self.fitConnectData ?? "nil")
                    
                } catch {
                    print("Error decoding user data:", error.localizedDescription)
                }
            }
        }
    }
    
    private func calculateTotalNutrients() {
        guard let fitConnect = fitConnectData else { return }
        totalProtein = fitConnect.food.reduce(0) { $0 + $1.protein }
        totalCarb = fitConnect.food.reduce(0) { $0 + $1.carb }
        totalFat = fitConnect.food.reduce(0) { $0 + $1.fat }
    }

}

struct FitConnectResponse: Decodable{
    let fullName: String
    let contactNumber: String
    let email: String
    let food: [Macro]
}

struct Macro: Decodable, Hashable{
    let food: String
    let date: Date
    let protein: Double
    let carb: Double
    let fat: Double
}

