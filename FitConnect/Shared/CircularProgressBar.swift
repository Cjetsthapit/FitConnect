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
    var total: Int
    var color: Color = .green
    
    var body: some View {
        VStack{
            Text(title)
            ZStack{
                
                Circle().stroke(lineWidth: 10.0)
                    .opacity(0.20)
                    .foregroundColor(Color.gray)
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(self.progress/Double(total), 1.0)))
                    .stroke(style: StrokeStyle(lineWidth: 8.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(self.getProgressColor(progressLevel: self.progress / Double(total)))
                    .rotationEffect(Angle(degrees: 270))
                    .animation(.easeInOut, value: 2.0)
                if progress > Double(total) {
                    Image(systemName: "exclamationmark.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.red)
                }
            }
            Text("\(progress.formattedString()) gm")
        }
       
    }
    
    private func getProgressColor(progressLevel: Double) -> Color {
        switch progressLevel {
            case 0..<0.25:
                return .green
            case 0.25..<0.6:
                return .green
            case 0.6..<0.80:
                return .yellow
            case 0.80...1.0:
                return .orange
            default:
                return .red // Default color if needed
        }
    }
}

