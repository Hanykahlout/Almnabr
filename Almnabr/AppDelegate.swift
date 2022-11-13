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
import AVFAudio
import GoogleSignIn
var AppInstance: AppDelegate!

@main
class AppDelegate: UIResponder, UIApplicationDelegate , UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    static let mainSB = UIStoryboard(name: "Main", bundle: nil)
    static let TransactionSB = UIStoryboard(name: "Transaction", bundle: nil)
    static let HRSB = UIStoryboard(name: "HR", bundle: nil)
    static let TicketSB = UIStoryboard(name: "Ticket", bundle: nil)
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
//        UIApplication.shared.statusBarStyle = .darkContent
        L102Localizer.DoTheMagic()
        AppInstance = self
        IQKeyboardManager.shared.enable = true

        FirebaseApp.configure()
        get_theme()

        //UIApplication.shared.applicationIconBadgeNumber = 0
        //hideLoader()

        //Here we will hide back button title and change arrow to white color
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .highlighted)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000.0, vertical: 0.0), for: .default)

        UINavigationBar.appearance().tintColor = .white
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().tintColor = .white

        // let notificationContent = UNMutableNotificationContent()
        // notificationContent.sound = UNNotificationSound(named: "notification3.wav")
        //notificationContent.sound = .default
        //UNNotificationSound(named: "notification3.wav")
        //  notification.sound = UNNotificationSound(named: "notification3.wav")
        application.registerForRemoteNotifications()


        Messaging.messaging().delegate = self

        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")

        setupFirebaseMessaging(application)

//        registerForPushNotifications()
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
              // Show the app's signed-out state.
            } else {
              // Show the app's signed-in state.
            }
          }

        return true
    }
    
    
    
    func setupFirebaseMessaging(_ application: UIApplication) {
        
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
    }
    
    
    
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
        }
        
        // guard settings.authorizationStatus == .authorized else { return }
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
        
        
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
    
    func application(
      _ app: UIApplication,
      open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
      var handled: Bool

      handled = GIDSignIn.sharedInstance.handle(url)
      if handled {
        return true
      }

      // Handle other custom URL types.

      // If not handled by this app, return false.
      return false
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
        
        // Print full message.
        print(userInfo)
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        if let window = window{
            if let ios = userInfo["ios"] as? String {
                if ios != "" {
                    if let typeUrl = userInfo["urlType"] as? String,typeUrl == "pdf"{
                        APIController.shard.getImage(url: ios) { data in
                            DispatchQueue.main.async {
                                if let status = data.status,status{
                                    let vc = WebViewViewController()
                                    vc.data = data
                                    window.rootViewController = UINavigationController(rootViewController: vc)
                                }
                            }
                        }
                    }else{
                        if ios.contains("transactions") {
                            let requestArr = ios.components(separatedBy: "/")
                            if ios.contains("FORM_HRV1"){
                                // Vaction Form
                                if let last = requestArr.last {
                                    let vc = VactionViewController()
                                    vc.transaction_request_id = last
                                    window.rootViewController = UINavigationController(rootViewController: vc)
                                }
                            }else if ios.contains("FORM_WIR"){
                                // WIR Form
                                let splitString = ios.components(separatedBy: "ios/transactions")
                                let vc: TransactionFormDetailsVC = AppDelegate.TransactionSB.instanceVC()
                                vc.str_url = "\(splitString[1])"
                                vc.IsFromNotification = true
                                window.rootViewController = UINavigationController(rootViewController: vc)
                            }else if ios.contains("FORM_CT1"){
                                // New Contract Form
                                if let last = requestArr.last{
                                    let vc = NewContractVC()
                                    vc.transaction_request_id = last
                                    window.rootViewController = UINavigationController(rootViewController: vc)
                                }
                            }
                            
                        }else if  ios.contains("task") {
                            let vc:TaskDetailVC = AppDelegate.TicketSB.instanceVC()
                            vc.task_id =  String(ios.split(separator: "/").last ?? "")
                            window.rootViewController = UINavigationController(rootViewController: vc)
                        }
                    }
                }
            }else{
                let vc:GmailViewController = AppDelegate.mainSB.instanceVC()
                window.rootViewController = UINavigationController(rootViewController: vc)
            }
        }
        
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
    }
    
}

