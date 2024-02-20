    //
    //  MacroView.swift
    //  FitConnect
    //
    //  Created by Srijeet Sthapit on 2024-02-15.
    //

import SwiftUI

struct MacroView: View {
    @State private var showingForm = false
    @State private var foodName = ""
    @State private var date = Date()
    @State var carbValue: Double = 0.0
    @State var proteinValue: Double = 0.0
    @State var fatValue: Double = 0.0
    @EnvironmentObject var fitConnect:  FitConnectData
    var body: some View {
        VStack{
            Text("Today's intake")
            HStack(){
                CircularProgressBar(progress: self.$fitConnect.totalCarb, title: "Carbs")
                    .padding()
                
                CircularProgressBar(progress: self.$fitConnect.totalProtein, title: "Protein")
                    .padding()
                
                CircularProgressBar(progress: self.$fitConnect.totalFat, title: "Fats")
                    .padding()

            }
            List {
                ForEach(fitConnect.fitConnectData?.food ?? [], id: \.self) { macro in
                    VStack(alignment: .leading) {
                        Text("Food: \(macro.food)")
//                        Text("Date: \(macro.date)")
                        Text("Protein: \(macro.protein.formattedString())")
                        Text("Carb: \(macro.carb.formattedString())")
                        Text("Fat: \(macro.fat.formattedString())")
                    }
                }
            }
//            List(fitConnect.fitConnectData!.food, id: \.self) { item in
//                Text(item.food)
//            }
            .padding()
                .toolbar{
                    ToolbarItem{
                        Button{
                            showingForm.toggle()
                        }
                    label: {
                            //                    Image(systemName: "plus").foregroundColor(.black)
                        Text("Add Data")
                    }
                    }
                }
                .toolbar(.visible, for: .navigationBar)
        }
        .sheet(isPresented: $showingForm) {
            AddMacro(foodName: self.$foodName, date: self.$date, showingForm: self.$showingForm)
        }
        .onAppear(){
            print("Total carb: ",fitConnect.totalCarb)
        }
    }
}

#Preview {
    MacroView()
}
