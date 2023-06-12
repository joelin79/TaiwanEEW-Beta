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


@main
struct TaiwanEEWApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    // selection variables accessable between views
    @AppStorage("historyRange") var historyRange: TimeRange = .year
    @AppStorage("subscribedLoc") var subscribedLoc: Location = .taipei
    @StateObject var sheetManager = SheetManager()
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true

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
}

// MARK: https://www.youtube.com/watch?v=TGOF8MqcAzY&ab_channel=DesignCode
// MARK: https://designcode.io/swiftui-advanced-handbook-push-notifications-part-2



class AppDelegate: NSObject, UIApplicationDelegate {
    let gcmMessageIDKey = "gcm.message_id"

/// Called when a remote notification is received while the app is running or in the background. The `userInfo` parameter contains the payload of the notification. In the provided code, the method prints the message ID and the content of the notification payload.
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()

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
    
/// Called when a notification is received while the app is in the foreground. It provides the option to customize the presentation of the notification. In the provided code, the method prints the message ID and the content of the notification payload and specifies the presentation options for the notification (banner, badge, sound).

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      print(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }
}





extension AppDelegate: MessagingDelegate {
    
/// Called when the app receives a registration token from Firebase Cloud Messaging (FCM). The registration token is a unique identifier for the app installation, and it can be used to send notifications to the specific device. In the provided code, the method receives the registration token (`fcmToken`) and prints it.

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      let deviceToken:[String: String] = ["token": fcmToken ?? ""]
        print("Device token: ", deviceToken) // This token can be used for testing notifications on FCM
    }
}





@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
///  Called when a notification is about to be presented to the user while the app is in the foreground. It provides an opportunity to customize the presentation options for the notification. In the provided code, the method prints the message ID and the content of the notification payload and specifies the presentation options for the notification

  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo

    if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
    }

    print(userInfo)

    // Change this to your preferred presentation option
    completionHandler([[.banner, .badge, .sound]])
  }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {

    }

    
/// Called when a user interacts with a notification, such as tapping on it. In the provided code, the method prints the message ID and the content of the notification payload.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo

    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID from userNotificationCenter didReceive: \(messageID)")
    }

    print(userInfo)

    completionHandler()
  }
    
}
