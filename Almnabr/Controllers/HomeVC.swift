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

var userObj :UserObj?
var arr_Menu : [MenuObj]?

class HomeVC: UIViewController {

    @IBOutlet weak var viewTheme: UIView!
    @IBOutlet weak var btnMenu: UIView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var header: HeaderView!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        get_Userdata()
        self.header.get_theme()
        header.btnAction = menu_select
        header.btnNotifyAction = Notification_select
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
 
    func addShape(acolor:String,bcolor:String){
        
        //add a shape
        let shape = CAShapeLayer()
        self.viewTheme.layer.addSublayer(shape)
        shape.strokeColor = UIColor.clear.cgColor
        shape.fillColor = acolor.getUIColor().cgColor
        self.viewTheme.backgroundColor =  bcolor.getUIColor()
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: viewTheme.bounds.width/2, y: 0))
        path.addLine(to: CGPoint(x: viewTheme.bounds.width/2 - 20 , y: viewTheme.bounds.height))
        path.addLine(to: CGPoint(x: 0, y: self.viewTheme.bounds.height))
        path.close()
        shape.path = path.cgPath
        
        let language = dp_get_current_language()
        if language == "ar"{
            self.btnMenu.isHidden = false
        }else{
            self.btnMenu.isHidden = true
            let button = UIButton(frame: CGRect(x: 15, y: 44, width: 25, height: 25))
            button.setImage(UIImage(named: "menu"), for: .normal)
            button.addTarget(self, action: #selector(buttonMenuAction), for: .touchUpInside)
            self.viewTheme.addSubview(button)
        }
      
    
    }
    
    
    func get_theme(){
        self.addShape(acolor: HelperClassSwift.acolor, bcolor: HelperClassSwift.bcolor)
        self.showLoadingActivity()
        APIManager.sendRequestGetAuthTheme(urlString: "gettheme" ) { (response) in
           
            let status = response["status"] as? Bool
            if status == true{
                if  let data = response["data"] as? [String:Any]{
                  let obj = themeObj(data)
                    HelperClassSwift.acolor = obj.acolor
                    HelperClassSwift.bcolor = obj.bcolor
                    self.addShape(acolor: obj.acolor, bcolor: obj.bcolor)
                }
            }else{
                HelperClassSwift.acolor = "#1992bc"
                HelperClassSwift.bcolor = "#000000"
                self.addShape(acolor: "#1992bc", bcolor: "#000000")
                
            }
            self.hideLoadingActivity()
            
        }
    }
    
    func get_Userdata(){
        self.showLoadingActivity()
        
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
        let language = dp_get_current_language()
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
        let language = dp_get_current_language()
        if language == "ar"{
            panel?.openRight(animated: true)
        }else{
            panel?.openLeft(animated: true)
        }
    }
    
    @IBAction func btnMenu_Click(_ sender: Any) {
        let language = dp_get_current_language()
        if language == "ar"{
            panel?.openRight(animated: true)
        }else{
            panel?.openLeft(animated: true)
        }
  
    }
    
    @IBAction func btn_Click(_ sender: Any) {
    let vc:TransactionsVC = AppDelegate.mainSB.instanceVC()
    vc.title =  "test"
    self.navigationController?.pushViewController(vc, animated: true)

    }
}


