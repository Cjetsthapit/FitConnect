//
//  ContentView.swift
//  FitConnect
//
//  Created by Srijeet Sthapit on 2024-02-01.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showMainContent = false
    var body: some View {
        ZStack {
            if showMainContent {
                Login()
            } else {
                SplashScreen()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                    // Switch to the main content view after 2 seconds
                                showMainContent = true
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}
