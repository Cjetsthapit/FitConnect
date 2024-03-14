//
//  ActivityView.swift
//  FitConnect
//
//  Created by Nibha Maharjan on 2024-02-14.
//

import Foundation
import SwiftUI

struct ActivityView: View{
    @EnvironmentObject var manager: HealthManager
    let welcomeArray = ["Welcome","Bienvenue","Bienvenido"]
    @State private var currentIndex = 0
    
    var body: some View {
        VStack(alignment:.leading){
            Text(welcomeArray[currentIndex])
                .font(.largeTitle)
                .padding()
                .foregroundColor(.secondary)
                .animation(.easeInOut(duration: 1), value:currentIndex)
                .onAppear{
                    startWelcomeTimer()
                }
            LazyVGrid(columns: Array(repeating: GridItem(spacing:20), count: 2)) {
                ForEach(manager.activities.sorted(by:  {$0.value.id < $1.value.id}), id:\.key){item in
                    ActivityCard(activity:item.value)
                    
                }
            }
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .top)
        }
    //Welcome cycle message
    func startWelcomeTimer(){
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true){
            _ in withAnimation{
                currentIndex = (currentIndex + 1) % welcomeArray.count
            }
        }
    }
    }


struct ActivityView_Previews: PreviewProvider{
    static var previews: some View{
        ActivityView()
            .environmentObject(HealthManager())
    }
}
