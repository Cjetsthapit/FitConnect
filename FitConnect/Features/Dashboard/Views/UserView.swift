//
//  TabView.swift
//  FitConnect
//
//  Created by Nibha Maharjan on 2024-02-14.
//

import Foundation
import SwiftUI
import FirebaseAuth
struct UserView: View{
    @EnvironmentObject var fitConnect:  FitConnectData
    var body: some View {
        Button("Logout"){
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                fitConnect.userId = nil
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
        }
    }
}

struct  UserView_Previews: PreviewProvider{
    static var previews: some View{
        UserView()
    }
}
