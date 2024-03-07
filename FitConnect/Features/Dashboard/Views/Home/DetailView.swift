//
//  DetailView.swift
//  FitConnect
//
//  Created by Nibha Maharjan on 2024-03-06.
//

import Foundation
import SwiftUI
import AVKit
import WebKit

struct DetailView: View {
    var item: Item = items[2]
    var body: some View {
        ScrollView {
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
            
            .background(item.gradient)
            YTView(ID: item.youtubeID)
            VStack(alignment: .center, spacing: 16) {
                
                           
                           // Your existing VStack content
                           VStack(alignment: .leading, spacing: 16) {
                               Text("You should exercise ")
                                   .font(.headline)
                               Text("In this Exercise")
                                   .font(.title).bold()
                               Text("Performing a plank is an effective and straightforward core-strengthening exercise. To execute a plank, start in a push-up position with your arms straight and hands shoulder-width apart. Engage your core muscles and maintain a straight line from your head to your heels, ensuring your body forms a plank-like position. Hold this position for a set duration, typically starting with 30 seconds and gradually increasing as your strength improves. Planks not only target the abdominal muscles but also engage the entire core, including the lower back and shoulders, making it an efficient full-body exercise.")
                           }
                           .padding()
                       }
                   }
               }
           }

struct DetailView_Preview: PreviewProvider{
    static var previews: some View{
        DetailView()
    }
}

