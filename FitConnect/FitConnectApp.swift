//
//  FitConnectApp.swift
//  FitConnect
//
//  Created by Srijeet Sthapit on 2024-02-01.
//  Nibha Maharjan 301282952
//  Srijeet Sthapit 301365217
//  Abi Chitrakar 301369773
//  Saurav Gautam 301286980

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct FitConnectApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView() .environmentObject( FitConnectData())
        }
    }
}
