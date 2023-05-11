//
//  TaiwanEEWApp.swift
//  TaiwanEEW
//
//  Created by Joe Lin on 2022/7/5.
//
//  This file contains the main entry point of the TaiwanEEW app.
//

import SwiftUI
import Firebase


@main
struct TaiwanEEWApp: App {
    
    @State var historyRange: TimeRange = .year
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                AlertView()
                    .tabItem {
                        Label("Alert", systemImage: "exclamationmark.triangle")
                    }
                HistoryView(historyRange: $historyRange)
                    .tabItem {
                        Label("History", systemImage: "chart.bar.doc.horizontal")
                    }
                SettingsView(onHistoryRangeChanged: { newValue in
                    historyRange = newValue
                })
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                
            }
            
        }
    }
}
