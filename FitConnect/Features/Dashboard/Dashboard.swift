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
        if(fitConnect.fitConnectData?.height == 0 ){
            UserValues()
        }else{
            AppTabView()
        }
          
    }
}

#Preview {
    Dashboard()
}
