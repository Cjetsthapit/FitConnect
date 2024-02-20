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
                CircularProgressBar(progress: self.$carbValue, title: "Carbs")
                    
                    .onAppear(){
                        self.carbValue = fitConnect.totalCarb
                    }.padding()
                CircularProgressBar(progress: self.$proteinValue,title: "Protein")
            
                    .onAppear(){
                        self.proteinValue = fitConnect.totalProtein

                    }.padding()
                CircularProgressBar(progress: self.$fatValue,title: "Fats")
            
                    .onAppear(){
                        self.fatValue = fitConnect.totalFat
                    }.padding()
            }
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
            print(fitConnect.totalCarb)
        }
    }
}

#Preview {
    MacroView()
}
