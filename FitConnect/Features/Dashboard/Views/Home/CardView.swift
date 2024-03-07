//
//  CardView.swift
//  FitConnect
//
//  Created by Nibha Maharjan on 2024-03-06.
//

import SwiftUI

struct CardView: View {
    var item: Item = items[2]
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(item.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 128)
                .frame(maxWidth: .infinity)
            Text(item.title)
            
                .font(.title)
                .fontWeight(.bold)
                .blendMode(.overlay)
            Text(item.text)
                .lineLimit(1)
            Text("30 Minutes")
        }
        .foregroundColor(.white)
        .padding(11)
        .frame(width: 252,height: 329)
        
        .background(item.gradient)
        
        .cornerRadius(/*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
    }
}


#Preview {
    CardView()
}
