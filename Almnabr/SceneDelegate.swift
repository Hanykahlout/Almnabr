//
//  SceneDelegate.swift
//  Almnabr
//
//  Created by MacBook on 22/09/2021.
//

import UIKit
import FAPanels
import LocalAuthentication
import IQKeyboardManagerSwift


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
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
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let _ = (scene as? UIWindowScene) else { return }
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate{
            delegate.window = self.window
        }
        
        HelperClassSwift.IsLoggedOut = false
        
        maybeOpenedFromWidget(urlContexts: connectionOptions.urlContexts)
        //NewSuccessModel.removeLoginSuccessToken()
       
        
    }
    
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        maybeOpenedFromWidget(urlContexts: URLContexts)
    }
    
    private func maybeOpenedFromWidget(urlContexts: Set<UIOpenURLContext>) {
        IQKeyboardManager.shared.enable = true
        if NewSuccessModel.getLoginSuccessToken() != nil {
            if let _: UIOpenURLContext = urlContexts.first(where: { $0.url.scheme == "widget-deeplink" }) {
                GoToHome(isFromWidget: true)
            } else {
                CheckActiveTime()
            }
        }else{
            GoToSignIn()
        }
    }
    
    
    func GoToHome(isFromWidget:Bool){
       
        if isFromWidget{
            
            let qrScannerVC = QRScannerViewController()
            qrScannerVC.isFromWidget = true
            let nav = UINavigationController.init(rootViewController: qrScannerVC)
            window?.rootViewController = nav
            UIView.transition(with: window!, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)

        }else{
            let vc = AppDelegate.mainSB.instantiateViewController(withIdentifier: "HomeVC")
            
            let nav = UINavigationController.init(rootViewController: vc)
            let sideMenu: MenuVC = AppDelegate.mainSB.instanceVC()
            let rootController : FAPanelController = AppDelegate.mainSB.instanceVC()
            let center : MenuVC = AppDelegate.mainSB.instanceVC()
            
            _ = rootController.center(nav).right(center).left(sideMenu)
            rootController.rightPanelPosition = .front
            rootController.leftPanelPosition = .front
            
            // rootController.configs.rightPanelWidth = (window?.frame.size.width)!
            let width = UIScreen.main.bounds.width - 150
            
            
            rootController.configs.leftPanelWidth = width
            rootController.configs.rightPanelWidth = width
            
            rootController.configs.maxAnimDuration = 0.3
            rootController.configs.canRightSwipe = true
            rootController.configs.canLeftSwipe = true
            rootController.configs.changeCenterPanelAnimated = false
            window?.rootViewController = rootController
            UIView.transition(with: window!, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
        
        checkUpdate()

    }
    
    private func checkUpdate(){
        DispatchQueue.global().async {
            do {
                let update = try self.isUpdateAvailable()
                DispatchQueue.main.sync {
                    if update {
                        self.showUpdateAlert()
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    
    private func showUpdateAlert(){
        let alertVC = UIAlertController(title: "Update", message: "There is an update in the App Store", preferredStyle: .alert)
        alertVC.addAction(.init(title: "Cancel", style: .default))
        alertVC.addAction(.init(title: "Update Now", style: .default,handler: { action in
            if let url = URL(string: "https://apps.apple.com/us/app/almnabr/id1621889347") {
                UIApplication.shared.open(url)
            }
        }))
        
        window?.rootViewController?.present(alertVC, animated: true)
    }
    
    
    
    func GoToSignIn(){
        // guard let window = UIApplication.shared.keyWindow else {return}
        
        let vc : SignInVC = AppDelegate.mainSB.instanceVC()
        let rootNC = UINavigationController(rootViewController: vc)
        window?.rootViewController = rootNC
        window?.makeKeyAndVisible()
        UIView.transition(with: window!, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
        checkUpdate()
    }
    
    func CheckActiveTime(){
        
        guard let lastOpened = UserDefaults.standard.object(forKey: "LastOpened") as? Date else {
            GoToHome(isFromWidget: false)
            return
        }
        let elapsed = Calendar.current.dateComponents([.minute], from: lastOpened, to: Date())
        print(elapsed)
        
        if elapsed.minute! > 30 {
            let context = LAContext()
            var error: NSError? = nil
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
                let reason = "Please authorize with touch id "
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason){ success, error in
                    if success {
                        
                        // Move to the main thread because a state update triggers UI changes.
                        DispatchQueue.main.async { [unowned self] in
                            print("success")
                            GoToHome(isFromWidget: false)
                            //self.login(Username: HelperClassSwift.UserName , Password: HelperClassSwift.UserPassword )
                        }}else{
                            DispatchQueue.main.async { [unowned self] in
                                self.GoToSignIn()
                                print("nil")
                            }
                        }
                }
            }else{
                GoToHome(isFromWidget: false)
                // Auth_User.topVC()!.showAMessage(withTitle: "Unavailabel", message: "You Can't use This Feature")
            }
        }else{
            GoToHome(isFromWidget: false)
        }
    }
    
    
    func sceneDidDisconnect(_ scene: UIScene) {
        UserDefaults.standard.set(Date(), forKey: "LastOpened")
        
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        
        UserDefaults.standard.set(Date(), forKey: "LastOpened")
        guard let lastOpened = UserDefaults.standard.object(forKey: "LastOpened") as? Date else {
            return
        }
        let elapsed = Calendar.current.dateComponents([.minute], from: lastOpened, to: Date())
        print(elapsed)
        HelperClassSwift.IsLoadTheme = false
        
        SocketIOController.shard.disconnect()
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        UserDefaults.standard.set(Date(), forKey: "LastOpened")
    }
    
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        guard let lastOpened = UserDefaults.standard.object(forKey: "LastOpened") as? Date else {
            return
        }
        let elapsed = Calendar.current.dateComponents([.hour], from: lastOpened, to: Date())
        print(elapsed)
        HelperClassSwift.IsLoadTheme = false
        
        //        if Int(elapsed) > 1 {
        //            // show alert
        //        }
    }
    
    
}

// MARK: - Check App Update From App Store
extension SceneDelegate{
    func isUpdateAvailable() throws -> Bool {
        guard let info = Bundle.main.infoDictionary,
            let currentVersion = info["CFBundleShortVersionString"] as? String,
            let identifier = info["CFBundleIdentifier"] as? String,
            let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(identifier)") else {
            throw VersionError.invalidBundleInfo
        }
        let data = try Data(contentsOf: url)
        guard let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] else {
            throw VersionError.invalidResponse
        }
        if let result = (json["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String {
            return version != currentVersion
        }
        throw VersionError.invalidResponse
    }
}


enum VersionError: Error {
    case invalidResponse, invalidBundleInfo
}
