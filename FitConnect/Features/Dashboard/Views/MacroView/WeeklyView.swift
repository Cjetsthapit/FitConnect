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
            ForEach(fitConnect.weeklySummaryData) { dataEntry in
                BarMark(
                    x: .value("Day", dataEntry.day),
                    y: .value("Calories", dataEntry.hours)
                )
                .annotation(position: .top) {
                    Text("\(dataEntry.hours, specifier: "%.1f")")
                        .font(.caption)
                        .foregroundColor(.white)
                }
                .foregroundStyle(by: .value("Type", dataEntry.type))
            }
        }
        .chartYAxis {
            AxisMarks(preset: .extended, position: .leading)
        }
        .chartLegend(.visible)
        .chartForegroundStyleScale([
            "Carbs": .blue,
            "Protein": .green,
            "Fat": .orange
        ])
        .padding()
    

        
        List {
            ForEach(groupedData(), id: \.id) { dailySummary in
                Section(header: Text(dailySummary.day)) {
                    ForEach(dailySummary.entries, id: \.id) { entry in
                        HStack {
                            switch entry.type {
                                case "Carbs":
                                    detail(iconName: "tennis.racket.circle", nutrientColor: .blue, text: "Carbs")
                                case "Protein":
                                    detail(iconName: "leaf.fill", nutrientColor: .green, text: "Protein")
                                case "Fat":
                                    detail(iconName: "flame.fill", nutrientColor: .yellow, text: "Fat")
                                    
                                default:
                                    Text(entry.type).foregroundColor(.red)
                            }
                            
                            Spacer()
                            Text("\(entry.hours, specifier: "%.1f") calories")
                        }
                    }
                }
            }
        }
        
  
        .navigationTitle("Weekly Summary")
       
    }
    

    private func detail(iconName: String, nutrientColor: Color, text: String) -> some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(nutrientColor)
                .accessibilityHidden(true)
              
            Text(text)
                .foregroundColor(nutrientColor) 
           
        }
    }
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
    private func groupedData() -> [WeeklySummarizedData] {
        let groupedDictionary = Dictionary(grouping: fitConnect.weeklySummaryData, by: { $0.day })
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E" 
        
        let calendar = Calendar.current
        
        return groupedDictionary.compactMap { day, entries in
            guard let date = dateFormatter.date(from: day) else { return nil }
            let weekdayIndex = calendar.component(.weekday, from: date)
            return WeeklySummarizedData(day: day, entries: entries, weekdayIndex: weekdayIndex)
        }
        .sorted { $0.weekdayIndex < $1.weekdayIndex }
    }
}

struct WeeklySummarizedData: Identifiable {
    var id: String { day }
    let day: String
    let entries: [WeeklyViewData]
    let weekdayIndex: Int // Add this property
}

