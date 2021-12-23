//
//  EvaluationResultVC.swift
//  Almnabr
//
//  Created by MacBook on 07/12/2021.
//  Copyright © 2021 Samar Akkila. All rights reserved.
//

import UIKit

class EvaluationResultVC: UIViewController {
    
    @IBOutlet weak var icon_noPermission: UIImageView!
    @IBOutlet weak var view_noPermission: UIView!
    @IBOutlet weak var lbl_noPermission: UILabel!
    
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Notes: UILabel!
    
    @IBOutlet weak var lbl_No: UILabel!
    @IBOutlet weak var lbl_EvalTitle: UILabel!
    @IBOutlet weak var lbl_Result: UILabel!
    
    @IBOutlet weak var btn_submit: UIButton!
    
    @IBOutlet weak var view_main: UIView!
    @IBOutlet var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var lbl_EvaluationResult: UILabel!
    @IBOutlet weak var btn_EvaluationResult: UIButton!
    @IBOutlet weak var lbl_EvaluationResultSelect: UILabel!
    @IBOutlet weak var view_EvaluationResult: UIView!
    @IBOutlet weak var imgDropEvaluation: UIImageView!
    @IBOutlet weak var btn_cancel_Evaluation: UIButton!
    
    @IBOutlet weak var table: UITableView!
    
    var arr_Notes:[NotesObj] = []
    let dropDownmage =  UIImage.fontAwesomeIcon(name: .chevronDown , style: .solid, textColor:  .gray, size: CGSize(width: 40, height: 40))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configGUI()
       
        
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tableHeight?.constant = self.table.contentSize.height
    }
    
    
    //MARK: - Config GUI
    //------------------------------------------------------
    func configGUI() {
        
        icon_noPermission.loadGif(name: "no-permission")
        
        self.lbl_noPermission.text =  "You not have permission to access this step".localized()
        self.lbl_noPermission.font = .kufiRegularFont(ofSize: 15)
        self.lbl_noPermission.textColor =  "#333".getUIColor()
        
        
        if StatusObject?.Evaluation_Result == false {
            view_noPermission.isHidden = false
            self.view_main.isHidden = true
            
        }else{
            view_noPermission.isHidden = true
            self.view_main.isHidden = false
            self.get_notes()
        }
        
        self.lbl_Title.text =  "Evaluation Result".localized()
        self.lbl_Title.font = .kufiBoldFont(ofSize: 15)
        self.lbl_Title.textColor =  HelperClassSwift.acolor.getUIColor()
        
        self.lbl_Notes.text =  "Notes".localized()
        self.lbl_Notes.font = .kufiRegularFont(ofSize: 15)
        self.lbl_Notes.textColor =  HelperClassSwift.bcolor.getUIColor()
        
        self.lbl_No.text =  "#".localized()
        self.lbl_No.font = .kufiBoldFont(ofSize: 15)
        self.lbl_No.textColor =  HelperClassSwift.acolor.getUIColor()
        
        
        self.lbl_EvalTitle.text =  "Title".localized()
        self.lbl_EvalTitle.font = .kufiBoldFont(ofSize: 15)
        self.lbl_EvalTitle.textColor =  HelperClassSwift.acolor.getUIColor()
        
        
        self.lbl_Result.text =  "Result".localized()
        self.lbl_Result.font = .kufiBoldFont(ofSize: 15)
        self.lbl_Result.textColor =  HelperClassSwift.acolor.getUIColor()
        
        
        
        self.lbl_EvaluationResult.text = "Evaluation Result".localized()
        self.lbl_EvaluationResult.font = .kufiRegularFont(ofSize: 15)
        self.lbl_EvaluationResult.textColor =  HelperClassSwift.bcolor.getUIColor()
        
        
        self.lbl_EvaluationResultSelect.text = "Evaluation Result".localized()
        self.lbl_EvaluationResultSelect.font = .kufiRegularFont(ofSize: 15)
        self.lbl_EvaluationResultSelect.textColor =  HelperClassSwift.bcolor.getUIColor()
        
        
        self.view_EvaluationResult.setBorderGray()
       // self.view_EvaluationResult.backgroundColor = .gray
        self.view_main.setBorderGray()
        
        self.btn_cancel_Evaluation.isHidden = true
        
        self.btn_submit.setTitle("Submit".localized(), for: .normal)
        self.btn_submit.backgroundColor =  HelperClassSwift.acolor.getUIColor()
        self.btn_submit.setTitleColor(.white, for: .normal)
        
        self.imgDropEvaluation.image = dropDownmage
        
        table.dataSource = self
        table.delegate = self
        let nib = UINib(nibName: "NotesCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: "NotesCell")
        
        
    }
    
    
    
    
    func submit_Request(){
        
        self.showLoadingActivity()
        
        let params = ["transaction_request_id" : obj_transaction?.transaction_request_id ?? "0"]
        APIManager.sendRequestPostAuth(urlString: "form/FORM_WIR/Evaluation_Result/1", parameters: params ) { (response) in
            self.hideLoadingActivity()
            
            
            let status = response["status"] as? Bool
            let msg = response["msg"] as? String
            let error = response["error"] as? String
            
            if status == true{
                self.hideLoadingActivity()
                self.showAMessage(withTitle: "Success".localized(), message: msg ?? "Thank you. The operation was completed successfully.", completion: {
                    
//                    self.configGUI()
//                    self.change_page(SelectedIndex:8)
                    self.update_Config()
                })
                
            }else{
                self.hideLoadingActivity()
                self.showAMessage(withTitle: "Error", message: error ?? "Some thing went wrong")
                
            }
        }
        
        
    }
    
    
    
    func get_notes(){
        
        self.showLoadingActivity()
        
        let params = ["transaction_request_id" : obj_transaction?.transaction_request_id ?? "0"]
        APIManager.sendRequestPostAuth(urlString: "form/FORM_WIR/Evaluation_Result/0", parameters: params ) { (response) in
            self.hideLoadingActivity()
            
            
            let status = response["status"] as? Bool
            let msg = response["msg"] as? String
            let error = response["error"] as? String
            
            if status == true{
                self.hideLoadingActivity()
                let final_result = response["final_result"] as? String
                self.lbl_EvaluationResultSelect.text = final_result
                 
                if  let records = response["Notes"] as? NSDictionary{
                for i in records {
                    let obj = NotesObj.init(i.value as! [String : Any])
                    self.arr_Notes.append(obj)
 
                }
            }
              
                self.table.reloadData()
                
            }else{
                self.hideLoadingActivity()
                self.showAMessage(withTitle: "Error", message: error ?? "Some thing went wrong")
                
            }
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

extension EvaluationResultVC: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         
        return arr_Notes.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath) as! NotesCell
        
        let obj = arr_Notes[indexPath.item]
        cell.lbl_No.text =   "\(indexPath.item + 1)"
        cell.lbl_No.font = .kufiRegularFont(ofSize: 17)
        
        cell.lbl_Title.text =  obj.extra1_title
        cell.lbl_Title.font = .kufiRegularFont(ofSize: 17)
        
        cell.lbl_Result.text =  obj.extra1_result
        cell.lbl_Result.font = .kufiRegularFont(ofSize: 17)
        
       
        return cell
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    
}

