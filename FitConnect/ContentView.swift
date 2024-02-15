//
//  ContentView.swift
//  FitConnect
//
//  Created by Srijeet Sthapit on 2024-02-01.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    
    @State private var showMainContent = false
    @State private var uid:String=""
    @State private var showRegisterView = false
    @StateObject var user = UserState()
    @StateObject var manager = HealthManager()
    
    var body: some View {
        ZStack {
            if showMainContent {
                if user.userId == nil {

                        if !showRegisterView {
                            Login(user:user, toggleView: {showRegisterView.toggle()})
                          
                        } else {
                            Register(toggleView: {showRegisterView.toggle()})
                        }
                    
                }
                else {
                    NavigationStack{
                        Dashboard(user:user)
                            .environmentObject(manager)
                    }
                  
                }
             
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
