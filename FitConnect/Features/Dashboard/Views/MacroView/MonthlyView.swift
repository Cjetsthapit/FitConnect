//
//  MonthlyView.swift
//  FitConnect
//
//  Created by Srijeet Sthapit on 2024-03-16.
//

import SwiftUI
import Charts

struct MonthlyView: View {
    @EnvironmentObject var fitConnect: FitConnectData
    
        // Example year range for picker, adjust according to your needs
    private let yearRange: [String] = Array(2000...2024).map { String($0) }
    
    var body: some View {
        VStack {
                // Year Picker
            ScrollViewReader { scrollView in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(yearRange, id: \.self) { year in
                            Button(action: {
                                fitConnect.selectedMacroYear = year
                            }) {
                                Text(year)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 15)
                                    .background(fitConnect.selectedMacroYear == year ? Color.blue : Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .id(year) // Assign ID for ScrollViewReader
                        }
                    }
                    .padding()
                }
                .onAppear {
                        // Scroll to the last year (most recent) when the view appears
                    if let lastYear = yearRange.last {
                        scrollView.scrollTo(lastYear, anchor: .trailing)
                    }
                }
            }
            
                // Chart
            Chart {
                ForEach(fitConnect.monthlySummaryData, id: \.id) { data in
                    BarMark(
                        x: .value("Month", String(data.month.prefix(3))),
                        y: .value("Value", data.value)
                    )
                    .annotation(position: .overlay) {
                        Text(String(format: "%.1f", data.value))
                            .foregroundColor(.white)
                    }
                    .foregroundStyle(by: .value("Type", data.type))
                }
            }
            .chartYScale(range: .plotDimension(padding: 60))
            .padding()
            List {
                ForEach(groupedData(), id: \.id) { monthlySummary in
                    Section(header: Text(monthlySummary.month)) {
                        ForEach(monthlySummary.entries, id: \.id) { entry in
                            HStack {
                                Text(entry.type)
                                Spacer()
                                Text("\(entry.value, specifier: "%.1f") calories")
                            }
                        }
                    }
                }
            }
        
        }
            // This ensures the picker updates the chart when a new year is selected.
        .onAppear {
                // Optionally, set an initial year if needed
            if fitConnect.selectedMacroYear.isEmpty {
                fitConnect.selectedMacroYear = String(Calendar.current.component(.year, from: Date()))
            }
        }
    }
}
extension MonthlyView {
    func groupedData() -> [MonthlyNutrientSummary] {
        let groupedByMonth = Dictionary(grouping: fitConnect.monthlySummaryData) { $0.month }
        
        var monthlySummaries: [MonthlyNutrientSummary] = []
        
        for (month, entries) in groupedByMonth {
            let monthShort = String(month.prefix(3))
            
            let nutrientEntries = entries.map { NutrientEntry(type: $0.type, value: $0.value) }
            
            let summary = MonthlyNutrientSummary(month: monthShort, entries: nutrientEntries)
            monthlySummaries.append(summary)
        }
        
            // Map month abbreviations to numerical values for sorting
        let monthOrder: [String: Int] = [
            "Jan": 1, "Feb": 2, "Mar": 3, "Apr": 4,
            "May": 5, "Jun": 6, "Jul": 7, "Aug": 8,
            "Sep": 9, "Oct": 10, "Nov": 11, "Dec": 12
        ]
        
            // Sort summaries by month order
        let sortedSummaries = monthlySummaries.sorted(by: {
            guard let order1 = monthOrder[$0.month], let order2 = monthOrder[$1.month] else { return false }
            return order1 < order2
        })
        
        return sortedSummaries
    }
}

struct MonthlyNutrientSummary: Identifiable {
    let id = UUID()
    let month: String
    let entries: [NutrientEntry]
}

struct NutrientEntry: Identifiable {
    let id = UUID()
    let type: String
    let value: Double
}
