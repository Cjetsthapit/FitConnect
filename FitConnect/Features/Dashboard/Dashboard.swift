//
//  Dashboard.swift
//  FitConnect
//
//  Created by Srijeet Sthapit on 2024-02-03.
//

import SwiftUI
import FirebaseAuth
struct Dashboard: View {
    
    @ObservedObject var user: UserState
    
    var body: some View {
        
       
        AppTabView()
               
        Button("Signout"){
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                user.userId = nil
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
        }
        
    }
}

#Preview {
    Dashboard(user:UserState())
}
