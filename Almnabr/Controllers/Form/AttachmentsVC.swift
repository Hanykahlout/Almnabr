//
//  AttachmentsVC.swift
//  Almnabr
//
//  Created by MacBook on 16/11/2021.
//  Copyright © 2021 Samar Akkila. All rights reserved.
//

import UIKit
import MobileCoreServices
import DropDown

struct attachment {
    
    var title:String?
    var Required:String?
    var img:UIImage?
    var url:URL?
    var type:String?
    var index:Int = 0
    var IsNew:Bool = false
}

class AttachmentsVC: UIViewController ,UINavigationControllerDelegate{

    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var imgStep: UIImageView!
    @IBOutlet weak var viewStep: UIView!
    @IBOutlet weak var lblStep: UILabel!
    @IBOutlet weak var lblAttachments: UILabel!
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPrevious: UIButton!
    
    @IBOutlet weak var lblContractorManager: UILabel!
    @IBOutlet weak var lblSelectContractor: UITextField!
    @IBOutlet weak var viewContractor: UIView!
    @IBOutlet weak var btnContractor: UIButton!
    @IBOutlet weak var imgDropContractor: UIImageView!
    @IBOutlet weak var btnDeleteContractor: UIButton!
    
    
    @IBOutlet weak var btnYes: UIImageView!
    @IBOutlet weak var btnNo: UIImageView!
    
    @IBOutlet weak var lblContractorTeamUsers: UILabel!
    @IBOutlet weak var lblYes: UILabel!
    @IBOutlet weak var lblNo: UILabel!
    
    @IBOutlet weak var Stack_contractor: UIView!
    
    
    var arr_default_attachment:[FileObj] = []
    var arr_data:[AttachmentsObj] = []
    var arr_file:[attachment] = []
    var ProjectObj:templateObj!
    var transaction_separation:String = ""
    
    var units_and_level :String = ""
    var StrLanguage:String = "en"
    var Selected_index:Int = 0
    var work_site:String = "ALL"
    var units :String = ""
    var user_position:String = "CTT01"
    
    var arr_NoData:[String] = ["No items found".localized()]
    
    var parm = [:] as [String : String]
    var level_Unit = ""
    
    var arr_contractor:[ContractorObj] = []
    var arr_contractor_label:[String] = []
    var arr_unit:[uintObj] = []
    
    let imagePickerController = UIImagePickerController()
    var documentInteractionController: UIDocumentPickerViewController? = nil
    
    
    let checked =  UIImage.fontAwesomeIcon(name: .checkCircle, style: .solid, textColor: HelperClassSwift.bcolor.getUIColor(), size: CGSize(width: 40, height: 40))
    
    let Unchecked =  UIImage.fontAwesomeIcon(name: .circle, style: .solid, textColor: HelperClassSwift.bcolor.getUIColor(), size: CGSize(width: 40, height: 40))
    
    let dropUpmage =  UIImage.fontAwesomeIcon(name: .chevronUp , style: .solid, textColor:  .gray, size: CGSize(width: 40, height: 40))
    
    let dropDownmage =  UIImage.fontAwesomeIcon(name: .chevronDown , style: .solid, textColor:  .gray, size: CGSize(width: 40, height: 40))
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configGUI()
        get_default_attachments()
        get_ContractorTeamUsers()
    }
    
    
    
    //MARK: - Config GUI
    //------------------------------------------------------
    func configGUI() {
 
        
        self.mainView.setBorderGray()
        
        viewContractor.setBorderGray()
        imagePickerController.delegate = self
        
        self.viewStep.backgroundColor = HelperClassSwift.acolor.getUIColor()
        self.lblStep.text = "txt_Attachments".localized()
        self.lblStep.font = .kufiBoldFont(ofSize: 15)
        self.lblStep.textColor = HelperClassSwift.acolor.getUIColor()
        
        
        self.lblAttachments.text = "txt_Attachments".localized()
        self.lblAttachments.font = .kufiRegularFont(ofSize: 15)
        self.lblAttachments.textColor = .gray
        
        
        
        lblContractorManager.textColor = .gray
        lblContractorManager.font = .kufiRegularFont(ofSize: 15)
        lblContractorManager.text = "lbl_ContractorManager".localized()
       
        
        lblSelectContractor.textColor = .gray
        lblSelectContractor.font = .kufiRegularFont(ofSize: 15)
        lblSelectContractor.text = "lbl_ContractorTeamUsers".localized()
       
        
        
        lblContractorTeamUsers.textColor = .gray
        lblContractorTeamUsers.font = .kufiRegularFont(ofSize: 15)
        lblContractorTeamUsers.text = "lbl_ContractorTeamUsers".localized()
        
        
        lblYes.textColor = .gray
        lblYes.font = .kufiRegularFont(ofSize: 15)
        lblYes.text = "txt_Yes".localized()
        
        
        lblNo.textColor = .gray
        lblNo.font = .kufiRegularFont(ofSize: 15)
        lblNo.text = "txt_No".localized()
        
        
        
        self.btnNo.image = UIImage(named: "uncheck")
        self.btnYes.image = UIImage(named: "check")
        
        
        
        
        self.btnNext.backgroundColor = HelperClassSwift.acolor.getUIColor()
        self.btnPrevious.backgroundColor = HelperClassSwift.acolor.getUIColor()
        
        
        self.viewStep.setBorderGrayWidth(3)
        let Stepimage =  UIImage.fontAwesomeIcon(name: .building, style: .solid, textColor: HelperClassSwift.bcolor.getUIColor(), size: CGSize(width: 40, height: 40))
        self.imgStep.image = Stepimage
        
        
        table.dataSource = self
        table.delegate = self
        let nib = UINib(nibName: "AttachmentsCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: "AttachmentsCell")
        
        if userObj?.user_type_id == "1" {
            self.arr_file.append(attachment(title: "Signed Contractor Request PDF", Required: "Yes", img: nil, url: nil,type: "img" ,index: 0 , IsNew: true))
            self.Selected_index = self.Selected_index + 1
            
        }
        
        let userType = userObj?.user_type_id
        
        if userType == "3" || userType == "4" {
            Stack_contractor.isHidden = false
        }else{
            Stack_contractor.isHidden = true
        }
       
        
    }
    
    
    
    
    
    
    func get_default_attachments(){
        
        self.showLoadingActivity()
        
        guard ProjectObj != nil else{
            return
        }
       
        var params = [:] as [String : String]
        
       params["projects_work_area_id"] = ProjectObj.projects_work_area_id
       params["platform_code_system"] = ProjectObj.template_platform_code_system
       params["lang_key"] = StrLanguage
       params["work_site"] = self.work_site
        
        
        if arr_unit.count == 0 {
          params["units_and_level[\(self.level_Unit)]"] = self.units
        }else{
           
            var unit_str :String = ""
            var value_str :String = ""
            
            for i in arr_unit {
             
                if value_str == i.value! {
                    unit_str = unit_str + i.unit! + ","
                    params["units_and_level[\(i.value ?? "level_all_building")]"] = i.unit
                    value_str = i.value!
                }else{
                   params["units_and_level[\(i.value ?? "level_all_building")]"] = i.unit
                    value_str = i.value!
                }
               
            }
            
        }
        
     
        
        APIManager.sendRequestPostAuth(urlString: "form/FORM_WIR/get_default_attachments", parameters: params ) { (response) in
            self.hideLoadingActivity()
           
            
            let status = response["status"] as? Bool
            let error = response["error"] as? String
            
            
            if status == true{
                if  let list = response["records"] as? NSArray{
                    for i in list {
                        let dict = i as? [String:Any]
                        let obj = FileObj.init(dict!)
                        self.arr_default_attachment.append(obj)
                    }
                    
                    for i in self.arr_default_attachment{
                  
                        
                        let value = attachment(title:i.label, img: nil, url: URL(string: i.file_path), type: "file",index: self.Selected_index)
                        self.Selected_index = self.Selected_index + 1
                        self.arr_file.append(value)
         
                    }
                    
                    self.table.reloadData()
                    
            }else{
                self.showAMessage(withTitle: "Error", message: error ?? "Some thing went wrong")
                
            }

            
           
            }

        
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
    
    
    
    func Submit_request(){
        
        guard arr_file.count != 0 else {
            showAMessage(withTitle: "error".localized(), message: "Please enter your file".localized())
            return
        }
  
        for i in arr_file {
            self.parm["attachments[\(i.index)][attach_title]"] = i.title
            self.parm["attachments[\(i.index )][required]"] = i.Required
        }

        
        showLoadingActivity()
        
        APIManager.func_Upload(queryString: "/form/FORM_WIR/cr/2/0", arr_file, param: self.parm ) { (respnse ) in
            
            let status = respnse["status"] as? Bool
            let errors = respnse["error"] as? String
//            let data = respnse["data"] as? [String:Any]
//
            
            if status == true{
                
                let vc:TransactionsVC = AppDelegate.mainSB.instanceVC()
//                vc.MenuObj = MenuObj
//                vc.StrSubMenue =  "All Projects".localized()
//                vc.StrMenue = "Projects".localized()
//                vc.MenuObj = self.MenuObj
                _ =  self.panel?.center(vc)
                
   print("success")
            }else{
                
                self.hideLoadingActivity()
                self.showAMessage(withTitle: "error".localized(), message: errors ?? "something went wrong")
            }
            self.hideLoadingActivity()
            
            
        }
        
        
        
    }

    
    
    
    func get_ContractorTeamUsers(){
      
       self.showLoadingActivity()
        APIManager.sendRequestGetAuth(urlString: "/form/FORM_WIR/contractor_users?lang_key=\(StrLanguage)&projects_work_area_id=\(ProjectObj.projects_work_area_id))&user_position=\(self.user_position)" ) { (response) in
            
            
            let status = response["status"] as? Bool
            if status == true{
                if  let list = response["records"] as? NSArray{
                    for i in list {
                        let dict = i as? [String:Any]
                        let obj = ContractorObj.init(dict!)
                        self.arr_contractor.append(obj)
                        // for echitem in obj{
                        //self.level_Unit = obj.value
                        self.arr_contractor_label.append(obj.label)
                        // }
                        
                    }
                    self.hideLoadingActivity()
                }
            }
            
            
        }
    }
    
    
    
    @IBAction func btnBack_Click(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnSubmit_Click(_ sender: Any) {
        Submit_request()
    }
    
    @IBAction func btnAddFile_Click(_ sender: Any) {
        
        var is_nil = false
        
        for i in arr_file {
            
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
            let new_index = (Selected_index + 1)
            self.arr_file.append(attachment(title: "", Required: "No", img: nil, url: nil,type: "file", index: new_index))
            self.table.reloadData()
        }
        
     
    }
    

    
    @IBAction func btnContractorTeamUser_Click(_ sender: Any) {
        
        self.imgDropContractor.image = dropUpmage
        let dropDown = DropDown()
        dropDown.anchorView = view
        dropDown.backgroundColor = .white
        dropDown.cornerRadius = 2.0
        
        if self.arr_contractor_label.count == 0 {
            dropDown.dataSource = self.arr_NoData
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                self.imgDropContractor.image = dropDownmage
            }
            dropDown.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }else{
            dropDown.dataSource = self.arr_contractor_label
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                
                if item == self.arr_contractor_label[index] {
                    self.lblSelectContractor.text =  item
                    let i =  self.arr_contractor[index]
                    //self.StrWorkLevel = i.value
                    self.parm["contractor_team_users"] = i.value
                    self.imgDropContractor.image = dropDownmage
                    self.btnDeleteContractor.isHidden = false
                    
                }
                
            }
            
        }
        dropDown.direction = .bottom
        dropDown.anchorView = viewContractor
        dropDown.bottomOffset = CGPoint(x: 0, y: viewContractor.bounds.height)
        dropDown.width = viewContractor.bounds.width
        dropDown.show()

    }
    
    
    @IBAction func btnNo_Click(_ sender: Any) {
        
        self.user_position = "CTT01"
        self.parm["contractor_manager_step_require"] = "0"
        self.btnNo.image = UIImage(named: "check")
        self.btnYes.image = UIImage(named: "uncheck")
    }
    
    @IBAction func btnYes_Click(_ sender: Any) {
        
        self.user_position = "CTM01"
        self.parm["contractor_manager_step_require"] = "1"
        self.btnNo.image = UIImage(named: "uncheck")
        self.btnYes.image = UIImage(named: "check")
    
    }
    
    
    @IBAction func btnDelete_Click(_ sender: Any) {
        self.lblContractorTeamUsers.text = "lbl_ContractorTeamUsers".localized()
        self.btnDeleteContractor.isHidden = true
       
    }
    
    
}


extension AttachmentsVC: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
      
        return arr_file.count
    
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
            let cell = tableView.dequeueReusableCell(withIdentifier: "AttachmentsCell", for: indexPath) as! AttachmentsCell
            
            let obj = arr_file[indexPath.item]
 
            if obj.title != ""{
                
                if obj.title != "Signed Contractor Request PDF" {
                
                    cell.btn_Select.setImage(UIImage(named: "icon-pdf"), for: .normal)
                }
                cell.lblNo.text =  "#" + "\(obj.index + 1)"
                cell.lblNo.font = .kufiRegularFont(ofSize: 17)
                cell.tfTitle.text = obj.title
                cell.btn_Select.tintColor = HelperClassSwift.acolor.getUIColor()
                cell.btn_delete.isHidden = true
                cell.tfTitle.isUserInteractionEnabled = false
                
                
            }else{
                
                cell.btn_Select.setImage( UIImage(systemName: "plus.rectangle.fill.on.folder.fill"), for: .normal)
               
                cell.lblNo.text =  "#" + "\(indexPath.item + 1)"
                cell.lblNo.font = .kufiRegularFont(ofSize: 17)
                cell.tfTitle.text = ""
                cell.tfTitle.placeholder = "Description"
                cell.btn_Select.tintColor = HelperClassSwift.acolor.getUIColor()
                cell.btn_delete.isHidden = false
                cell.tfTitle.isUserInteractionEnabled = true
            }
     
        
        cell.btnDeleteAction = {
            () in
            self.arr_file.remove(at: indexPath.item)
            self.table.reloadData()
            
        }
        
        cell.btnUploadAction = {
            () in
           
            
            if obj.url != nil && obj.IsNew == false{
                let url = obj.url!.absoluteString
                let vc:PDFViewrVC  = AppDelegate.mainSB.instanceVC()
                vc.isModalInPresentation = true
                //vc.modalPresentationStyle = .overFullScreen
                vc.definesPresentationContext = true
                vc.Strurl = url
                self.present(vc, animated: true, completion: nil)
            }else{
                self.Selected_index = indexPath.item
                self.Upload_file()
            }
            
          
            
        }
        
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white
        cell.selectedBackgroundView = backgroundView
        
        return cell
        
        
  
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = arr_file[indexPath.item]
     
    }
}




extension AttachmentsVC : UIImagePickerControllerDelegate  {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        if let image = (info[.originalImage] as? UIImage){
            
            
            let value = attachment(img: image, url: nil, type: "img",index: Selected_index)
            //self.arr_file.append(value)
            //self.arr_file = self.arr_file.map { $0.img == nil ? image : nil }
            
            if let row = self.arr_file.firstIndex(where: {$0.index == self.Selected_index}) {
                
                arr_file[row] = attachment(title:arr_file[row].title, Required:  arr_file[row].Required , img: image, url: nil ,type: "img",index: Selected_index)
            }
           
            self.table.reloadData()
            
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





extension AttachmentsVC: UIDocumentPickerDelegate {
    
    
    
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
                    
                    
                    let value = attachment(img: nil, url: url, type: "file",index: Selected_index)
                   
                    
                    if let row = self.arr_file.firstIndex(where: {$0.index == self.Selected_index}) {
                        arr_file[row] = value
                    }
                    
                    self.table.reloadData()
                    
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
