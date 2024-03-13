
import SwiftUI

struct MacroView: View {
    @State private var showingForm = false
    @State private var foodName = ""
    @State private var date = Date()
    @State var carbValue: Double = 0.0
    @State var proteinValue: Double = 0.0
    @State var fatValue: Double = 0.0
    @EnvironmentObject var fitConnect: FitConnectData
    @State private var selectedDate = Date()
    @State private var dateString: String = ""
    @State private var isShowingMacroUpdate = false
    
    var body: some View {
        if(fitConnect.fitConnectData?.macroLimit.carb == -1){
            MacroLimit(isShowingMacroUpdate: $isShowingMacroUpdate)
        }
        else {
            NavigationView {
                VStack {
                    Text("Intake fors")
                   
            
                    HStack {
                        Spacer() // Add Spacer before DatePicker
                        
                        DatePicker("", selection: $selectedDate, displayedComponents: .date)
                            .datePickerStyle(DefaultDatePickerStyle())
                            .onChange(of: selectedDate) { newValue in
                                    // Perform filtering when the selected date changes
                                fitConnect.selectedMacroDate = newValue
                                fitConnect.filterMacroIntakes()
                            }
                        
                        Spacer() // Add Spacer after DatePicker
                    }
                           
                    
                    HStack {
                        CircularProgressBar(progress: self.$fitConnect.totalCarb, title: "Carbs", total: (fitConnect.fitConnectData?.macroLimit.carb)!)
                            .padding()
                        
                        CircularProgressBar(progress: self.$fitConnect.totalProtein, title: "Protein",
                                            total: (fitConnect.fitConnectData?.macroLimit.protein)!)
                            .padding()
                        
                        CircularProgressBar(progress: self.$fitConnect.totalFat, title: "Fats",
                                            total: (fitConnect.fitConnectData?.macroLimit.fat)!)
                            .padding()
                    }
                    List {
                        ForEach(fitConnect.filteredIntakes , id: \.self) { macro in
                            VStack(alignment: .leading, spacing: 8) {
                                Text("\(macro.food.capitalized)")
                                    .font(.headline)
                                
                                HStack(spacing: 16) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack {
                                            Image(systemName: "flame")
                                            Text("Fat:")
                                        }
                                        HStack {
                                            Image(systemName: "leaf")
                                            Text("Protein:")
                                        }
                                        HStack {
                                            Image(systemName: "tennis.racket.circle")
                                            Text("Carb:")
                                        }
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("\(macro.fat.formattedString()) gm")
                                            .font(.subheadline)
                                        Text("\(macro.protein.formattedString()) gm")
                                            .font(.subheadline)
                                        Text("\(macro.carb.formattedString()) gm")
                                            .font(.subheadline)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
                .toolbar {
                    ToolbarItem {
                        Button(action: {
                            showingForm.toggle()
                        }) {
                            Text("Add Data")
                        }
                    }
                }
                .sheet(isPresented: $showingForm) {
                    AddMacro(foodName: self.$foodName, date: self.$date, showingForm: self.$showingForm)
                }
                .onAppear() {
                    print("Total carb: ", fitConnect.totalCarb)
                }
            }
        }
    }
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
  
}

struct MacroView_Previews: PreviewProvider {
    static var previews: some View {
        MacroView()
    }
}
