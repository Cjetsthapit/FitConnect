import SwiftUI
import Charts

struct WeightTracker: View {
    @State private var showingForm = false
    @EnvironmentObject var fitConnect: FitConnectData
    var weights: [String: WeightEntry]? // Your weight entries dictionary
    
    var sortedWeightsForChart: [(key: String, value: WeightEntry)] {
        guard let weights = fitConnect.fitConnectData?.weights else { return [] }
        return weights.sorted { $0.key < $1.key }
    }
    
        // Sorted for List: Descending (most recent date first)
    var sortedWeightsForList: [(key: String, value: WeightEntry)] {
        guard let weights = fitConnect.fitConnectData?.weights else { return [] }
        return weights.sorted { $0.key > $1.key }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if let weights = fitConnect.fitConnectData?.weights, !weights.isEmpty {
                        Chart {
                            ForEach(sortedWeightsForChart.suffix(7), id: \.key) { entry in
                                LineMark(
                                    x: .value("Date", String(entry.key.suffix(5))),
                                    y: .value("Weight", entry.value.weight)
                                )
                                .interpolationMethod(.catmullRom)
                                
                                PointMark(
                                    x: .value("Date", String(entry.key.suffix(5))),
                                    y: .value("Weight", entry.value.weight)
                                )
                                .foregroundStyle(.red)
                            }
                        }
                    Text((fitConnect.fitConnectData?.weightGoal)!)
         

                    List {
                        ForEach(0..<sortedWeightsForList.count, id: \.self) { index in
                            HStack {
                                Text(sortedWeightsForList[index].key) // Display the date
                                Spacer()
                                Text("\(sortedWeightsForList[index].value.weight, specifier: "%.2f") kg") // Display the weight
                                Spacer()
                                    // Arrow indicator and difference calculation
                                if index < sortedWeightsForList.count - 1 { // Ensure there is a next item to compare
                                    let currentWeight = sortedWeightsForList[index].value.weight
                                    let previousWeight = sortedWeightsForList[index + 1].value.weight
                                    let difference = currentWeight - previousWeight
                                    let goal = fitConnect.fitConnectData?.weightGoal
                                    Group {
                                        Image(systemName: difference > 0 ? "arrow.up" : difference < 0 ? "arrow.down" : "minus")
                                            .foregroundColor(getArrowColor(difference: difference, weightGoal: goal))
                                        if difference != 0 {
                                            Text(String(format: "%.2f", abs(difference)))
                                                .foregroundColor(getArrowColor(difference: difference, weightGoal: goal))
                                        }
                                    }
//                                    Group {
//                                        Image(systemName: difference > 0 ? "arrow.up" : difference < 0 ? "arrow.down" : "minus")
//                                            .foregroundColor(difference > 0 ? .green : difference < 0 ? .red : .gray)
//                                        if difference != 0 {
//                                            Text(String(format: "%.2f", abs(difference)))
//                                                .foregroundColor(difference > 0 ? .green : .red)
//                                        }
//                                    }
                                } else {
                                        // For the last item in the list, there's no previous day to compare to
                                    Image(systemName: "minus")
                                        .foregroundColor(.gray)
                                }
                                
                                
                            }
                        }
                    }
                   
                    Spacer()
                } else {
                    Text("You can start tracking your weight now!")
                        .font(.title)
                        .padding()
                        .multilineTextAlignment(.center)
                }
                Spacer()
            }

            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                        // Custom title placement
                    Text("Weight Tracker").font(.headline)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Weight") {
                        showingForm = true
                    }
                }
            }
            .sheet(isPresented: $showingForm) {
                    // Assume AddWeight is a view that uses `showingForm` to dismiss
                AddWeight(showingForm: $showingForm)
            }
        }
    }
   
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE" // Day name in week
        return formatter
    }()
}

func getArrowColor(difference: Double, weightGoal: String?) -> Color {
    switch weightGoal {
        case "Lose Weight":
            return difference < 0 ? .green : .red
        case "Gain Weight":
            return difference > 0 ? .green : .red
        default:
            return .gray
    }
}



