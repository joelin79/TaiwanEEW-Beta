//
//  TaiwanEEWApp.swift
//  TaiwanEEW
//
//  Created by Joe Lin on 2022/7/5.
//

import SwiftUI
import Firebase


@main
struct TaiwanEEWApp: App {
    
    init(){
        FirebaseApp.configure()
    }
    
    /*
    Global Variables
     intensity: alert.intensity
     seconds from arrival: -Int(Date().timeIntervalSince(arrivalTime))
     */
    
    
    var body: some Scene {
        WindowGroup {
            TabView {
                AlertView()
                    .tabItem {
                        Label("Alert", systemImage: "exclamationmark.triangle")
                    }
                HistoryView()
                    .tabItem {
                        Label("History", systemImage: "chart.bar.doc.horizontal")
                    }
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
            
        }
    }
}
