//
//  SceneDelegate.swift
//  Almnabr
//
//  Created by MacBook on 22/09/2021.
//

import UIKit
import FAPanels
import LocalAuthentication

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
        
        
        get_theme()
        HelperClassSwift.IsLoggedOut = false
        if NewSuccessModel.getLoginSuccessToken() != nil {
             CheckActiveTime()
              //NewSuccessModel.removeLoginSuccessToken()
        }else{
            GoToSignIn()
       
        }
    }
    
    func GoToHome(){
        
        let vc : HomeVC = AppDelegate.mainSB.instanceVC()
        let nav = UINavigationController.init(rootViewController: vc)
        let sideMenu: MenuVC = AppDelegate.mainSB.instanceVC()
        let rootController : FAPanelController = AppDelegate.mainSB.instanceVC()
        let center : MenuVC = AppDelegate.mainSB.instanceVC()
        
        _ = rootController.center(nav).right(center).left(sideMenu)
        rootController.rightPanelPosition = .front
        rootController.leftPanelPosition = .front

        // rootController.configs.rightPanelWidth = (window?.frame.size.width)!
        let width = UIScreen.main.bounds.width - 80
        
        
        rootController.configs.leftPanelWidth = width
        rootController.configs.rightPanelWidth = width
       
        rootController.configs.maxAnimDuration = 0.3
        rootController.configs.canRightSwipe = false
        rootController.configs.canLeftSwipe = false
        rootController.configs.changeCenterPanelAnimated = false
        window?.rootViewController = rootController
        UIView.transition(with: window!, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
        
        
        
    }
    
    func GoToSignIn(){
       // guard let window = UIApplication.shared.keyWindow else {return}
       
        let vc : SignInVC = AppDelegate.mainSB.instanceVC()
        let rootNC = UINavigationController(rootViewController: vc)
        window?.rootViewController = rootNC
        window?.makeKeyAndVisible()
        UIView.transition(with: window!, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
    
    func CheckActiveTime(){
        
        guard let lastOpened = UserDefaults.standard.object(forKey: "LastOpened") as? Date else {
            GoToHome()
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
                            GoToHome()
                            //self.login(Username: HelperClassSwift.UserName , Password: HelperClassSwift.UserPassword )
                        }}else{
                            DispatchQueue.main.async { [unowned self] in
                                self.GoToSignIn()
                                print("nil")
                            }
                            
                        }
                    
                }
            }else{
                print("can not use ")
               // Auth_User.topVC()!.showAMessage(withTitle: "Unavailabel", message: "You Can't use This Feature")
            }
        }else{
            GoToHome()
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

