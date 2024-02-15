//
//  TabView.swift
//  FitConnect
//
//  Created by Nibha Maharjan on 2024-02-14.
//

import Foundation
import SwiftUI

struct ActivityView: View{
    @EnvironmentObject var manager: HealthManager
    var body: some View {
        VStack{
            LazyVGrid(columns: Array(repeating: GridItem(spacing:20), count: 2)) {
                ActivityCard(activity: Activity(id:0,title: "Daily Steps", subtitle: "Goal: 1000", image: "figure.walk", amount: "1293"))
                ActivityCard(activity: Activity(id:0,title: "Daily Steps", subtitle: "Goal: 1000", image: "figure.walk", amount: "1293"))
            }
                .padding(.horizontal)
        }
        .onAppear{
            manager.fetchTodaySteps()
        }
    }
}

struct ActivityView_Previews: PreviewProvider{
    static var previews: some View{
        ActivityView()
    }
}
