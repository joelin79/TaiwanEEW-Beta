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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
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

class AppDelegate: NSObject, UIApplicationDelegate {
    @AppStorage("notifyThreshold") var notifyThreshold: NotifyThreshold = .eg3 // (duplicate)
    func seperate(){ print(); print("  -------- incoming notification --------")}
    let gcmMessageIDKey = "gcm.message_id"
    
    // Called when a remote notification is received while the app is running or in the background
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FCMManager.setNotifyMode(threshold: notifyThreshold)
        
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self
            
          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID and full message
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        if !userInfo.isEmpty {
            print("userInfo: \(userInfo) m1")
        }
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
}




extension AppDelegate: MessagingDelegate {
    
    // Called when the app receives a registration token from Firebase Cloud Messaging (FCM)
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      let deviceToken:[String: String] = ["token": fcmToken ?? ""]
        print("Device token: ", deviceToken) // This token can be used for testing notifications on FCM
    }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Called when a notification is about to be presented to the user while the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
          
        // TODO: Use sound modification here
        
        // Print message ID and full message.
        if let messageID = userInfo[gcmMessageIDKey] {
            seperate()
            print("Message ID: \(messageID)")
        }
        if !userInfo.isEmpty {
            print("userInfo: \(userInfo) m2")
            print("  ----------------- end -----------------"); print()
        }

        // Call the completion handler with options you want choosing type of notification
        completionHandler([.banner, .badge, .sound])
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    }

    // Called when a user interacts with a notification, such as tapping on it
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
      
        let userInfo = response.notification.request.content.userInfo
        
        // Print message ID and full message.
        if let messageID = userInfo[gcmMessageIDKey] {
          print("Message ID from userNotificationCenter didReceive: \(messageID)")
        }
        print("userInfo: \(userInfo) m3")

        completionHandler()
  }
    
}

class FCMManager {
    static func setNotifyMode(threshold: NotifyThreshold) {
        
        NotifyThreshold.allCases.forEach { topic in
            Messaging.messaging().unsubscribe(fromTopic: topic.getTopicKey()) { error in
                print("[FCM] Unsubscribed to [\(topic.getTopicKey())] topic")
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
