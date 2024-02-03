//
//  FCTextField.swift
//  FitConnect
//
//  Created by Srijeet Sthapit on 2024-02-03.
//

import SwiftUI

struct FCTextField: View {
   var placeholder: String
    @Binding var value: String
    
    var body: some View {
        TextField(placeholder, text: $value)
            .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15)) // Add padding for better appearance
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("Border"), lineWidth: 2)
            )
            .textFieldStyle(PlainTextFieldStyle())
    }
    
  
}

