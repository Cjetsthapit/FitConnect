//
//  HomeView.swift
//  FitConnect
//
//  Created by Nibha Maharjan on 2024-02-14.
//

import Foundation
import SwiftUI

struct HomeView: View{
    var body: some View {
        VStack {
            Text("Welcome to FitConnect")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            Text("Your personalized fitness journey starts here.")
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding()
            
            IndexView()
            
            Spacer()
        }
        .navigationBarTitle("FitConnect", displayMode: .inline)
    }
}

struct HomeView_Previews: PreviewProvider{
    static var previews: some View{
        HomeView()
    }
}
