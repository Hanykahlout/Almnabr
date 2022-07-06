//
//  HomeVC.swift
//  Almnabr
//
//  Created by MacBook on 24/09/2021.
//  Copyright © 2021 Samar Akkila. All rights reserved.
//

import UIKit
import DPLocalization
import WebKit
import PassKit
import CoreNFC
import SocketIO

var userObj :UserObj?
var arr_Menu : [MenuObj]?

class HomeVC: UIViewController   {
    
    @IBOutlet weak var viewTheme: UIView!
    @IBOutlet weak var btnMenu: UIView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var header: HeaderView!
    @IBOutlet weak var tf_message: UITextField!
    @IBOutlet weak var lbl_allCopyRes: UILabel!
    
    var session: NFCNDEFReaderSession?
    var message:String = ""
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        get_Userdata()
        header.btnAction = menu_select
        check_notifi()
        
        self.lbl_allCopyRes.font = .kufiRegularFont(ofSize: 12)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    func get_Userdata(){
        //self.showLoadingActivity()
        
        APIManager.sendRequestGetAuth(urlString: "user?user_id=\(Auth_User.user_id)" ) { (response) in
            self.hideLoadingActivity()
            
            let status = response["status"] as? Bool
            if status == true{
                if  let records = response["result"] as? NSArray{
                    
                    for i in records {
                        let dict = i as? [String:Any]
                        let obj = UserObj.init(dict!)
                        userObj = obj
                    }
                }
            }
        }
    }
    
    
    func menu_select(){
        let language =  L102Language.currentAppleLanguage()
        print("HHHHHI",language)
        if language == "ar"{
            panel?.openRight(animated: true)
        }else{
            panel?.openLeft(animated: true)
        }
        
    }
    
    func Notification_select(){
        let vc:NotificationVC = AppDelegate.mainSB.instanceVC()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func buttonMenuAction(sender: UIButton!) {
        
        let language =  L102Language.currentAppleLanguage()
        if language == "ar"{
            panel?.openRight(animated: true)
        }else{
            panel?.openLeft(animated: true)
        }
    }
    
    
    
}
extension HomeVC {
    func check_notifi() {
        didLoadHome = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            NotifiRoute.shared.check_notifi()
        }
    }
}
