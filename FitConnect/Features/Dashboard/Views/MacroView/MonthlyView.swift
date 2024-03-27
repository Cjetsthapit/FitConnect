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
                            .id(year) 
                        }
                    }
                    .padding()
                }
                .onAppear {
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
                        y: .value("Value", data.value  )
                    )
                    .foregroundStyle(by: .value("Type", data.type))
                }
                
            }
            .padding()
            List {
                ForEach(groupedData(), id: \.id) { monthlySummary in
                    Section(header: Text(monthlySummary.month)) {
                        ForEach(monthlySummary.entries, id: \.id) { entry in
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
                                Text("\(entry.value, specifier: "%.1f") calories")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Monthly Summary")
        }
        .onAppear {
                fitConnect.selectedMacroYear = String(Calendar.current.component(.year, from: Date()))
        }
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
