//
//  LanguageVC.swift
//  Almnabr
//
//  Created by MacBook on 05/11/2021.
//  Copyright © 2021 Samar Akkila. All rights reserved.
//

import UIKit
import DropDown
import DPLocalization

class LanguageVC: UIViewController {

    
    @IBOutlet weak var lblLanguage: UILabel!
    
    @IBOutlet weak var lblLanguageSelect: UILabel!
   
    @IBOutlet weak var viewLanguageSelect: UIView!
   
    @IBOutlet weak var btnLanguageSelect: UIButton!
    
    @IBOutlet weak var imgDropLanguageSelect: UIImageView!
    
    @IBOutlet weak var imgStep: UIImageView!
    @IBOutlet weak var viewStep: UIView!
    @IBOutlet weak var lblStep: UILabel!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var btnNext: UIButton!
    
    
    
    var arr_Language:[ModuleObj] = []
    var arr_LanguageLabel:[String] = []
    var arr_NoData:[String] = ["No items found".localized()]
    
    var arr_lang = ["English".localized(),"Arabic".localized()]
    var ProjectObj:templateObj?
    
    var StrLanguage:String = "en"
    
    let dropUpmage =  UIImage.fontAwesomeIcon(name: .chevronUp , style: .solid, textColor:  .gray, size: CGSize(width: 40, height: 40))
    
    let dropDownmage =  UIImage.fontAwesomeIcon(name: .chevronDown , style: .solid, textColor:  .gray, size: CGSize(width: 40, height: 40))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configGUI()
        get_Lang()
        print(ProjectObj?.group1name)
    }
    

    
    
    //MARK: - Config GUI
    //------------------------------------------------------
    func configGUI() {
        
        
    
        lblLanguage.textColor =  HelperClassSwift.acolor.getUIColor()
        lblLanguage.font = .kufiBoldFont(ofSize: 15)
        lblLanguage.text = "txt_Language"
        
        //self.lblLanguageSelect.text = "English"
     
       
        self.lblLanguageSelect.text =  "English"
        self.lblLanguageSelect.font = .kufiRegularFont(ofSize: 15)
        
        self.viewLanguageSelect.setBorderGray()
        self.lblLanguage.text = "txt_Language".localized()
        self.lblLanguageSelect.font = .kufiRegularFont(ofSize: 15)
        
    
        self.imgDropLanguageSelect.image = dropDownmage
        
        
        self.viewStep.backgroundColor = HelperClassSwift.acolor.getUIColor()
        self.lblStep.text = "txt_Language".localized()
        self.lblStep.font = .kufiBoldFont(ofSize: 15)
        self.lblStep.textColor = HelperClassSwift.acolor.getUIColor()
        
        self.btnNext.backgroundColor = HelperClassSwift.acolor.getUIColor()
        
        
        self.viewStep.setBorderGrayWidth(3)
        let Stepimage =  UIImage.fontAwesomeIcon(name: .building, style: .solid, textColor: HelperClassSwift.bcolor.getUIColor(), size: CGSize(width: 40, height: 40))
        self.imgStep.image = Stepimage
        
        //self.mainView.setBorderGray()
        
    }
    
    
    func get_Lang(){
        
        self.showLoadingActivity()
        APIManager.sendRequestGetAuth(urlString: "tc/tlanguages" ) { (response) in
            
            
            let status = response["status"] as? Bool
            if status == true{
                if  let list = response["records"] as? NSArray{
                    for i in list {
                        let dict = i as? [String:Any]
                        let obj = ModuleObj.init(dict!)
                        self.arr_Language.append(obj)
                        // for echitem in obj{
                        self.arr_LanguageLabel.append(obj.label)
                        // }
                        
                    }
                    self.hideLoadingActivity()
                }
            }
            
            
        }
    }
    
    
    @IBAction func btnLanguage_Click(_ sender: Any) {
        
        let dropDown = DropDown()
        dropDown.anchorView = view
        dropDown.backgroundColor = .white
        dropDown.cornerRadius = 2.0
  
        dropDown.dataSource = self.arr_lang
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            if item == self.arr_lang[0] {
                self.StrLanguage = "en"
                self.lblLanguageSelect.text = item
            }else{
                self.StrLanguage = "ar"
                self.lblLanguageSelect.text =  self.arr_lang[1]
            }
            
        }
        dropDown.direction = .bottom
        dropDown.anchorView = btnLanguageSelect
        dropDown.bottomOffset = CGPoint(x: 0, y: btnLanguageSelect.bounds.height)
        dropDown.width = btnLanguageSelect.bounds.width
        dropDown.show()
        
//        let dropDown = DropDown()
//        dropDown.anchorView = view
//        dropDown.backgroundColor = .white
//        dropDown.cornerRadius = 2.0
//
//        dropDown.dataSource = self.arr_lang
//        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//
////            if self.arr_LanguageLabel.count == 0 {
////                dropDown.dataSource = self.arr_NoData
////                dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
////                    self.imgDropLanguageSelect.image = dropDownmage
////                }
////                dropDown.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
////            }else{
//                dropDown.dataSource = self.arr_lang
//                dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//
//                    if item == self.arr_lang[0] {
//                        self.StrLanguage = item
//                        self.lblLanguageSelect.text = item
//                    }else{
//                        self.StrLanguage = self.arr_lang[1]
//                        self.lblLanguageSelect.text =  self.arr_lang[1]
//                    }
//
//
//                    self.imgDropLanguageSelect.image = dropDownmage
////                    if item == self.arr_LanguageLabel[index] {
////
////                        self.lblLanguageSelect.text =  item
////                        let i =  self.arr_Language[index]
////                        self.imgDropLanguageSelect.image = dropDownmage
////                       // self.btnLanguageSelect.isHidden = false
////                        self.lblLanguageSelect.text = i.label
////
////                        let lang = i.value
////                        self.StrLanguage = lang
////
////                   }
//
//                }
//
//           // }
//        }
//        dropDown.direction = .bottom
//        dropDown.anchorView = btnLanguageSelect
//        dropDown.bottomOffset = CGPoint(x: 0, y: btnLanguageSelect.bounds.height)
//        dropDown.width = btnLanguageSelect.bounds.width
//        dropDown.show()
    }
    
  
    @IBAction func btnSiteLevel_Click(_ sender: Any) {
        
        let vc:SiteLevelVC = AppDelegate.mainSB.instanceVC()
        vc.StrLanguage = self.StrLanguage
        vc.ProjectObj = self.ProjectObj
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
