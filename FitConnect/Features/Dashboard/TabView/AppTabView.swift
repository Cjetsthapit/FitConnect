//
//  TabView.swift
//  FitConnect
//
//  Created by Nibha Maharjan on 2024-02-14.
//

import Foundation
import SwiftUI

struct AppTabView: View{
    @EnvironmentObject var manager: HealthManager
    @State var selectedTab = "Home"
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tag("Home")
                .tabItem{Image(systemName: "house")}
            ActivityView()
                .tag("Activity")
                .tabItem{Image(systemName: "trophy")}
                .environmentObject(manager)
            UserView()
                .tag("User")
                .tabItem{Image(systemName: "person.circle")}
        }
    }
}

struct AppTabView_Previews: PreviewProvider{
    static var previews: some View{
        AppTabView()
    }
}
