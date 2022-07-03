//
//  AddPointVC.swift
//  Almnabr
//
//  Created by MacBook on 28/06/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import UIKit
import DropDown

class AddPointVC: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var lblCheckList: UILabel!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet var view_title: UIView!
    
    @IBOutlet weak var lblProgress: UILabel!
    @IBOutlet weak var tfProgress: UITextField!
    @IBOutlet var view_Progress: UIView!
    
    @IBOutlet weak var lblHours: UILabel!
    @IBOutlet weak var tfHours: UITextField!
    @IBOutlet var view_Hours: UIView!
    
    @IBOutlet var viewDetails: UIView!
    @IBOutlet weak var txtDetails: UITextView!
    
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
   
    @IBOutlet weak var lblAttachments: UILabel!
    @IBOutlet weak var tfUsers: UITextField!
    @IBOutlet weak var lblUsers: UILabel!
    @IBOutlet weak var imgUsers: UIImageView!
    
    @IBOutlet weak var tfStartDate: UITextField!
    @IBOutlet weak var tfEndDate: UITextField!
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet var tableHeight: NSLayoutConstraint!
    @IBOutlet var view_users: UIView!
    @IBOutlet var Viewcollection_user: UIView!
    @IBOutlet var collection_user: UICollectionView!
    
    
    var delegate : (() -> Void)?
    var point_id:String = ""
    
    
    let dropUpmage =  UIImage.fontAwesomeIcon(name: .chevronUp , style: .solid, textColor:  .gray, size: CGSize(width: 40, height: 40))
    let dropDownmage =  UIImage.fontAwesomeIcon(name: .chevronDown , style: .solid, textColor:  .gray, size: CGSize(width: 40, height: 40))
     
    var arr_Attachments:[attachment] = []
    var arr_NoData:[String] = ["No items found".localized()]
    var arr_user :[SupplierObj] = []
    var arr_selected_user :[SupplierObj] = []
    var arr_lbluser :[String] = []
    
    var Selected_index:Int = 0
    
    var param = [:] as [String : String]
    var Attachments_index:Int = 0
    var isCheckList:Bool = false
     
    var strTitle:String = ""
    
    let imagePickerController = UIImagePickerController()
    var documentInteractionController: UIDocumentPickerViewController? = nil
    
    let datePicker = UIDatePicker()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configGUI()
        createDatePicker()
        createEndDatePicker()
        configNavigation()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Config Navigation
    func configNavigation() {
        
        _ = self.navigationController?.preferredStatusBarStyle
        self.view.backgroundColor = maincolor //F0F4F8
        //navigationController?.navigationBar.barTintColor = .buttonBackgroundColor()
        navigationController?.navigationBar.barTintColor = maincolor
       addNavigationBarTitle(navigationTitle: "Checklist Item".localized())
        UINavigationBar.appearance().backgroundColor = maincolor
    }
    
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tableHeight?.constant = self.table.contentSize.height
        
    }
    
    
    //MARK: - Config GUI
    //------------------------------------------------------
    func configGUI() {
        
        self.lblTitle.font = .kufiRegularFont(ofSize: 14)
        self.lblTitle.text = "Point Title".localized()
        self.tfTitle.placeholder = "Point Title".localized()
        
        self.lblCheckList.font = .kufiBoldFont(ofSize: 15)
        self.lblCheckList.text = "Checklist Item".localized()
        
        self.lblProgress.font = .kufiRegularFont(ofSize: 14)
        self.lblProgress.text = "Point Progress".localized()
        self.tfProgress.placeholder = "Point Progress".localized()
        
        self.lblHours.font = .kufiRegularFont(ofSize: 14)
        self.lblHours.text = "Hours".localized()
        self.tfHours.placeholder = "Hours".localized()
        
        self.txtDetails.text = ""
        txtDetails.delegate = self
        
        txtDetails.text = "Details".localized()
        txtDetails.font = .kufiRegularFont(ofSize: 14)
        txtDetails.textColor = .lightGray
        
        self.viewDetails.setBorderGray()
        self.view_title.setBorderGray()
        self.view_Progress.setBorderGray()
        self.view_Hours.setBorderGray()
        
        self.tfTitle.font = .kufiRegularFont(ofSize: 15)
        
        
//        self.btnAdd.setTitle("Save".localized(), for: .normal)
//        self.btnAdd.backgroundColor =  maincolor
//        self.btnAdd.setTitleColor(.white, for: .normal)
//        self.btnAdd.setRounded(10)
//        self.btnAdd.titleLabel?.font = .kufiRegularFont(ofSize: 14)
//
//        self.btnCancel.setTitle("Cancel".localized(), for: .normal)
//        self.btnCancel.backgroundColor =  maincolor
//        self.btnCancel.setTitleColor(.white, for: .normal)
//        self.btnCancel.setRounded(10)
//        self.btnCancel.titleLabel?.font = .kufiRegularFont(ofSize: 14)
        
        self.lblAttachments.font = .kufiRegularFont(ofSize: 15)
        self.lblAttachments.text = "Attachments".localized()
        
        self.imgUsers.image = dropDownmage
        self.lblUsers.font = .kufiRegularFont(ofSize: 15)
        self.lblUsers.text = "Users".localized()
        self.tfUsers.placeholder = "Users".localized()
        
        self.tfStartDate.font = .kufiRegularFont(ofSize: 15)
        self.tfStartDate.placeholder = "Start Date".localized()
        
        self.tfEndDate.font = .kufiRegularFont(ofSize: 15)
        self.tfEndDate.placeholder = "End Date".localized()
        
        table.delegate = self
        table.dataSource = self
        
        self.tfUsers.delegate = self
        self.imagePickerController.delegate = self
        
        table.register(UINib(nibName: "AttachmentsCell", bundle: nil), forCellReuseIdentifier: "AttachmentsCell")
       
        table.isHidden = true
        
    }
    
    func createDatePicker(){
          
          let toolbar = UIToolbar()
          toolbar.sizeToFit()
      
        datePicker.datePickerMode = .date
          let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
          toolbar.setItems([doneBtn], animated: true)
        toolbar.backgroundColor = .white
        tfStartDate.inputAccessoryView = toolbar
        tfStartDate.inputView = datePicker
      }
    
    
    @objc func donePressed(){
         
        tfStartDate.text = "\(datePicker.date.asStringyyyMMdd())"
        self.view.endEditing(true)
//        if tfTotalDays.text != ""{
//            let value = Int(tfTotalDays.text ?? "0") ?? 0
//            let DayFromNow = Calendar.current.date(byAdding: .day, value: value , to: datePicker.date)
//            print(DayFromNow)
//            self.tfEndDate.text = DayFromNow?.asStringyyyMMdd()
//        }
     }

    
    
    func createEndDatePicker(){
          
          let toolbar = UIToolbar()
          toolbar.sizeToFit()
        datePicker.datePickerMode = .date
          
          let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneEndDatePressed))
          toolbar.setItems([doneBtn], animated: true)
        toolbar.backgroundColor = .white
        tfEndDate.inputAccessoryView = toolbar
        tfEndDate.inputView = datePicker
      }
    
    
    @objc func doneEndDatePressed(){
        
        tfEndDate.text = "\(datePicker.date.asStringyyyMMdd())"
        self.view.endEditing(true)
     }
    
    
    
    func get_user(search_key:String){

        var param :[String:Any] = [:]
        self.showLoadingActivity()
        APIManager.sendRequestGetAuth(urlString: "tc/getformuserslist?search=\(search_key)&lang_key=en&user_type_id=\(Auth_User.user_type_id)" ) { (response) in
            
            let status = response["status"] as? Bool
            if status == true{
                self.arr_user = []
                self.arr_lbluser = []
                if  let list = response["list"] as? NSArray{
                    for i in list {
                        let dict = i as? [String:Any]
                        let obj = SupplierObj.init(dict!)
                        self.arr_user.append(obj)
                        self.arr_lbluser.append(obj.label)
                        self.drop_userList()
                        
                    }
                    self.hideLoadingActivity()
                }
            }else {
                self.hideLoadingActivity()
            }
            
        }
    }

    
    
    func drop_userList(){
        let dropDown = DropDown()
        
            if self.arr_user.count == 0 {
                dropDown.dataSource = self.arr_NoData
                dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                   // self.imgDropMaterial.image = dropDownmage
                }
                dropDown.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            }else{
                
                dropDown.textColor = #colorLiteral(red: 0.1878142953, green: 0.1878142953, blue: 0.1878142953, alpha: 1)
                dropDown.dataSource = self.arr_lbluser
                dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                    
                    if item == self.arr_lbluser[index] {
                        let object =  self.arr_user[index]
                        let has_object = arr_selected_user.contains(where: { $0.label == item })
                        if has_object == false{
                            self.arr_selected_user.append(object)
                            self.Viewcollection_user.isHidden = false
                            self.collection_user.reloadData()
                        }
                    }
                    
                }

            }
            dropDown.direction = .bottom
            dropDown.anchorView = view_users
            dropDown.bottomOffset = CGPoint(x: 0, y: view_users.bounds.height)
            dropDown.width = view_users.bounds.width
            dropDown.show()
     
    }
   
    
    func add_point(){
        
        self.showLoadingActivity()
        
        APIManager.sendRequestPostAuth(urlString: "tasks/insert_task_points", parameters: self.param ) { (response) in
            self.hideLoadingActivity()
           
            let status = response["status"] as? Bool
            if status == true{
                if let message = response["message"] as? String {
                    self.showAMessage(withTitle: "", message: message,  completion: {
                            self.delegate!()
                            self.dismiss(animated: true)
                    })
                }
             
            }else{
                self.hideLoadingActivity()
              
            }
        }
    }
    
    
    func Submit_request(){
      
  
        for i in arr_Attachments {
            
            let urlStr = i.url
            let img = i.img
                 
            if (urlStr == nil && img == nil) {
                showAMessage(withTitle: "error".localized(), message: "Please enter your file".localized())
                return
            }else{
                for i in arr_Attachments {
                    self.param["attachments[\(i.index - 1)][attach_title]"] = i.title
                }
            }
        }
                showLoadingActivity()
              
                let Url = "tasks/insert_task_points"
             
                APIManager.func_Upload(queryString: Url, arr_Attachments, param: self.param ) { (respnse ) in
                    
                    let status = respnse["status"] as? Bool
                    let errors = respnse["error"] as? String

                    
                    if status == true{
                        if let message = respnse["message"] as? String {
                            self.showAMessage(withTitle: "", message: message,  completion: {
                                    self.delegate!()
                                    self.dismiss(animated: true)
                            })
                        }
                    }else{
                        
                        self.hideLoadingActivity()
                        self.showAMessage(withTitle: "error".localized(), message: errors ?? "something went wrong")
                    }
                    self.hideLoadingActivity()
                    
                    
                }    }

    
    
    
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
    
    @IBAction func btnCancel_Click(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSubmit_Click(_ sender: Any) {
        
        guard tfTitle.text != "" else {
            return self.showAMessage(withTitle: "", message: "Item title Field Required!")
        }
        
        self.param["point_id"] = self.point_id
        self.param["points[0][title]"] = tfTitle.text!
        self.param["points[0][prg_done]"] = tfProgress.text ?? ""
        self.param["points[0][start_date]"] = tfStartDate.text ?? ""
        self.param["points[0][end_date]"] = tfEndDate.text ?? ""
        self.param["points[0][more_details]"] = txtDetails.text ?? ""
        self.param["points[0][hour_no]"] = tfHours.text ?? ""
  
        var users = ""
        for i in arr_selected_user{
            if arr_selected_user.count > 1 {
                users = i.value  + "," + users
            }else{
                users =  i.value
            }
        }
        self.param["users"] = users
        
        
        if arr_Attachments.count == 0 {
            self.add_point()
        }else{
            Submit_request()
        }
        
    }
    
    @IBAction func btnAddAttach_Click(_ sender: Any) {
        table.isHidden = false
        var is_nil = false
        for i in arr_Attachments {
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
            
            let new_index = arr_Attachments.count + 1
            self.arr_Attachments.append(attachment(title: "", Required: "No", img: nil, url: nil,type: "file", index: new_index ,IsNew: true))
          
            self.table.beginUpdates()
            self.table.insertRows(at: [IndexPath.init(row: self.arr_Attachments.count-1, section: 0)], with: .automatic)
            self.table.endUpdates()
        }
        
    }
    
    
}

extension AddPointVC: UITextViewDelegate {
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtDetails.textColor == .lightGray {
            txtDetails.text = ""
            txtDetails.textColor = .darkGray
            txtDetails.font = .kufiRegularFont(ofSize: 15)
            
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
            if txtDetails.text == "" {
                
                txtDetails.text = "Details".localized()
                txtDetails.font = .kufiRegularFont(ofSize: 15)
                txtDetails.textColor = .lightGray
            }
      
    }
    
    
    
    
}





extension AddPointVC: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          
        return arr_Attachments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AttachmentsCell", for: indexPath) as! AttachmentsCell
        
        cell.backgroundColor = .clear
        let obj = arr_Attachments[indexPath.item]
        
        
        if (obj.img != nil || obj.url != nil) {
            cell.btn_Select.tintColor = "#3ea832".getUIColor()
        }else{
            cell.btn_Select.tintColor = HelperClassSwift.acolor.getUIColor()
        }
        cell.lblNo.font = .kufiRegularFont(ofSize: 13)
        cell.tfTitle.placeholder = "Description".localized()
        cell.lblNo.text = "# \(indexPath.item + 1)"
        
        cell.btn_delete.isHidden = false
        
        
        cell.tfTitle.isUserInteractionEnabled = true
        
        self.Attachments_index = obj.index
        cell.tfTitle.delegate = self
        
        
        cell.btnDeleteAction = {
            self.arr_Attachments.remove(at: indexPath.item)
            self.table.reloadData()
            if self.arr_Attachments.count == 0 {
                self.table.isHidden = true
            }
            
        }
        
        cell.btnUploadAction = {
            
            self.Selected_index = obj.index
            self.Upload_file()
        }
        cell.btnEndEditingAction = {
            self.arr_Attachments[indexPath.item].title = cell.tfTitle.text ?? ""
        }
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
}



extension AddPointVC : UITextFieldDelegate{
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == tfUsers {
            self.view_users.setBorderWithColor("2D7FC1".getUIColor())
            //self.drop_material_list()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if #available(iOS 15, *) {
            if textField == tfUsers {
                if tfUsers.text == "" {
                    self.view_users.setBorderWithColor(.clear)
                    
                }else{
                    self.view_users.setBorderWithColor(.clear)
                    get_user(search_key: tfUsers.text!)
                }
                
            }
            
        } else {
            // Fallback on earlier versions
        }
        
        
    }
}



extension AddPointVC: UICollectionViewDataSource ,UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
            return arr_selected_user.count
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "unitCVCell", for: indexPath) as! unitCVCell
        
            let arr = arr_selected_user.map({"\($0.label)"})
            cell.lblTitle.text = arr[indexPath.row]
            cell.viewBack.setBorderWithColor("458FB8".getUIColor())
            cell.lblTitle.font = .kufiRegularFont(ofSize: 13)
            
            cell.btnDeleteAction = {
              
                self.arr_selected_user.remove(at: indexPath.item)
                self.collection_user.reloadData()
                if self.arr_user.count == 0 {
                    self.Viewcollection_user.isHidden = true
                }
                
            }
            
            return cell
      
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
       // cell.view_img.backgroundColor = HelperClassSwift.acolor.getUIColor()
        
    }
}


extension AddPointVC : UIImagePickerControllerDelegate  {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        if let image = (info[.originalImage] as? UIImage){
            
            if let row = self.arr_Attachments.firstIndex(where: {$0.index == self.Selected_index}) {
                 
                arr_Attachments[row].type = "img"
                arr_Attachments[row].img = image
                arr_Attachments[row].url = nil
                self.table.reloadData()
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


extension AddPointVC: UIDocumentPickerDelegate {
    
    
    
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
                    
                    if let row = self.arr_Attachments.firstIndex(where: {$0.index == self.Selected_index}) {
                        
                        arr_Attachments[row].type = "file"
                        arr_Attachments[row].img = nil
                        arr_Attachments[row].url = url
                        self.table.reloadData()
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

