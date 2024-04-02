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

enum ChartOptions {
    case oneWeek
    case oneMonth
    case threeMonth
    case yearToDate
    case oneYear
}

struct ChartView: View {
    @EnvironmentObject var manager: HealthManager
    @State var selectedChart: ChartOptions = .oneMonth
    
    var body: some View {
        VStack(spacing: 12) {
            Chart {
                ForEach(chartData()) { daily in
                    BarMark(x: .value(daily.date.formatted(), daily.date, unit: .day), y: .value("Steps", daily.stepCount))
                }
            }
            .foregroundColor(.green)
            .frame(height: 350)
            .padding(.horizontal)
            
            HStack {
                Button("1W") {
                    withAnimation {
                        selectedChart = .oneWeek
                        manager.fetchPastWeekStepData()
                    }
                }
                .padding(.all)
                .foregroundColor(selectedChart == .oneWeek ? .white : .green)
                .background(selectedChart == .oneWeek ? .green : .clear)
                .cornerRadius(10)
                
                Button("1M") {
                    withAnimation {
                        selectedChart = .oneMonth
                        manager.fetchPastMonthStepData()
                    }
                }
                .padding(.all)
                .foregroundColor(selectedChart == .oneMonth ? .white : .green)
                .background(selectedChart == .oneMonth ? .green : .clear)
                .cornerRadius(10)
                
                Button("3M") {
                    withAnimation {
                        selectedChart = .threeMonth
                        manager.fetchThreeMonthStepData()
                    }
                }
                .padding(.all)
                .foregroundColor(selectedChart == .threeMonth ? .white : .green)
                .background(selectedChart == .threeMonth ? .green : .clear)
                .cornerRadius(10)
                
                Button("YTD") {
                    withAnimation {
                        selectedChart = .yearToDate
                        manager.fetchYearToDateStepData()
                    }
                }
                .padding(.all)
                .foregroundColor(selectedChart == .yearToDate ? .white : .green)
                .background(selectedChart == .yearToDate ? .green : .clear)
                .cornerRadius(10)
                
                Button("1Y") {
                    withAnimation {
                        selectedChart = .oneYear
                        manager.fetchPastYearStepData()
                    }
                }
                .padding(.all)
                .foregroundColor(selectedChart == .oneYear ? .white : .green)
                .background(selectedChart == .oneYear ? .green : .clear)
                .cornerRadius(10)
            }
        }
        .onChange(of: selectedChart) { newValue in
            // Handle additional changes if needed
        }
    }
    
    private func chartData() -> [DailyStepView] {
        switch selectedChart {
        case .oneWeek:
            return manager.oneWeekChartData
        case .oneMonth:
            return manager.oneMonthChartData
        case .threeMonth:
            return manager.ThreeMonthChartData
        case .yearToDate:
            return manager.YearToDateChartData
        case .oneYear:
            return manager.OneYearChartData
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
            .environmentObject(HealthManager())
    }
}
