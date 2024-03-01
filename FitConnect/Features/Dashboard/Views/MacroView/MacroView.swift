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
                .toolbar{
                    ToolbarItem{
                        Button{
                            showingForm.toggle()
                        }
                    label: {
                        Text("Add Data")
                    }
                    }
                }
                .toolbar(.visible, for: .navigationBar)
        }
        .sheet(isPresented: $showingForm) {
            AddMacro(foodName: self.$foodName, date: self.$date, showingForm: self.$showingForm)
        }
    }
}

#Preview {
    MacroView()
}
