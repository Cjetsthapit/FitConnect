import SwiftUI

struct MacroView: View {
    @State private var showingForm = false
    @EnvironmentObject var fitConnect: FitConnectData
    @State private var timeFrameSelection = "Daily"
    @State private var isShowingMacroUpdate = false
    private let timeFrameOptions = ["Daily", "Weekly", "Monthly"]
    
    var body: some View {
        if fitConnect.fitConnectData?.macroLimit.carb == -1 {
            MacroLimit(isShowingMacroUpdate: $isShowingMacroUpdate)
        } else {
            NavigationView {
                VStack {
                    Picker("Time Frame", selection: $timeFrameSelection) {
                        ForEach(timeFrameOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    Group {
                        switch timeFrameSelection {
                            case "Daily":
                                DailyView()
                            case "Weekly":
                                WeeklyView()
                            case "Monthly":
                                MonthlyView()
                            default:
                                EmptyView()
                        }
                    }
                }
                .navigationBarTitle("Macro Intake", displayMode: .inline)
                .toolbar {
                    ToolbarItem {
                        Button("Add Data") {
                            showingForm = true
                        }
                    }
                }
                .sheet(isPresented: $showingForm) {
                        // Assuming AddMacro needs these states, they should be declared within it
                    AddMacro(showingForm : $showingForm)
                }
            }
        }
    }
}

struct MacroView_Previews: PreviewProvider {
    static var previews: some View {
        MacroView().environmentObject(FitConnectData())
    }
}
