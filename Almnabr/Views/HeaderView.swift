//
//  HeaderView.swift
//  Almnabr
//
//  Created by MacBook on 08/10/2021.
//  Copyright © 2021 Samar Akkila. All rights reserved.
//

import Foundation
import UIKit
import DPLocalization

class HeaderView:  UIView {
    
    @IBOutlet weak var viewTheme: UIView!
    @IBOutlet weak var btnMenu: UIView!
    @IBOutlet weak var btnNotify: UIView!
    
    var btnAction : (()->())?
    var btnNotifyAction : (()->())?
    
    var isLoad :Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        if HelperClassSwift.IsLoadTheme == false {
            get_theme()
        }else{
            self.addShape(acolor: HelperClassSwift.acolor, bcolor: HelperClassSwift.bcolor)
        }
        
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
        
        
        HelperClassSwift.IsLoadTheme = true
        let language = dp_get_current_language()
        
        
        if language == "ar"{
            self.btnMenu.isHidden = false
        }else{
            
            self.btnMenu.isHidden = true
            let button = UIButton(frame: CGRect(x: 15, y: 44, width: 25, height: 25))
            button.setImage(UIImage(named: "menu"), for: .normal)
            button.addTarget(self, action: #selector(buttonMenuAction), for: .touchUpInside)
            self.viewTheme.addSubview(button)
            
            let width =  UIScreen.main.bounds.size.width - 40
            
            let notify_button = UIButton(frame: CGRect(x:  width, y: 44, width: 25, height: 25))
            notify_button.setImage(UIImage(named: "notification"), for: .normal)
            
            
            notify_button.addTarget(self, action: #selector(buttonNotificationAction), for: .touchUpInside)
            self.viewTheme.addSubview(notify_button)
        }
        
        
    }
    
    
    func get_theme(){
        APIManager.sendRequestGetAuthTheme(urlString: "gettheme" ) { (response) in
            
            let status = response["status"] as? Bool
            if status == true{
                if  let data = response["data"] as? [String:Any]{
                    let obj = themeObj(data)
                    HelperClassSwift.acolor = obj.acolor
                    HelperClassSwift.bcolor = obj.bcolor
                    HelperClassSwift.IsLoadTheme = true
                    self.addShape(acolor: obj.acolor, bcolor: obj.bcolor)
                    
                }
            }else{
                self.addShape(acolor: "#1992bc", bcolor: "#000000")
                
            }
            
        }
    }
    
    
    @objc func buttonMenuAction(sender: UIButton!) {
        
        btnAction?()
    }
    
    @objc func buttonNotificationAction(sender: UIButton!) {
        
        btnNotifyAction?()
    }
    
    
    @IBAction func btnMenu_Click(_ sender: Any) {
        
        btnAction?()
        
    }
    
    @IBAction func btnNotification_Click(_ sender: Any) {
        
        btnNotifyAction?()
        
    }
    
}
