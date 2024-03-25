//
//  TotalActivityPage.swift
//  FitConnect
//
//  Created by Nibha Maharjan on 2024-03-24.
//

import SwiftUI

struct TotalActivityPage: View {
    var body: some View {
        TabView {
                    ActivityView()
                        .tabItem {
                            Image(systemName: "list.bullet")
                            Text("Activity")
                        }
                    ChartView()
                        .tabItem {
                            Image(systemName: "chart.bar.fill")
                            Text("Chart")
                        }
                }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}

#Preview {
    TotalActivityPage()
}
