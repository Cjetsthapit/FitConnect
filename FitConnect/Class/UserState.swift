//
//  UserState.swift
//  FitConnect
//
//  Created by Srijeet Sthapit on 2024-02-09.
//

import Foundation
import FirebaseAuth

class UserState: ObservableObject {
    @Published var userId: String?
    init(userId: String? = nil) {
        if let authUser =  Auth.auth().currentUser {
            self.userId = authUser.uid
        }
    }
   
}
