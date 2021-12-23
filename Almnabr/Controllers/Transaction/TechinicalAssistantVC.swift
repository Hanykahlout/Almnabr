//
//  TechinicalAssistantVC.swift
//  Almnabr
//
//  Created by MacBook on 07/12/2021.
//  Copyright © 2021 Samar Akkila. All rights reserved.
//

import UIKit
import DropDown
import AVFoundation

class TechinicalAssistantVC: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var icon_noPermission: UIImageView!
    @IBOutlet weak var view_noPermission: UIView!
    @IBOutlet weak var lbl_noPermission: UILabel!
    @IBOutlet weak var table_checkList: UITableView!
    @IBOutlet weak var table_saudiCode: UITableView!
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_CheckList: UILabel!
    @IBOutlet weak var lbl_SaudiBuldingCode : UILabel!
    @IBOutlet weak var lbl_SpecialApprovals: UILabel!
    @IBOutlet weak var lbl_addusers: UILabel!
    @IBOutlet weak var lbl_addusersSelected: UILabel!
    @IBOutlet weak var stack_addusers: UIStackView!
    @IBOutlet weak var view_addusers: UIView!
    @IBOutlet weak var imgDropaddusers: UIImageView!
    
    @IBOutlet weak var btnSpecialApprovals: UIButton!
    @IBOutlet weak var btn_cancel_AddUsers: UIButton!
    @IBOutlet weak var btn_submit: UIButton!
    @IBOutlet weak var view_main: UIView!
    
    @IBOutlet weak var btn_check: UIButton!
    @IBOutlet weak var btn_saudi: UIButton!
    @IBOutlet var tablecheckHeight: NSLayoutConstraint!
    @IBOutlet var tableSaudiHeight: NSLayoutConstraint!
    
    var arr_Users:[ModuleObj] = []
    var arr_UsersLabel:[String] = []
    var arr_file:[SaudiBuillding] = []
    var arr_Technical_Assistants:[Technical_Assistants] = []
    var SpecialApprovals_status:Bool = false
    var SpecialApprovals:String = ""
    
    let dropUpmage =  UIImage.fontAwesomeIcon(name: .chevronUp , style: .solid, textColor:  .gray, size: CGSize(width: 40, height: 40))
    
    let dropDownmage =  UIImage.fontAwesomeIcon(name: .chevronDown , style: .solid, textColor:  .gray, size: CGSize(width: 40, height: 40))
    
    let imagePickerController = UIImagePickerController()
    var documentInteractionController: UIDocumentPickerViewController? = nil
    
    var Selected_index:Int = 0
    var BulidingSelected_index:Int = 0
    var isCheckList:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configGUI()
        get_special_approver_users()
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tablecheckHeight?.constant = self.table_checkList.contentSize.height
        self.tableSaudiHeight?.constant = self.table_saudiCode.contentSize.height
    }
    
    
    //MARK: - Config GUI
    //------------------------------------------------------
    func configGUI() {
        
        icon_noPermission.loadGif(name: "no-permission")
        
        self.lbl_noPermission.text =  "You not have permission to access this step".localized()
        self.lbl_noPermission.font = .kufiRegularFont(ofSize: 15)
        self.lbl_noPermission.textColor =  "#333".getUIColor()
        
        if obj_transaction?.transaction_request_last_step == "completed"{
            self.stack_addusers.isHidden = true
            self.btn_check.isHidden = true
            self.btn_saudi.isHidden = true
            
            view_noPermission.isHidden = true
        }
        
        if StatusObject?.Techinical_Assistant == false {
            view_noPermission.isHidden = false
            self.view_main.isHidden = true
            append_inArrTech()
        }else{
            get_Technical_Assistants_Evaluation()
            view_noPermission.isHidden = true
            self.view_main.isHidden = false
        }
        
        self.imgDropaddusers.image = dropDownmage
        
        table_checkList.dataSource = self
        table_checkList.delegate = self
        let nib = UINib(nibName: "TechnicalAssistantCell", bundle: nil)
        table_checkList.register(nib, forCellReuseIdentifier: "TechnicalAssistantCell")
        
        
        table_saudiCode.dataSource = self
        table_saudiCode.delegate = self
        let nib1 = UINib(nibName: "SaudiTVCell", bundle: nil)
        table_saudiCode.register(nib1, forCellReuseIdentifier: "SaudiTVCell")
        
        
        self.lbl_title.text = "Technical Assistant".localized()
        self.lbl_title.font = .kufiBoldFont(ofSize: 16)
        self.lbl_title.textColor =  HelperClassSwift.acolor.getUIColor()
        
        
        self.lbl_CheckList.text = "Check List".localized()
        self.lbl_CheckList.font = .kufiRegularFont(ofSize: 15)
        self.lbl_CheckList.textColor =  HelperClassSwift.bcolor.getUIColor()
        
        self.lbl_SaudiBuldingCode.text = "Saudi Bulding Code :".localized()
        self.lbl_SaudiBuldingCode.font = .kufiRegularFont(ofSize: 15)
        self.lbl_SaudiBuldingCode.textColor =  HelperClassSwift.bcolor.getUIColor()
        
        self.lbl_SpecialApprovals.text = "Special Approvals !?".localized()
        self.lbl_SpecialApprovals.font = .kufiRegularFont(ofSize: 15)
        self.lbl_SpecialApprovals.textColor =  HelperClassSwift.bcolor.getUIColor()
        
        self.lbl_addusers.text = "add users".localized()
        self.lbl_addusers.font = .kufiRegularFont(ofSize: 15)
        self.lbl_addusers.textColor =  HelperClassSwift.bcolor.getUIColor()
        
        
        self.lbl_addusersSelected.text = "add users".localized()
        self.lbl_addusersSelected.font = .kufiRegularFont(ofSize: 15)
        self.lbl_addusersSelected.textColor =  HelperClassSwift.bcolor.getUIColor()
        
        
        self.stack_addusers.isHidden = true
        self.view_main.setBorderGray()
        
        self.view_addusers.setBorderGray()
        
        //  self.btnSpecialApprovals.setImage(UIImage(named: "check"), for: .normal)
        
        self.btn_submit.setTitle("Submit".localized(), for: .normal)
        self.btn_submit.backgroundColor =  HelperClassSwift.acolor.getUIColor()
        self.btn_submit.setTitleColor(.white, for: .normal)
        
        self.btnSpecialApprovals.setImage(UIImage(systemName:"square" ), for: .normal)
        
        self.table_checkList.reloadData()
        
        imagePickerController.delegate = self
        
        //
    
        self.table_checkList.reloadData()

    }
    
    func append_inArrTech(){
      
        var index:Int = 0
        var code:String = ""
        
        for i in arr_Technical_Assistants_Evaluation{
            
            if i.extra1_result == ""{
                code = i.no_code_result
            }else{
                code = i.extra1_result
            }
            
            let value = Technical_Assistants(title: i.extra1_title, status: "0", projects_from_consultant_id: "1" , result: code, img: nil, url: nil, type: nil, index: index, IsNew: false, yes_code_result: i.yes_code_result, no_code_result: i.no_code_result)
           
            index = index + 1
            self.arr_Technical_Assistants.append(value)
     
        }
        
        self.table_checkList.reloadData()
        self.viewWillLayoutSubviews()
        
    }
    
    
    
    func get_Technical_Assistants_Evaluation(){
        
        
        self.showLoadingActivity()
        
        let params = ["transaction_request_id" : obj_transaction?.transaction_request_id ?? "0"]
        
        APIManager.sendRequestPostAuth(urlString: "form/FORM_WIR/Techinical_Assistant/0", parameters: params ) { (response) in
            self.hideLoadingActivity()
            
            
            let status = response["status"] as? Bool
            let msg = response["msg"] as? String
            let error = response["error"] as? String
            
            if status == true{
                self.hideLoadingActivity()
                
                arr_Technical_Assistants_Evaluation =  []
                
                if  let records = response["Technical_Assistants_Evaluation"] as? NSArray{
                    for i in records {
                        let dict = i as? [String:Any]
                        let obj = Technical_Assistants_EvaluationObj.init(dict!)
                        arr_Technical_Assistants_Evaluation.append(obj)
                    }
                    
                    self.append_inArrTech()
                }
            }else{
                self.hideLoadingActivity()
                self.showAMessage(withTitle: "Error", message: error ?? "Some thing went wrong")
                
            }
        }
        
        
    }
    
    
    func get_special_approver_users(){
        
        self.showLoadingActivity()
        APIManager.sendRequestGetAuth(urlString: "form/FORM_WIR/special_approver_users?search_key=&lang_key=en&projects_work_area_id=\(obj_FormWir?.projects_work_area_id ?? "1")&method=list" ) { (response) in
            
            
            let status = response["status"] as? Bool
            if status == true{
                if  let list = response["records"] as? NSArray{
                    for i in list {
                        let dict = i as? [String:Any]
                        let obj = ModuleObj.init(dict!)
                        self.arr_Users.append(obj)
                        self.arr_UsersLabel.append(obj.label)
                        
                    }
                    self.hideLoadingActivity()
                }
            }
            self.hideLoadingActivity()
            
        }
    }
    
    
    func Submit_request(){
        
        guard arr_file.count != 0 else {
            showAMessage(withTitle: "error".localized(), message: "Please enter your file".localized())
            return
        }
  
        var params : [String:String] = [:]
        
        params["transaction_request_id"] = obj_transaction?.transaction_request_id ?? "0"
       // params["special_approvers"] = "2"
        
        for i in arr_file {
          
            params["Saudi_Building_Codes[\(i.index)][title]"] = i.Title
            params["Saudi_Building_Codes[\(i.index)][status]"] = i.Status
            
            
        }
        for i in arr_Technical_Assistants {
            if i.IsNew == false{
                params["Technical_Assistants_Evaluation[\(i.index)][title]"] = i.title
                params["Technical_Assistants_Evaluation[\(i.index)][projects_from_consultant_id]"] = i.projects_from_consultant_id
                params["Technical_Assistants_Evaluation[\(i.index)][status]"] = i.status
                params["Technical_Assistants_Evaluation[\(i.index)][result]"] = i.result
                params["attachments[\(i.index)][required]"] = i.Required
            }
            
        }
        
        showLoadingActivity()
        
        APIManager.func_UploadTechnical(queryString: "form/FORM_WIR/Techinical_Assistant/1", arr_Technical_Assistants, param: params ) { (respnse ) in
            
            let status = respnse["status"] as? Bool
            let errors = respnse["error"] as? String
            let msg = respnse["msg"] as? String
            
            if status == true{
                self.hideLoadingActivity()
                self.showAMessage(withTitle: "Success".localized(), message: msg ?? "Thank you. The operation was completed successfully.", completion: {

                    self.update_Config()
                })
                
       
            }else{
                
                self.hideLoadingActivity()
                self.showAMessage(withTitle: "error".localized(), message: errors ?? "something went wrong")
            }
            self.hideLoadingActivity()
            
            
        }
        
        
        
    }

    

    
    func Upload_file(){
        
        imagePickerController.allowsEditing = true
        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionsheet.addAction(UIAlertAction(title: "Choose photo".localized(), style: .default, handler: { (action:UIAlertAction)in
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.mediaTypes = ["public.image"]
            
            self.present(self.imagePickerController, animated: true, completion: nil)
            self.imagePickerController.sourceType = .photoLibrary
            
        }))
        
                
        actionsheet.addAction(UIAlertAction(title: "Choose Pdf".localized(), style: .default, handler: { (action:UIAlertAction)in
            
            self.documentInteractionController = UIDocumentPickerViewController(documentTypes: ["public.pdf", "public.data"], in: .import)
            self.documentInteractionController?.delegate = self
            self.present(self.documentInteractionController!, animated: true, completion: nil)
            
            
        }))
        
        actionsheet.addAction(UIAlertAction(title: "Close".localized(), style: .cancel, handler: nil))
        self.present(actionsheet,animated: true, completion: nil)
        
    }

    
    
    
    @IBAction func btnSpecialApprovals_Click(_ sender: Any) {
        
        
        if SpecialApprovals_status == false {
            self.btnSpecialApprovals.setImage(UIImage(systemName:"checkmark.square.fill" ), for: .normal)
            self.stack_addusers.isHidden = false
            SpecialApprovals_status = true
        }else{
            self.btnSpecialApprovals.setImage(UIImage(systemName:"square" ), for: .normal)
            SpecialApprovals_status = false
            self.stack_addusers.isHidden = true
        }
        
        
        
    }
    
    
    
    @IBAction func btnSubmit_Click(_ sender: Any) {
        
        Submit_request()
    }
    
    @IBAction func btnAddCkeckList_Click(_ sender: Any) {
        var is_nil = false
        
        for i in arr_Technical_Assistants {
            let urlStr = i.url
            let img = i.img

            if (urlStr == nil && img == nil) {
                is_nil = true
                break
            }
        }
        
        if is_nil {
            self.showAMessage(withTitle: "error".localized(), message: "Attach file to the last entry at First")
        }else{
           // let param :[String:Any] = ["":]
            let index = arr_Technical_Assistants.count - 1
            let new_index = (Selected_index + 1)
            let obj = self.arr_Technical_Assistants[index]
            self.arr_Technical_Assistants[index] = Technical_Assistants(title: obj.title, status: "0", projects_from_consultant_id: "1", result: obj.no_code_result!, img: obj.img, url: obj.url, type: obj.type, index: obj.index, IsNew: obj.IsNew, yes_code_result: obj.yes_code_result, no_code_result: obj.no_code_result, Required: obj.Required)
            
           self.Selected_index = self.Selected_index + 1
            
            isCheckList = false
            self.table_checkList.reloadData()
        }
        
    }
    
    @IBAction func btnAddBulding_Click(_ sender: Any) {
        
        var is_nil = false
        
        for i in arr_file {
            let status = i.Status
            let title = i.Title
                 
            if (status == "" || title == "") {
                is_nil = true
                break
            }
        }
        
        if is_nil {
            self.showAMessage(withTitle: "error".localized(), message: "Add Title and status to the last entry at First")
        }else{
            
            let new_index = (BulidingSelected_index + 1)
            self.arr_file.append(SaudiBuillding(Status: "No", Title: "", index: new_index ))
           self.BulidingSelected_index = self.BulidingSelected_index + 1
            
            isCheckList = true
            self.table_saudiCode.reloadData()
        }
        
    }
    
    
    
    @IBAction func btnAddUsers_Click(_ sender: Any) {
        
        let dropDown = DropDown()
        dropDown.anchorView = view
        dropDown.backgroundColor = .white
        dropDown.cornerRadius = 2.0
        
        dropDown.dataSource = self.arr_UsersLabel
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            if item == self.arr_UsersLabel[index] {
                // self.owner_users = arr_Users[index].value
                self.SpecialApprovals = arr_Users[index].user_type_id
                self.lbl_addusersSelected.text = item
                self.btn_cancel_AddUsers.isHidden = false
            }
            
        }
        dropDown.direction = .bottom
        dropDown.anchorView = view_addusers
        dropDown.bottomOffset = CGPoint(x: 0, y: view_addusers.bounds.height)
        dropDown.width = view_addusers.bounds.width
        dropDown.show()
        
    }
    
    
    @IBAction func btnUsersDelete_Click(_ sender: Any) {
        self.lbl_addusersSelected.text = "add users".localized()
        
        self.btn_cancel_AddUsers.isHidden = true
    }
    
    private func update_Config() {
        NotificationCenter.default.post(name: NSNotification.Name("update_Config"),
                                        object: nil)
    }
    
    
}





extension TechinicalAssistantVC: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView {
        case table_checkList:
            return arr_Technical_Assistants.count
        case table_saudiCode:
            return arr_file.count
        default:
            return 0
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        
        switch tableView {
        case table_checkList:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TechnicalAssistantCell", for: indexPath) as! TechnicalAssistantCell
            
            let obj = arr_Technical_Assistants[indexPath.item]
            cell.lbl_Title.text = "Title: " + obj.title!
            cell.lblNumber.text = "# \(indexPath.item + 1)"
            cell.lbl_EvaluationResult.text = "Evaluation Result: " + obj.result!
 
            cell.lbl_Status.text = "Evaluation Status: "
            cell.lblNo.text =  "No".localized()
            cell.lblYes.text =  "Yes".localized()
            cell.lbl_Attachments.text = "Attachments"
            
            if obj.IsNew == false{
                cell.btn_check.isHidden = true
                cell.tf_Title.isHidden = true
                cell.btn_delete.isHidden = true
            }
            
            if obj_transaction?.transaction_request_last_step == "completed"{
                cell.btn_delete.isHidden = true
                cell.tf_Title.isHidden = true
                cell.stack_upload.isHidden = true
                cell.stack_status.isHidden = true
                
                if obj.status! == "1"{
                    cell.btn_check.setImage(UIImage(systemName: "checkmark"), for: .normal)
                    cell.btn_check.tintColor = "#4ca832".getUIColor()
                    
                }else{
                    cell.btn_check.tintColor = "#bf2a2a".getUIColor()
                    cell.btn_check.setImage(UIImage(systemName: "xmark"), for: .normal)
                }
            }
            
            cell.btnNoAction = {
                cell.btn_checkYes.setImage(UIImage(named: "uncheck"), for: .normal)
                cell.btn_checkNo.setImage(UIImage(named: "check"), for: .normal)
                
                cell.lbl_EvaluationResult.text = "Evaluation Result: " + obj.no_code_result!
                
                let obj = self.arr_Technical_Assistants[indexPath.item]
                self.arr_Technical_Assistants[indexPath.item] = Technical_Assistants(title: obj.title, status: "0", projects_from_consultant_id: "1", result: obj.no_code_result!, img: obj.img, url: obj.url, type: obj.type, index: obj.index, IsNew: obj.IsNew, yes_code_result: obj.yes_code_result, no_code_result: obj.no_code_result, Required: obj.Required)
            }
            
            cell.btnYesAction = {
                cell.btn_checkNo.setImage(UIImage(named: "uncheck"), for: .normal)
                cell.btn_checkYes.setImage(UIImage(named: "check"), for: .normal)
                
                cell.lbl_EvaluationResult.text = "Evaluation Result: " + obj.yes_code_result!
                
                let obj = self.arr_Technical_Assistants[indexPath.item]
                self.arr_Technical_Assistants[indexPath.item] = Technical_Assistants(title: obj.title, status: "1", projects_from_consultant_id: "1", result: obj.yes_code_result!, img: obj.img, url: obj.url, type: obj.type, index: obj.index, IsNew: obj.IsNew, yes_code_result: obj.yes_code_result, no_code_result: obj.no_code_result, Required: obj.Required)
                
                
            }
            
            return cell
        case table_saudiCode:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SaudiTVCell", for: indexPath) as! SaudiTVCell
            
            let obj = arr_file[indexPath.item]
            cell.tf_Title.placeholder = "Description"
            cell.lblNumber.text = "# \(indexPath.item + 1)"
         
            cell.lblNo.text =  "No".localized()
            cell.lblYes.text =  "Yes".localized()
            self.BulidingSelected_index = obj.index
            cell.tf_Title.delegate = self
            cell.btnNoAction = {
                let obj = self.arr_file[indexPath.item]
                self.arr_file[indexPath.item] = SaudiBuillding(Status: "0", Title: obj.Title,index: obj.index)
      
                cell.btn_checkYes.setImage(UIImage(named: "uncheck"), for: .normal)
                cell.btn_checkNo.setImage(UIImage(named: "check"), for: .normal)
               
            }
            
            cell.btnYesAction = {
               
                let obj = self.arr_file[indexPath.item]
                self.arr_file[indexPath.item] = SaudiBuillding(Status: "1", Title: obj.Title,index: obj.index)
           
                cell.btn_checkNo.setImage(UIImage(named: "uncheck"), for: .normal)
                cell.btn_checkYes.setImage(UIImage(named: "check"), for: .normal)
            }
            
            
            cell.btnDeleteAction = {
                () in
                self.arr_file.remove(at: indexPath.item)
                self.table_saudiCode.reloadData()
                
            }
            cell.btnEndEditingAction = {
                
                //                if let row = self.arr_file.firstIndex(where: {$0.index == self.BulidingSelected_index}) {
                //                    let obj = self.arr_file[row]
                self.arr_file[indexPath.item] = SaudiBuillding(Status: "1", Title: cell.tf_Title.text!,index: obj.index)
                print(obj.Title)
                //}
                
              self.table_saudiCode.reloadData()
                
            }
            
            
            return cell
  
        
        default:
            return UITableViewCell()
        }        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
}


extension TechinicalAssistantVC : UIImagePickerControllerDelegate  {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        if let image = (info[.originalImage] as? UIImage){
            
            
            let value = attachment(img: image, url: nil, type: "img",index: Selected_index)
           // self.arr_file.append(value)
            //self.arr_file = self.arr_file.map { $0.img == nil ? image : nil }

            if isCheckList == false {
                if let row = self.arr_file.firstIndex(where: {$0.index == self.BulidingSelected_index}) {

                 //   arr_file[row] = attachment(title:arr_file[row].title, Required:  arr_file[row].Required , img: image, url: nil ,type: "img",index: BulidingSelected_index)
                }
               
                self.table_saudiCode.reloadData()
            }else{
                
            }
          
            
        }
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            self.imagePickerController.allowsEditing = true
            
            let data =  editedImage.jpegData(compressionQuality:0.6)
            let imageSize: Int = data?.count ?? 0
            print(imageSize/1000000)
            let size  = imageSize/1000000
            
            if size > 10 {
                self.showAMessage(withTitle: "error".localized(), message: "image must be less than 10 MB".localized())
                return
            }
           // self.Collection.reloadData()
        }
        
        picker.dismiss(animated: true) {
            
        }
    }
    
    
    
    
}





extension TechinicalAssistantVC: UIDocumentPickerDelegate {
    
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(urls)
        for url in urls {
            let cico = url as URL
            
            
            print(cico)
            print(url)
            print(url.lastPathComponent)
            print(url.pathExtension)
            getDataFrom(url: url) { (data) in
                if let data = data {
                    
                    
                    if isCheckList == false {
                        
//                        let value = attachment(img: nil, url: url, type: "file",index: Selected_index)
//                        if let row = self.arr_file.firstIndex(where: {$0.index == self.Selected_index}) {
//                            arr_file[row] = value
//                        }
                       
                        self.table_saudiCode.reloadData()
                    }else{
                        
                        
                       
                        
                    }
                    
                    let Size1: Int = data.count ?? 0
                    let size  = Size1/1000000
                    
                    if size > 10 {
                        self.showAMessage(withTitle: "error".localized(), message: "Pdf must be less than 10 MB".localized())
                        return
                    }
                    
                  //  self.Collection.reloadData()
                    
                }
                
                
            }
        }
    }
    

    func getDataFrom(url: URL, completion: (Data?)->()) {
        do {
            let data = try Data.init(contentsOf: url, options: .dataReadingMapped)
            print(data)
            completion(data)
        }catch {
            print(error)
            completion(nil)
        }
    }
    
    
    
    func json(from object: Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }

}


extension TechinicalAssistantVC : UITextFieldDelegate {

func textFieldDidEndEditing(_ textField: UITextField) {
    
    print(textField.tag, " -> ", textField.text)
    

}
    
}
