//
//  TabView.swift
//  FitConnect
//
//  Created by Nibha Maharjan on 2024-02-14.
//

import SwiftUI

struct Activity{
    let id:Int
    let title: String
    let subtitle: String
    let image: String
    let tintColor: Color
    let amount: String
    
}
struct ActivityCard: View{
    @State var activity: Activity
    
    var body: some View {
        
        ZStack{
            Color(uiColor: .systemGray6)
                .cornerRadius(15)
            VStack(spacing:20){
                HStack(alignment: .top){
                    VStack(alignment: .leading, spacing: 5
                    ){
                        Text(activity.title)
                            .font(.system(size: 16))
                        Text(activity.subtitle)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Image(systemName: activity.image)
                        .minimumScaleFactor(0.6)
                        .foregroundColor(activity.tintColor)
                        .padding()
                }
                
                Text(activity.amount)
                    .font(.system(size: 24))
                    .bold()
            }
            .padding()
        }
        
       
    }
}
struct ActivityCard_Previews: PreviewProvider{
    static var previews: some View{
        ActivityCard(activity: Activity(id:0,title: "Daily Steps", subtitle: "Goal: 1000", image: "figure.walk", tintColor: .green, amount: "1293"))
       
    }
}

