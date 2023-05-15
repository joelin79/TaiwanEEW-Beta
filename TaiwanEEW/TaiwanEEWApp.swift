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
    
    // selection variables accessable between views
    @AppStorage("historyRange") var historyRange: TimeRange = .year
    @AppStorage("subscribedLoc") var subscribedLoc: Location = .taipei
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                AlertView(eventManager: EventDispatcher(subscribedLoc: $subscribedLoc), historyRange: $historyRange, subscribedLoc: $subscribedLoc)
                    .tabItem {
                        Label("Alert", systemImage: "exclamationmark.triangle")
                    }
                HistoryView(eventManager: EventDispatcher(subscribedLoc: $subscribedLoc), historyRange: $historyRange, subscribedLoc: $subscribedLoc)
                    .tabItem {
                        Label("History", systemImage: "chart.bar.doc.horizontal")
                    }
                SettingsView(
                    onHistoryRangeChanged: { newValue in
                    historyRange = newValue
                }, onSubscribedLocChanged: {
                    newValue in
                    subscribedLoc = newValue
                })
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                
            }
            
        }
    }
}
