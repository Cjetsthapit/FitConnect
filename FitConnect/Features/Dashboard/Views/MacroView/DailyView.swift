import SwiftUI

struct DailyView: View {
    @EnvironmentObject var fitConnect: FitConnectData
    @State private var selectedDate = Date()
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(DefaultDatePickerStyle())
                    .onChange(of: selectedDate) {oldValue,  newValue in
                        fitConnect.selectedMacroDate = newValue
                        fitConnect.filterMacroIntakes()
                    }
                Spacer()
            }
            
            nutrientProgressBars
            
            intakeListOrEmptyMessage
            
            Spacer()
        }
        .padding()
    }
    
    private var nutrientProgressBars: some View {
        HStack {
            CircularProgressBar(progress: self.$fitConnect.totalCarb, title: "Carbs", total: fitConnect.fitConnectData?.macroLimit.carb ?? 0)
                .padding()
            
            CircularProgressBar(progress: self.$fitConnect.totalProtein, title: "Protein", total: fitConnect.fitConnectData?.macroLimit.protein ?? 0)
                .padding()
            
            CircularProgressBar(progress: self.$fitConnect.totalFat, title: "Fats", total: fitConnect.fitConnectData?.macroLimit.fat ?? 0)
                .padding()
        }
    }
    
    private var intakeListOrEmptyMessage: some View {
        Group {
            if fitConnect.filteredIntakes.isEmpty {
                VStack {
                    Image(systemName: "exclamationmark.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.gray)
                    Text("No data available")
                        .font(.title)
                        .foregroundColor(.gray)
                }
            } else {
                List(fitConnect.filteredIntakes, id: \.self) { macro in
                    MacroDetailView(macro: macro)
                }
            }
        }
    }
}

struct MacroDetailView: View {
    let macro: Macro
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(macro.food.capitalized)
                .font(.headline)
            HStack(spacing: 5) {
                NutrientDetailView(nutrientName: "Carb", value: macro.carb, iconName: "tennis.racket.circle")
                    .frame(maxWidth: .infinity)
                    .background(.blue.opacity(0.1))
                    .cornerRadius(8)
                
                NutrientDetailView(nutrientName: "Protein", value: macro.protein, iconName: "leaf.fill")
                    .frame(maxWidth: .infinity)
                    .background(.green.opacity(0.1))
                    .cornerRadius(8)
                
                NutrientDetailView(nutrientName: "Fat", value: macro.fat, iconName: "flame.fill")
                    .frame(maxWidth: .infinity)
                    .background(.yellow.opacity(0.1))
                    .cornerRadius(8)
               
               
            }
            .cornerRadius(10)
//
        }
    }
}

struct NutrientDetailView: View {
    let nutrientName: String
    let value: Double
    let iconName: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            
            Image(systemName: iconName)
                .foregroundColor(nutrientColor)
                .accessibilityHidden(true)
                .frame(maxWidth: .infinity) 
            
            VStack(alignment: .center, spacing: 2) {
                Text("\(nutrientName)")
                    .font(.caption)
                    .bold()
                Text("\(value, specifier: "%.1f")g")
                    .font(.caption)
                    .accessibilityLabel("\(nutrientName) \(value) grams")
            }
            .frame(maxWidth: .infinity)
        }
        .padding(8)
        .frame(maxWidth: .infinity)
        .cornerRadius(10)
        .shadow(radius: 5)

    }
    
    private var nutrientColor: Color {
        switch nutrientName {
            case "Fat":
                return .yellow
            case "Protein":
                return .green
            case "Carb":
                return .blue
            default:
                return .gray
        }
    }
}


    // Ensure you provide an instance of FitConnectData as an environment object where DailyView is used.
    // Preview provider adjusted for new subview structure.
struct DailyView_Previews: PreviewProvider {
    static var previews: some View {
        DailyView().environmentObject(FitConnectData())
    }
}

