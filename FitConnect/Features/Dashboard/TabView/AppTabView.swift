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
    @EnvironmentObject var fitConnect:  FitConnectData
    @State var selectedTab = "Home"
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tag("Home")
                .tabItem{Image(systemName: "house")}
            TotalActivityPage()
                .tag("Activity")
                .tabItem{Image(systemName: "trophy")}
                .environmentObject(manager)
//            ActivityView()
//                .tag("Activity")
//                .tabItem{Image(systemName: "trophy")}
//                .environmentObject(manager)
//            ChartView()
//                .tag("Chart")
//                .tabItem{Image(systemName: "chart.xyaxis.line")}
//                .environmentObject(manager)
            ChatBotView()
                .tag("ChatBot")
                .tabItem{Image(systemName: "paperplane.fill")}
            MacroView()
                .tag("Macro")
                .tabItem{Image(systemName: "fork.knife")}
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
