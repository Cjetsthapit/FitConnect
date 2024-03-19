//
//  ChartView.swift
//  FitConnect
//
//  Created by Nibha Maharjan on 2024-03-18.
//

import SwiftUI
import Charts


struct DailyStepView: Identifiable {
    let id = UUID()
    let date: Date
    let stepCount: Double
}

struct ChartView: View {
    @EnvironmentObject var manager: HealthManager
    var body: some View {
        VStack{
            Chart{
                ForEach(manager.oneMonthChartData) { daily in
                    BarMark(x: .value(daily.date.formatted(), daily.date, unit: .day), y: .value("Steps", daily.stepCount))
                }
            }
        }
    }
}

#Preview {
    ChartView()
        .environmentObject(HealthManager())
}
