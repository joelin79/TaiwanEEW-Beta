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
import UserNotifications
import BackgroundTasks


@main
struct TaiwanEEWApp: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var phase
    let appRefreshInterval: TimeInterval = 10           // seconds
    
    // selection variables accessable between views
    @AppStorage("historyRange") var historyRange: TimeRange = .year
    @AppStorage("subscribedLoc") var subscribedLoc: Location = .taipei
    @StateObject var sheetManager = SheetManager()
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    @AppStorage("notifyThreshold") var notifyThreshold: NotifyThreshold = .eg3
    
    init(){
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            let _ = print("[Init] isFirstLaunch is currently \(isFirstLaunch)")
            if isFirstLaunch {
                FirstLaunchView(onDismiss: {
                    withAnimation {
                        isFirstLaunch = false
                    }
                })
            } else {
                TabView {
                    AlertView(eventManager: EventDispatcher(subscribedLoc: $subscribedLoc), subscribedLoc: $subscribedLoc)
                        .environmentObject(sheetManager)
                        .tabItem {
                            Label("Alert", systemImage: "exclamationmark.triangle")    // TODO: localization
                        }
                    HistoryView(eventManager: EventDispatcher(subscribedLoc: $subscribedLoc), historyRange: $historyRange, subscribedLoc: $subscribedLoc)
                        .tabItem {
                            Label("History", systemImage: "chart.bar.doc.horizontal")
                        }
                    SettingsView(
                        onHistoryRangeChanged: { newValue in
                            historyRange = newValue
                        }, onSubscribedLocChanged: { newValue in
                            subscribedLoc = newValue
                        }, onNotifyThresholdChanged: { newValue in
                            notifyThreshold = newValue
                            FCMManager.setNotifyMode(threshold: notifyThreshold)
                        })
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                }
            }
        }
    }
    
    
}

// MARK: Notification Handling
// MARK: https://www.youtube.com/watch?v=TGOF8MqcAzY&ab_channel=DesignCode
// MARK: https://designcode.io/swiftui-advanced-handbook-push-notifications-part-2


class FCMManager {
    static func setNotifyMode(threshold: NotifyThreshold) {
        
        NotifyThreshold.allCases.forEach { topic in
            if topic != .eg4 {
                Messaging.messaging().unsubscribe(fromTopic: topic.getTopicKey()) { error in
                    print("[FCM] Unsubscribed to [\(topic.getTopicKey())] topic")
                }
            }
        }
        
        switch threshold {
        case .eg0:
            Messaging.messaging().subscribe(toTopic: NotifyThreshold.eg0.getTopicKey()) { error in
                print("[FCM] Subscribed to [eg0] topic")
            }
            fallthrough
        case .eg1:
            Messaging.messaging().subscribe(toTopic: NotifyThreshold.eg1.getTopicKey()) { error in
                print("[FCM] Subscribed to [eg1] topic")
            }
            fallthrough
        case .eg2:
            Messaging.messaging().subscribe(toTopic: NotifyThreshold.eg2.getTopicKey()) { error in
                print("[FCM] Subscribed to [eg2] topic")
            }
            fallthrough
        case .eg3:
            Messaging.messaging().subscribe(toTopic: NotifyThreshold.eg3.getTopicKey()) { error in
                print("[FCM] Subscribed to [eg3] topic")
            }
            fallthrough
        case .eg4:
            Messaging.messaging().subscribe(toTopic: NotifyThreshold.eg4.getTopicKey()) { error in
                print("[FCM] Subscribed to [eg4] topic")
            }
        case .test:
            Messaging.messaging().subscribe(toTopic: NotifyThreshold.test.getTopicKey()) { error in
                print("[FCM] Subscribed to [test] topic")
            }
        }
    }
}
