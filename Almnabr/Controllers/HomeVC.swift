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
import MOLH
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
    
    private var manager = SocketManager(socketURL: URL(string:"https://node.almnabr.com/")!)
   // var socket  = io.connect('https://node.almnabr.com', {secure: true, auth: {token: "توكن اليوزر هنا"}});
//    Node.NAHIDH.Sa
    //"https://node.almnabr.com/"
    private var socket: SocketIOClient!

    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        get_Userdata()
        header.btnAction = menu_select
        check_notifi()
        
     
        self.lbl_allCopyRes.font = .kufiRegularFont(ofSize: 12)
        
        let token =  "\(NewSuccessModel.getLoginSuccessToken() ?? "nil")"
        print("XXX-TOKEN",token)
        self.manager.config = SocketIOClientConfiguration(
            arrayLiteral: .connectParams(["Authorization": "test"]),.secure(false) )
       
        let dict =  [ "token" : token]
         manager.defaultSocket.connect(withPayload: dict)

        let socket = self.manager.defaultSocket

        self.manager.connectSocket(socket, withPayload:dict)

        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }

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
        }}

    
    func menu_select(){
        let language =  MOLHLanguage.currentAppleLanguage()
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
       
        let language =  MOLHLanguage.currentAppleLanguage()
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
