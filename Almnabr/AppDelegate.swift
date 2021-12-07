//
//  AppDelegate.swift
//  Almnabr
//
//  Created by MacBook on 22/09/2021.
//

import UIKit
import IQKeyboardManagerSwift
import FAPanels
import DPLocalization
import FirebaseMessaging
import Messages
import UserNotifications
import FirebaseCore
import Firebase
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate , UNUserNotificationCenterDelegate {

    var window: UIWindow?

    static let mainSB = UIStoryboard(name: "Main", bundle: nil)
    static let TransactionSB = UIStoryboard(name: "Transaction", bundle: nil)
    let gcmMessageIDKey = "gcm.message_id"
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        get_theme()
        //Here we will hide back button title and change arrow to white color
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .highlighted)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000.0, vertical: 0.0), for: .default)
       
        UINavigationBar.appearance().tintColor = .white
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().tintColor = .white
        
     
        
        if let lang = HelperClassSwift.getUserInformation(key: Constants.kAppLanguageSelect) {
            if lang == "ar" {
                dp_set_current_language("ar")

                UIView.appearance().semanticContentAttribute = .forceRightToLeft
                UISlider.appearance().semanticContentAttribute = .forceLeftToRight
                changeLanguage(lang: "ar")
            } else {
                dp_set_current_language("en")

                UIView.appearance().semanticContentAttribute = .forceLeftToRight
                UISlider.appearance().semanticContentAttribute = .forceLeftToRight
                changeLanguage(lang: "en")
            }
        } else {
            dp_set_current_language("ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            UISlider.appearance().semanticContentAttribute = .forceLeftToRight
            changeLanguage(lang: "ar")
        }

        
        
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

        Messaging.messaging().delegate = self

        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")

        
        
        //Added Code to display notification when app is in Foreground
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        } else {
            // Fallback on earlier versions
        }
        


        return true
    }


    func changeLanguage(lang: String) {
        UserDefaults.standard.set([lang], forKey: "AppleLanguages")
        //UserDefaults.standard.synchronize()
    }
    
    
    
    func get_theme(){
        
        APIManager.sendRequestGetAuthTheme(urlString: "gettheme" ) { (response) in
           
            let status = response["status"] as? Bool
            if status == true{
                if  let data = response["data"] as? [String:Any]{
                  let obj = themeObj(data)
                    HelperClassSwift.acolor = obj.acolor
                    HelperClassSwift.bcolor = obj.bcolor
                }
            }else{
                HelperClassSwift.acolor = "#1992bc"
                HelperClassSwift.bcolor = "#000000"
            }
            
            
        }
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
       
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
             withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
             let userInfo = notification.request.content.userInfo

             // Print message ID.
             if let messageID = userInfo[gcmMessageIDKey] {
               print("Message ID: \(messageID)")
             }

             // Print full message.
             print(userInfo)

             // Change this to your preferred presentation option
             completionHandler([.alert , .sound , .badge])
           }

           func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
             let userInfo = response.notification.request.content.userInfo
             // Print message ID.
             if let messageID = userInfo[gcmMessageIDKey] {
               print("Message ID: \(messageID)")
             }

             // Print full message.
             print(userInfo)

            
             completionHandler()
           }
    func application(_ application: UIApplication,
                        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
           
           // Messaging.messaging().setAPNSToken(deviceToken, type: .sandbox)//.prod)
           Messaging.messaging().apnsToken = deviceToken
           if Messaging.messaging().fcmToken != nil {
           }
       }
    
    func applicationWillResignActive(_ application: UIApplication) {
    
        application.applicationIconBadgeNumber = 0
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {

        application.applicationIconBadgeNumber = 0
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
    
    


}



extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
   print("Firebase registration token: \(fcmToken)")

      
  // let dataDict:[String: String] = ["token": fcmToken]
        Auth_User.FCMtoken = fcmToken!
   
   // TODO: If necessary send token to application server.
   // Note: This callback is fired at each app startup and whenever a new token is generated.
    }}

