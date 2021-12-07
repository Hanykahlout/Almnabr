//
//  MenVC.swift
//  Almnabr
//
//  Created by MacBook on 24/09/2021.
//  Copyright © 2021 Samar Akkila. All rights reserved.
//

import UIKit
import FontAwesome_swift

class MenuVC: UIViewController {
    
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var btnMobile: UIButton!
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var viewTheme: UIView!
    
    private var arr_data : [MenuObj] = []
    
    var selectedIndexPath: IndexPath?
    let fontStyle: FontAwesomeStyle = .solid
    var menu_id:String?
    var submenuObj:MenuObj?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        get_data()
        setup_data()
        if userObj == nil {
            get_Userdata()
        }
        
    }
    
    
    
    
    func setup_data(){
        
        
        tableview.estimatedRowHeight = 44.0
        tableview.rowHeight = UITableView.automaticDimension
        
        
        imgUserProfile.setRounded()
        imgUserProfile.layer.borderColor = HelperClassSwift.bcolor.getUIColor().cgColor
        imgUserProfile.layer.borderWidth = 1
        imgUserProfile.layer.cornerRadius = 40.0
        
        self.lblUserName.font = .kufiRegularFont(ofSize: 15)
        self.btnEmail.titleLabel?.font = .kufiRegularFont(ofSize: 15)
        self.btnMobile.titleLabel?.font = .kufiRegularFont(ofSize: 15)
        
        
        let obj = userObj
        self.lblUserName.text = obj?.user_username
        self.btnEmail.setTitle(obj?.user_email, for: .normal)
        self.btnMobile.setTitle(obj?.user_phone, for: .normal)
        
        
        let image =  UIImage.fontAwesomeIcon(name: .cog, style: self.fontStyle, textColor: HelperClassSwift.bcolor.getUIColor(), size: CGSize(width: 40, height: 40))
        self.btnSetting.setImage(image, for: .normal)
        
        
        let userimage =  UIImage.fontAwesomeIcon(name: .userCircle, style: self.fontStyle, textColor: HelperClassSwift.bcolor.getUIColor(), size: CGSize(width: 40, height: 40))
        self.btnProfile.setImage(userimage, for: .normal)
        
        let logoutimage =  UIImage.fontAwesomeIcon(name: .signOutAlt, style: self.fontStyle, textColor: HelperClassSwift.bcolor.getUIColor(), size: CGSize(width: 40, height: 40))
        self.btnLogout.setImage(logoutimage, for: .normal)
        
        
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
                        self.lblUserName.text = obj.user_username
                        self.btnEmail.setTitle(obj.user_email, for: .normal)
                        self.btnMobile.setTitle(obj.user_phone, for: .normal)
                        
                    }
                    
                    self.tableview.reloadData()
                }
            }
        }}
    

    func get_data(){
        
        self.showLoadingActivity()
         APIManager.sendRequestGetAuth(urlString: "menu" ) { (response) in
             
             
             let status = response["status"] as? Bool
             if status == true{
                 if  let records = response["records"] as? NSArray{
                     for i in records {
                         let dict = i as? [String:Any]
                         let obj = MenuObj.init(dict!)
                         self.arr_data.append(obj)
                         
                     }
                     self.tableview.reloadData()
                     self.hideLoadingActivity()
                 }
             }
             
             
         }
     }
    
    
    
    
    
    func userLogoutAlert() {
        let logoutAlert = UIAlertController(title: "lbl_logout".localized(), message: "are_you_sure".localized(), preferredStyle: .alert)
        
        logoutAlert.addAction(UIAlertAction(title: "btn_yes".localized(), style: .default, handler: { (action: UIAlertAction!) in
            HelperClassSwift.acolor = "#1992bc"
            HelperClassSwift.bcolor = "#000000"
            
            
            print("Handle yes Logic here")
            self.showLoadingActivity()
            self.makeUserLogout()
            HelperClassSwift.IsLoggedOut = true
           
            
        }))
        logoutAlert.addAction(UIAlertAction(title: "btn_no".localized(), style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle no Logic here")
        }))
        present(logoutAlert, animated: true, completion: nil)
    }
    
    
    
    @IBAction func didTapSignOut(_ sender: AnyObject) {
     
        userLogoutAlert()
    }
    
}
extension MenuVC : UITableViewDataSource  , UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arr_data.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        let section = arr_data[section]
        if section.IsOpened{
            return section.menu.count + 1
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MenuCell
        let obj = arr_data[indexPath.section]
        if indexPath.row == 0 {
            
            cell.icon_dropdown.isHidden = true
            cell.lbl_title.text = obj.menu_name
            cell.lbl_title.textColor = "#8B9194".getUIColor()
            cell.lbl_title.font = .kufiBoldFont(ofSize: 15)
            if  obj.icon == "fa fa-product-hunt"{
                print("no icon")
                cell.icon.image = UIImage(named: "product-hunt-brands")
                cell.icon.tintColor = .gray
            } else if  obj.icon == "fa fa-delicious"{
                print("no icon")
                cell.icon.image = UIImage(named: "delicious-brands")
                cell.icon.tintColor = .gray
            }else{
                let str = obj.icon.dropFirst(3)
                cell.icon.image = UIImage.fontAwesomeIcon(code: String(str), style: self.fontStyle, textColor: .gray, size: CGSize(width: 40, height: 40))
             
            }
            if obj.menu.count > 0{
                cell.icon_dropdown.isHidden = false
                if obj.IsOpened {
                    cell.lbl_title.textColor = HelperClassSwift.bcolor.getUIColor()
                    cell.icon_dropdown.image = UIImage.fontAwesomeIcon(name: .chevronUp , style: self.fontStyle, textColor:  .gray, size: CGSize(width: 40, height: 40))
                }else{
                    cell.icon_dropdown.image = UIImage.fontAwesomeIcon(name: .chevronDown , style: self.fontStyle, textColor:  .gray, size: CGSize(width: 40, height: 40))
                }}
//            else{
//                cell.icon_dropdown.isHidden = true
//           }
          

            
        }else{
            let objj = arr_data[indexPath.section].menu[indexPath.row - 1]
            cell.lbl_title.text = arr_data[indexPath.section].menu[indexPath.row - 1].menu_name
            cell.lbl_title.textColor = "#8B9194".getUIColor()

            cell.lbl_title.font = .kufiRegularFont(ofSize: 15)
            let str = objj.icon.dropFirst(3)
            cell.icon.image = UIImage.fontAwesomeIcon(code: String(str), style: self.fontStyle, textColor: .gray, size: CGSize(width: 40, height: 40))
           
           // cell.icon_dropdown.isHidden = true

        }
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }

   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MenuCell


        let obj = arr_data[indexPath.section]
        obj.IsOpened = !obj.IsOpened
        
        if indexPath.row == 0 {
          // cell.icon_dropdown.image = UIImage.fontAwesomeIcon(name: .chevronUp , style: self.fontStyle, textColor:  .gray, size: CGSize(width: 40, height: 40))
            cell.lbl_title.textColor = HelperClassSwift.bcolor.getUIColor()
            tableview.reloadSections([indexPath.section], with: UITableView.RowAnimation.automatic)
        }else{
            tableview.reloadSections([indexPath.section], with: UITableView.RowAnimation.automatic)
           
            if arr_data[indexPath.section].menu.count > 0 {
                switch obj.menu[indexPath.row - 1].menu_id {
                case "13":
                    cell.lbl_title.textColor = HelperClassSwift.bcolor.getUIColor()
                    let vc:TransactionsVC = AppDelegate.mainSB.instanceVC()
                    let nav = UINavigationController.init(rootViewController: vc)
                    vc.title =  obj.menu_name
                    vc.MenuObj = obj
                    vc.StrSubMenue =  obj.menu[indexPath.row - 1].menu_name
                    _ =  panel?.center(nav)
                    
                case "69":
                    cell.lbl_title.textColor = HelperClassSwift.bcolor.getUIColor()
                    let vc:CronTransactionVC = AppDelegate.mainSB.instanceVC()
                    vc.title =  obj.menu_name
                    vc.MenuObj = obj
                    vc.StrSubMenue =  obj.menu[indexPath.row - 1].menu_name
                    _ =  panel?.center(vc)
                    
                case "27":
                    cell.lbl_title.textColor = HelperClassSwift.bcolor.getUIColor()
                    let vc:ApproveTransactionVC = AppDelegate.mainSB.instanceVC()
                    vc.title =  obj.menu_name
                    vc.MenuObj = obj
                    vc.StrSubMenue =  obj.menu[indexPath.row - 1].menu_name
                    _ =  panel?.center(vc)
                    
                    case "73":
                    cell.lbl_title.textColor = HelperClassSwift.bcolor.getUIColor()
                    let vc:AllPrpjectsVC = AppDelegate.mainSB.instanceVC()
                    vc.title =  obj.menu_name
                    vc.MenuObj = obj
                    vc.StrSubMenue =  obj.menu[indexPath.row - 1].menu_name
                    _ =  panel?.center(vc)
                    
                    
                default:
                    print(" no menu id ")
                }
              
            }

        }
        
        
      

 

    }
    
}




extension String {
    
    func fontAwesomeString(name: String) -> String {
        
        switch name {
        case "fa-close":
            return "\u{f00d}"
        default:
            return "\u{f00d}"// manage exhaustive case accordingly
        }
    }
}


class FontAwesomeConverter {
    public static func image(fromChar iconCode: String,
                         color: UIColor) -> UIImage {
    let label = UILabel(frame: .zero)
    label.textColor = color
    label.font = UIFont.fontAwesome(ofSize: 20, style: .solid)

        if let int32 = UInt32(hexString: iconCode), let unicode = UnicodeScalar(int32) {
            let unicode = Character(unicode)
           // return unicode
        }
        
//    let iconDecimal = Int(iconCode, radix: 16)!
//    let unicodeIcon = Character(UnicodeScalar(iconDecimal)!)
//    label.text = "\(unicodeIcon)"
//    label.sizeToFit()

    let renderer = UIGraphicsImageRenderer(size: label.frame.size)
    let image = renderer.image(actions: { context in
        label.layer.render(in: context.cgContext)
    })
    return image
   }
 }

extension UILabel {
// MARK:  set center alignment
   public func setFontAwesomeIcon(fromChar iconCode: String,
                        color: UIColor) {
    self.font = UIFont.fontAwesome(ofSize: 30, style: .solid)
    self.textColor = color

    let iconDecimal = Int(iconCode, radix: 16)!
    let unicodeIcon = Character(UnicodeScalar(iconDecimal)!)
    self.text = "\(unicodeIcon)"
    self.sizeToFit()
  }
}