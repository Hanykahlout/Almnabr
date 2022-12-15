//
//  GmailViewController.swift
//  Almnabr
//
//  Created by Hany Alkahlout on 25/10/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import UIKit
import SideMenu
import FAPanels
class GmailViewController: UIViewController {

    @IBOutlet weak var mainView: UIViewCustomCornerRadius!
    
    private var pageController:MailPageViewController!
    var isFromLocalNotification = false
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
        // Do any additional setup after loading the view.
    }
    
    
    
    private func initlization(){
        setUpPageViewController()
    }
  
    
    private func setUpPageViewController(){
        pageController = storyboard?.instantiateViewController(withIdentifier: "MailPageViewController") as? MailPageViewController
        
        addChild(pageController)
        pageController.didMove(toParent: self)
        
        pageController.view.translatesAutoresizingMaskIntoConstraints = false
        
        mainView.addSubview(pageController.view)

        mainView.leadingAnchor.constraint(equalTo: pageController.view.leadingAnchor, constant: 0).isActive = true
        mainView.trailingAnchor.constraint(equalTo: pageController.view.trailingAnchor, constant: 0).isActive = true
        mainView.topAnchor.constraint(equalTo: pageController.view.topAnchor, constant: 0).isActive = true
        mainView.bottomAnchor.constraint(equalTo: pageController.view.bottomAnchor, constant: 0).isActive = true
    }
    
    
    @IBAction func sideMenuAction(_ sender: Any) {
        let nav = storyboard?.instantiateViewController(withIdentifier: "SideMenuNav") as! SideMenuNavigationController
        if let vc = nav.topViewController as? SideMenuViewController{
            vc.inboxAction = {
                self.pageController.changeVC(index: 0, direction: .forward)
            }
            
            vc.starredAction = {
                self.pageController.changeVC(index: 1, direction: .forward)
            }
            
            vc.draftsAction = {
                self.pageController.changeVC(index: 2, direction: .forward)
            }
            
            vc.sentAction = {
                self.pageController.changeVC(index: 3, direction: .forward)
            }
            
            vc.spamAction = {
                self.pageController.changeVC(index: 4, direction: .forward)
            }
            
            vc.trashAction = {
                self.pageController.changeVC(index: 5, direction: .forward)
            }
            
            vc.logoutAction = {
                if !self.isFromLocalNotification {
                    self.navigationController?.dismiss(animated: true)
                    
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

                    AppInstance.window?.rootViewController = rootController
                    UIView.transition(with: AppInstance.window!, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
                }
                
            }
            
        }
        
        var presentationStyle = SideMenuPresentationStyle()
        presentationStyle = .menuSlideIn
        presentationStyle.backgroundColor = .clear
        presentationStyle.onTopShadowOpacity = 0.5
        presentationStyle.onTopShadowRadius = 10
        presentationStyle.onTopShadowColor = .black
        
        nav.presentationStyle = presentationStyle
        nav.menuWidth = (3 * UIScreen.main.bounds.width) / 4
        nav.leftSide = L102Language.currentAppleLanguage() == "en"
        nav.isNavigationBarHidden = true
        present(nav, animated: true)
    }
    
    
}
