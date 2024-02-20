//
//  CircularProgressBar.swift
//  FitConnect
//
//  Created by Srijeet Sthapit on 2024-02-19.
//

import SwiftUI

struct CircularProgressBar: View {
    @Binding var progress: Double
     var title: String
    var color: Color = .green
    var body: some View {
        VStack{
            Text(title)
            ZStack{
                
                Circle().stroke(lineWidth: 10.0)
                    .opacity(0.20)
                    .foregroundColor(Color.gray)
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(self.progress/100, 1.0)))
                    .stroke(style: StrokeStyle(lineWidth: 8.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(color)
                    .rotationEffect(Angle(degrees: 270))
                    .animation(.easeInOut, value: 2.0)
            }
            Text("\(progress.formattedString()) gm")
        }
       
    }
}

#Preview {
    CircularProgressBar(progress: .constant(0.50),title:"Demo")
}
