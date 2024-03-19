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

enum ChartOptions{
    case oneWeek
    case oneMonth
    case threeMonth
    case yearToDate
    case oneYear
}

struct ChartView: View {
    @EnvironmentObject var manager: HealthManager
    @State var selectedChat: ChartOptions = .oneMonth
    var body: some View {
        VStack(spacing: 12){
            Chart{
                ForEach(manager.oneMonthChartData) { daily in
                    BarMark(x: .value(daily.date.formatted(), daily.date, unit: .day), y: .value("Steps", daily.stepCount))
                }
            }
            .foregroundColor(.green)
            .frame(height: 350)
            .padding(.horizontal)
            HStack{
                Button("1W"){
                    withAnimation {
                        selectedChat = .oneWeek
                    }
                }
                .padding(.all)
                .foregroundColor(selectedChat == .oneWeek ? .white : .green)
                .background(selectedChat == .oneWeek ? .green : .clear)
                .cornerRadius(10)
                Button("1M"){
                    withAnimation {
                        selectedChat = .oneMonth
                    }
                }
                .padding(.all)
                .foregroundColor(selectedChat == .oneMonth ? .white : .green)
                .background(selectedChat == .oneMonth ? .green : .clear)
                .cornerRadius(10)
                Button("3M"){
                    withAnimation {
                        selectedChat = .threeMonth
                    }
                }
                .padding(.all)
                .foregroundColor(selectedChat == .threeMonth ? .white : .green)
                .background(selectedChat == .threeMonth ? .green : .clear)
                .cornerRadius(10)
                Button("YTD"){
                    withAnimation {
                        selectedChat = .yearToDate
                    }
                }
                .padding(.all)
                .foregroundColor(selectedChat == .yearToDate ? .white : .green)
                .background(selectedChat == .yearToDate ? .green : .clear)
                .cornerRadius(10)
                Button("1Y"){
                    withAnimation {
                        selectedChat = .oneYear
                    }
                }
                .padding(.all)
                .foregroundColor(selectedChat == .oneYear ? .white : .green)
                .background(selectedChat == .oneYear ? .green : .clear)
                .cornerRadius(10)
            }
            
        }
        .onAppear(){
            print(manager.oneMonthChartData)
        }
    
    }
}

#Preview {
    ChartView()
        .environmentObject(HealthManager())
}
