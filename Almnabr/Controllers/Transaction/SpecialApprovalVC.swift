//
//  SpecialApprovalVC.swift
//  Almnabr
//
//  Created by MacBook on 07/12/2021.
//  Copyright © 2021 Samar Akkila. All rights reserved.
//

import UIKit

class SpecialApprovalVC: UIViewController {

    @IBOutlet weak var icon_noPermission: UIImageView!
    @IBOutlet weak var view_noPermission: UIView!
    @IBOutlet weak var lbl_noPermission: UILabel!
    
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_notes: UILabel!
    
    @IBOutlet weak var txt_notes: UITextView!
    @IBOutlet weak var btn_submit: UIButton!
    
    @IBOutlet weak var view_main: UIView!
    
    @IBOutlet weak var view_txtView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configGUI()
    }
    
    
    //MARK: - Config GUI
    //------------------------------------------------------
    func configGUI() {
        
        icon_noPermission.loadGif(name: "no-permission")
        
        self.lbl_noPermission.text =  "You not have permission to access this step".localized()
        self.lbl_noPermission.font = .kufiRegularFont(ofSize: 15)
        self.lbl_noPermission.textColor =  "#333".getUIColor()
        
        
        if StatusObject?.Special_Approval == false {
            view_noPermission.isHidden = false
            self.view_main.isHidden = true

        }else{
            view_noPermission.isHidden = true
            self.view_main.isHidden = false
        }
        
        self.txt_notes.text = ""
        
        self.lbl_Title.text =  "Special Approval".localized()
        self.lbl_Title.font = .kufiBoldFont(ofSize: 15)
        self.lbl_Title.textColor =  HelperClassSwift.acolor.getUIColor()
        
        
        
        self.lbl_notes.text =  "Notes :".localized()
        self.lbl_notes.font = .kufiRegularFont(ofSize: 15)
        self.lbl_notes.textColor =  HelperClassSwift.bcolor.getUIColor()
        
        
        self.view_txtView.setBorderGray()
        
        self.view_main.setBorderGray()
        
        
        self.btn_submit.setTitle("Submit".localized(), for: .normal)
        self.btn_submit.backgroundColor =  HelperClassSwift.acolor.getUIColor()
        self.btn_submit.setTitleColor(.white, for: .normal)
        
    }


    

    
    func submit_Request(){
        
        
        if  self.txt_notes.text != "" {
            
            self.showLoadingActivity()
            
            let params = ["transaction_request_id" : obj_transaction?.transaction_request_id ?? "0",
                          "notes":self.txt_notes.text ?? ""]
            
            APIManager.sendRequestPostAuth(urlString: "form/FORM_WIR/Special_Approval/0", parameters: params ) { (response) in
                self.hideLoadingActivity()
               
                
                let status = response["status"] as? Bool
                let msg = response["msg"] as? String
                let error = response["error"] as? String
                
                if status == true{
                    self.hideLoadingActivity()
                    self.showAMessage(withTitle: "Success".localized(), message: msg ?? "Thank you. The operation was completed successfully.", completion: {

                        self.update_Config()
//                        self.configGUI()
//                        self.change_page(SelectedIndex:5)
                    })
                    
                }else{
                    self.hideLoadingActivity()
                    self.showAMessage(withTitle: "Error", message: error ?? "Some thing went wrong")
                    
                }
                }
            
            
        }else {
            
            self.showAMessage(withTitle: "Error".lowercased(), message: "Add your Notes")
            return
        }
   

    }
    
    
    @IBAction func btnSubmit_Click(_ sender: Any) {
        
        submit_Request()
    }
    
    
    
    private func change_page(SelectedIndex:Int) {
        NotificationCenter.default.post(name: NSNotification.Name("Change_Form_Step"),
                                        object: SelectedIndex)
    }
    
    private func update_Config() {
        NotificationCenter.default.post(name: NSNotification.Name("update_Config"),
                                        object: nil)
    }
    
}
