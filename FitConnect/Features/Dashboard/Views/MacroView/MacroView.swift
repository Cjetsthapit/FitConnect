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
    var body: some View {
        VStack{
            Text("Today's intake")
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
    }
}

#Preview {
    MacroView()
}
