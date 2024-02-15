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
                ForEach(manager.activities.sorted(by:  {$0.value.id < $1.value.id}), id:\.key){item in
                    ActivityCard(activity:item.value)
                    
                }
            }
                .padding(.horizontal)
        }
        .onAppear{
            manager.fetchTodaySteps()
            manager.fetchTodayCalories()
        }
    }
}

struct ActivityView_Previews: PreviewProvider{
    static var previews: some View{
        ActivityView()
    }
}
