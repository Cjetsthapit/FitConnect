//
//  Dashboard.swift
//  FitConnect
//
//  Created by Srijeet Sthapit on 2024-02-03.
//

import SwiftUI
import FirebaseAuth
struct Dashboard: View {
    @EnvironmentObject var fitConnect:  FitConnectData

    
    var body: some View {
       
        AppTabView()
        

    }
}

#Preview {
    Dashboard()
}
