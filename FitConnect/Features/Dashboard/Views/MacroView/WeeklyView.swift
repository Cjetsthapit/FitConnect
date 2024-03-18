    //
    //  MonthlyView.swift
    //  FitConnect
    //
    //  Created by Srijeet Sthapit on 2024-03-16.
    //

import SwiftUI
import Charts

struct WeeklyView: View {
    @State private var selectedDate: Date = Date()
    @State private var weekStart: Date = Date()
    @State private var weekEnd: Date = Date()
    @EnvironmentObject var fitConnect: FitConnectData
    
    var body: some View {
        VStack {
            DatePicker(
                "Select a Date",
                selection: $selectedDate,
                displayedComponents: .date
            )
            .onChange(of: selectedDate) { oldValue, newValue in
                updateWeekRange(for: newValue)
            }
            .padding()
            
            Text( "Calories from \(weekStart.formatted(date: .abbreviated, time: .omitted))-\(weekEnd.formatted(date: .abbreviated, time: .omitted)) ")
        }
        .onAppear {
            updateWeekRange(for: selectedDate)
        }
        Chart {
            
            ForEach (fitConnect.weeklySummaryData) { d in
                
                BarMark(x: .value("Day", d.day),
                        y: .value("Calories", d.hours))
                .annotation (position: .overlay) {
                }
                .foregroundStyle(by: .value("Type", d.type))
            }
            
        }
        
        .chartYScale(range: .plotDimension(padding: 60))
        .padding()
        
//        List {
//                // Group by day
//            ForEach(groupDataByDay(), id: \.key) { day, entries in
//                Section(header: Text(day)) {
//                        // For each type within a day, display the total
//                    ForEach(entries, id: \.id) { entry in
//                        HStack {
//                            Text(entry.type)
//                            Spacer()
//                            Text("\(entry.hours, specifier: "%.1f") hours")
//                        }
//                    }
//                }
//            }
//        }
        
        List {
            ForEach(fitConnect.weeklySummaryData) { data in
                HStack {
                    Text(data.day)
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("\(data.type):")
                            .bold()
                        Text(String(format: "%.1f calories", data.hours))
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .navigationTitle("Weekly Summary")
       
    }
    
//    private func groupDataByDay() -> [String: [WeeklyViewData]] {
//        Dictionary(grouping: fitConnect.weeklySummaryData, by: { $0.day })
//    }
    
    private func updateWeekRange(for date: Date) {
        let calendar = Calendar.current
        
            // Find the start of the week
        if let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)) {
            weekStart = startOfWeek
        }
        
            // Calculate the end of the week
        if let endOfWeek = calendar.date(byAdding: .day, value: 6, to: weekStart) {
            weekEnd = endOfWeek
        }
        
        fitConnect.selectedMacroRange = [weekStart, weekEnd]
    }
}

