//
//  TransactionsVC.swift
//  Almnabr
//
//  Created by MacBook on 02/10/2021.
//  Copyright © 2021 Samar Akkila. All rights reserved.
//

import UIKit
import DPLocalization
import FontAwesome_swift
import DropDown
import MOLH

class TransactionsVC: UIViewController {
    
    @IBOutlet weak var header: HeaderView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblsearchAdmin: UILabel!
    @IBOutlet weak var lblsearchByModule: UILabel!
    @IBOutlet weak var lblsearchByForm: UILabel!
    @IBOutlet weak var lblAllPending: UILabel!
    
    @IBOutlet weak var tableHeightConstraint:NSLayoutConstraint!
    
    @IBOutlet weak var viewsearchAdmin: UIView!
    @IBOutlet weak var viewsearchByModule: UIView!
    @IBOutlet weak var viewsearchByForm: UIView!
    @IBOutlet weak var viewsearchAllPending: UIView!
    @IBOutlet weak var viewsearch: UIView!
    
    @IBOutlet weak var imgDropAdmin: UIImageView!
    @IBOutlet weak var imgDropModule: UIImageView!
    @IBOutlet weak var imgDropForm: UIImageView!
    @IBOutlet weak var imgDropAllPending: UIImageView!
    
    @IBOutlet weak var imgnodata: UIImageView!
    
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var view_FilterAdmin: UIView!
    
    
    var StrTitle:String = ""
    var StrSubMenue:String = "My Transactions"
    var StrsearchByModule:String = ""
    var StrsearchByForm:String = ""
    var SearchKey:String = ""
    var SearchAllpending:String = "all_pending_need_action"
    var StrsearchByAdmin:Int = 0
    var pageNumber = 1
    var total:Int = 0
    var allItemDownloaded = false
    var MenuObj:MenuObj?
    var SubMenuObj:MenuObj?
    var arr_data:[Tcore] = []
    var arr_module:[ModuleObj] = []
    var arr_moduleLabel:[String] = []
    var arr_form:[ModuleObj] = []
    var arr_formeLabel:[String] = []
    var arr_Admin:[String] = ["Admin".localized(),"Users".localized()]
    var arr_AllPending:[String] = ["all_pending_need_action" , "all_pending","all_complete","all_sent"]
    var cellWidths: [CGFloat] = [1200]
    var arr_NoData:[String] = ["No items found".localized()]
    
    
    let fontStyle: FontAwesomeStyle = .solid
    
    let dropUpmage =  UIImage.fontAwesomeIcon(name: .chevronUp , style: .solid, textColor:  .gray, size: CGSize(width: 40, height: 40))
    
    let dropDownmage =  UIImage.fontAwesomeIcon(name: .chevronDown , style: .solid, textColor:  .gray, size: CGSize(width: 40, height: 40))
    
    private let kCellheaderReuse : String = "MyTransactionHeaderView"
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        configGUI()
        get_Transaction_data(showLoading: true, loadOnly: true)
        get_module()
        get_forms()
        header.btnAction = self.menu_select
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        configGUI()
        get_Transaction_data(showLoading: true, loadOnly: true)
      
        header.btnAction = self.menu_select
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
//        override func viewDidLayoutSubviews() {
//            tableHeightConstraint.constant = table.contentSize.height
//
//        }
    
    //MARK: - Config GUI
    //------------------------------------------------------
    func configGUI() {
        
        
        lblTitle.textColor =  "1A3665".getUIColor()
        lblTitle.font = .kufiRegularFont(ofSize: 17)
        lblTitle.text =  StrSubMenue
        
        self.imgnodata.isHidden = true
        
        self.viewsearch.setBorderGrayWidthCorner(1, 20)
        
        self.viewsearchAllPending.setBorderGrayWidthCorner(1, 20)
        self.lblAllPending.text =  "All pending need action".localized()
        self.lblAllPending.font = .kufiRegularFont(ofSize: 15)
        
        
        self.viewsearchByForm.setBorderGrayWidthCorner(1, 20)
        self.lblsearchByForm.text = "WIR"
        //"txt_searchByForm".localized()
        self.lblsearchByForm.font = .kufiRegularFont(ofSize: 15)
        
        // for first puplish
        self.viewsearchByForm.isUserInteractionEnabled = false
        self.StrsearchByForm = "FORM_WIR"
        
        
        self.viewsearchAdmin.setBorderGrayWidthCorner(1, 20)
        self.lblsearchAdmin.text =  "txt_searchAdmin".localized()
        self.lblsearchAdmin.font = .kufiRegularFont(ofSize: 15)
        
        self.viewsearchByModule.setBorderGrayWidthCorner(1, 20)
        self.lblsearchByModule.text =  "txt_searchByModule".localized()
        self.lblsearchByModule.font = .kufiRegularFont(ofSize: 15)
        
        self.imgDropAdmin.image = dropDownmage
        self.imgDropForm.image = dropDownmage
        self.imgDropModule.image = dropDownmage
        self.imgDropAllPending.image = dropDownmage
        
        
        
        table.dataSource = self
        table.delegate = self
        let nib = UINib(nibName: "MyTrannsactionTVCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: "MyTrannsactionTVCell")
        
        if userObj?.user_type_id == "1" {
            self.view_FilterAdmin.isHidden = false
        }else{
            self.view_FilterAdmin.isHidden = true
        }
        
    }
    
    
    
    
    
    
    func get_Transaction_data(showLoading: Bool, loadOnly: Bool){
        
        if showLoading {
            self.showLoadingActivity()
        }
        let search:String = SearchKey.replacingOccurrences(of: " ", with: "%20").trim()
        APIManager.sendRequestGetAuth(urlString: "/tc/list/\(pageNumber)/10?searchKey=\(search)&searchAdmin=\(StrsearchByAdmin)&searchByModule=\(StrsearchByModule)&searchByForm=\(StrsearchByForm)&searchByStatus=\(SearchAllpending)" ) { (response) in
            
            if self.pageNumber == 1 {
                self.arr_data.removeAll()
            }
            let status = response["status"] as? Bool
            let total = response["total"] as? Int
            if loadOnly {
                self.table.reloadData()
            }
            
            let page = response["page"] as? [String:Any]
            let list = response["list"] as? [String:Any]
            if status == true{
                self.total = total!
                
                if  let records = list!["records"] as? NSArray{
                    for i in records {
                        let dict = i as? [String:Any]
                        let obj = Tcore.init(dict!)
                        self.arr_data.append(obj)
                    }
                    
                    
                    let pageObj = PageObj(page!)
                    if records.count == 0 {
                        self.imgnodata.isHidden = false
                    }else{
                        self.imgnodata.isHidden = true
                    }
                    
                    if pageObj.total_pages > self.pageNumber {
                        self.allItemDownloaded = false
                    }else{
                        self.allItemDownloaded = true
                    }
                    self.table.isHidden = false
                    self.table.reloadData()
                    self.hideLoadingActivity()
                }
                
            }else{
                self.table.isHidden = true
                self.imgnodata.isHidden = false
                self.hideLoadingActivity()
                
            }
            
            
        }
    }
    
    
    func get_module(){
        
        self.showLoadingActivity()
        APIManager.sendRequestGetAuth(urlString: "tc/getmodulesmydoclist" ) { (response) in
            
            
            let status = response["status"] as? Bool
            if status == true{
                if  let list = response["list"] as? NSArray{
                    for i in list {
                        let dict = i as? [String:Any]
                        let obj = ModuleObj.init(dict!)
                        self.arr_module.append(obj)
                        self.arr_moduleLabel.append(obj.label)
                        
                    }
                    self.hideLoadingActivity()
                }
            }
            
            
        }
    }
    
    
    func get_forms(){
        
        self.showLoadingActivity()
        APIManager.sendRequestGetAuth(urlString: "tc/gettcmydoclist" ) { (response) in
            
            
            let status = response["status"] as? Bool
            if status == true{
                if  let list = response["list"] as? NSArray{
                    for i in list {
                        let dict = i as? [String:Any]
                        let obj = ModuleObj.init(dict!)
                        self.arr_form.append(obj)
                        // for echitem in obj{
                        self.arr_formeLabel.append(obj.label)
                        // }
                        
                    }
                    self.hideLoadingActivity()
                }
            }
            
            
        }
    }
    
    func menu_select(){
        let language =  MOLHLanguage.currentAppleLanguage()
        if language == "ar"{
            panel?.openRight(animated: true)
        }else{
            panel?.openLeft(animated: true)
        }
        
    }
    @objc func buttonMenuAction(sender: UIButton!) {
        let language =  MOLHLanguage.currentAppleLanguage()
        if language == "ar"{
            panel?.openRight(animated: true)
        }else{
            panel?.openLeft(animated: true)
        }
    }
    
   
    
    @IBAction func btnSearchAdmin_Click(_ sender: Any) {
        
        let vc :PickerVC = AppDelegate.mainSB.instanceVC()
        vc.arr_data =  arr_Admin
        vc.isModalInPresentation = true
        vc.modalPresentationStyle = .overFullScreen
        vc.definesPresentationContext = true
        vc.delegate = {name , index in
            
            if name == self.arr_Admin[index] {
                self.lblsearchAdmin.text =  name
                //let i =  self.arr_module[index].value
                if name == "Admin" {
                    self.StrsearchByAdmin = 1
                }else{
                    self.StrsearchByAdmin = 0
                }
                self.imgDropAdmin.image = self.dropDownmage
                self.get_Transaction_data(showLoading: true, loadOnly: true)
            }
          
           // self.sig_id = self.arr_sig_id[index].id
        }
        self.present(vc, animated: true, completion: nil)
        
        
        
//        self.imgDropAdmin.image = dropUpmage
//
//        let dropDown = DropDown()
//        dropDown.anchorView = view
//        dropDown.backgroundColor = .white
//        dropDown.cornerRadius = 2.0
//
//        if self.arr_Admin.count == 0 {
//            dropDown.dataSource = self.arr_NoData
//            dropDown.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//            self.imgDropAdmin.image = dropDownmage
//        }else{
//            dropDown.dataSource = self.arr_Admin
//            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//
//                if item == self.arr_Admin[index] {
//                    self.lblsearchAdmin.text =  item
//                    //let i =  self.arr_module[index].value
//                    if item == "Admin" {
//                        self.StrsearchByAdmin = 1
//                    }else{
//                        self.StrsearchByAdmin = 0
//                    }
//                    self.imgDropAdmin.image = dropDownmage
//                    self.get_Transaction_data(showLoading: true, loadOnly: true)
//                }
//
//            }}
//        dropDown.direction = .bottom
//        dropDown.anchorView = viewsearchAdmin
//        dropDown.bottomOffset = CGPoint(x: 0, y: viewsearchAdmin.bounds.height)
//        dropDown.width = viewsearchAdmin.bounds.width
//        dropDown.show()
    }
    
    
    
    @IBAction func btnSearchForm_Click(_ sender: Any) {
        
        self.imgDropForm.image = dropUpmage
        
        let vc :PickerVC = AppDelegate.mainSB.instanceVC()
        vc.arr_data =  arr_formeLabel
        vc.isModalInPresentation = true
        vc.modalPresentationStyle = .overFullScreen
        vc.definesPresentationContext = true
        vc.delegate = {name , index in
            if name == self.arr_formeLabel[index] {
                self.lblsearchByForm.text =  name
                let i =  self.arr_form[index].value
                self.StrsearchByForm = i
               
                self.imgDropForm.image = self.dropDownmage
                self.get_Transaction_data(showLoading: true, loadOnly: true)
            }
          
        }
        self.present(vc, animated: true, completion: nil)
        
        
//        let dropDown = DropDown()
//        dropDown.anchorView = view
//        dropDown.backgroundColor = .white
//        dropDown.cornerRadius = 2.0
//
//        if self.arr_formeLabel.count == 0 {
//            dropDown.dataSource = self.arr_NoData
//            dropDown.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//            self.imgDropForm.image = dropDownmage
//        }else{
//            dropDown.dataSource = self.arr_formeLabel
//            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//
//                if item == self.arr_formeLabel[index] {
//                    self.lblsearchByForm.text =  item
//                    let i =  self.arr_form[index].value
//                    self.StrsearchByForm = i
//                    self.imgDropForm.image = dropDownmage
//                    self.get_Transaction_data(showLoading: true, loadOnly: true)
//                }
//            }
//        }
//        dropDown.direction = .bottom
//        dropDown.anchorView = viewsearchByForm
//        dropDown.bottomOffset = CGPoint(x: 0, y: viewsearchByForm.bounds.height)
//        dropDown.width = viewsearchByForm.bounds.width
//        dropDown.show()
    }
    
    
    
    @IBAction func btnSearchModule_Click(_ sender: Any) {
        
        self.imgDropForm.image = dropUpmage
        let vc :PickerVC = AppDelegate.mainSB.instanceVC()
        vc.arr_data =  arr_moduleLabel
        vc.isModalInPresentation = true
        vc.modalPresentationStyle = .overFullScreen
        vc.definesPresentationContext = true
        vc.delegate = {name , index in
            if name == self.arr_moduleLabel[index] {
                self.lblsearchByModule.text =  name
                let i =  self.arr_module[index].value
                self.StrsearchByModule = i
                self.imgDropModule.image = self.dropDownmage
                self.get_Transaction_data(showLoading: true, loadOnly: true)
            }
        }
        self.present(vc, animated: true, completion: nil)
        
//        self.imgDropModule.image = dropUpmage
//        let dropDown = DropDown()
//        dropDown.anchorView = view
//        dropDown.backgroundColor = .white
//        dropDown.cornerRadius = 2.0
//        if self.arr_moduleLabel.count == 0 {
//            dropDown.dataSource = self.arr_NoData
//            dropDown.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//            self.imgDropModule.image = dropDownmage
//        }else{
//            dropDown.dataSource = self.arr_moduleLabel
//            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//
//                if item == self.arr_moduleLabel[index] {
//                    self.lblsearchByModule.text =  item
//                    let i =  self.arr_module[index].value
//                    self.StrsearchByModule = i
//                    self.imgDropModule.image = dropDownmage
//                    self.get_Transaction_data(showLoading: true, loadOnly: true)
//                }
//            }
//        }
//        dropDown.direction = .bottom
//        dropDown.anchorView = viewsearchByModule
//        dropDown.bottomOffset = CGPoint(x: 0, y: viewsearchByModule.bounds.height)
//        dropDown.width = viewsearchByModule.bounds.width
//        dropDown.show()
    }
    
    
    @IBAction func btnSearchAllPending_Click(_ sender: Any) {
        
        self.imgDropForm.image = dropUpmage
        let vc :PickerVC = AppDelegate.mainSB.instanceVC()
        vc.arr_data =  arr_AllPending
        vc.isModalInPresentation = true
        vc.modalPresentationStyle = .overFullScreen
        vc.definesPresentationContext = true
        vc.delegate = {name , index in
            if name == self.arr_AllPending[index] {
                self.lblAllPending.text =  name
                // let i =  self.arr_module[index].value
                self.SearchAllpending = name
                self.imgDropAllPending.image = self.dropDownmage
                self.get_Transaction_data(showLoading: true, loadOnly: true)
            }
        }
        self.present(vc, animated: true, completion: nil)
        
//        self.imgDropAllPending.image = dropUpmage
//        let dropDown = DropDown()
//        dropDown.anchorView = view
//        dropDown.backgroundColor = .white
//        dropDown.cornerRadius = 2.0
//        if self.arr_AllPending.count == 0 {
//            dropDown.dataSource = self.arr_NoData
//            dropDown.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//            self.imgDropAllPending.image = dropDownmage
//        }else{
//            dropDown.dataSource = self.arr_AllPending
//            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//
//                if item == self.arr_AllPending[index] {
//                    self.lblAllPending.text =  item
//                    // let i =  self.arr_module[index].value
//                    self.SearchAllpending = item
//                    self.imgDropAllPending.image = dropDownmage
//                    self.get_Transaction_data(showLoading: true, loadOnly: true)
//                }
//            }
//        }
//        dropDown.direction = .bottom
//        dropDown.anchorView = viewsearchAllPending
//        dropDown.bottomOffset = CGPoint(x: 0, y: viewsearchAllPending.bounds.height)
//        dropDown.width = viewsearchAllPending.bounds.width
//        dropDown.show()
    }
    
    
}


extension TransactionsVC: UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTrannsactionTVCell", for: indexPath) as! MyTrannsactionTVCell
        
        let obj = arr_data[indexPath.item]
        
        
        let Id = "\(obj.transaction_request_id)"
        let Description = "Description".localized() + "  \(obj.transaction_request_description)"
        let from = "From".localized() + ":  \(obj.transaction_from_name)"
        let to = "To".localized() + ":  \(obj.transaction_to_name)"
        let barcode = "  \(obj.barcode)"
        //"Barcode".localized() +
        let type = "Type".localized() + ":  \(obj.transactions_type_name)"
        let Module = "Module".localized() + ":  \(obj.module_name)"
        let Form = "Form".localized() + ":  \(obj.transactions_name)"
        let writer = "By".localized() + ":  \(obj.transaction_request_user_name_writer)"
        let Submitter = "Submitter".localized() + ":  \(obj.transactions_submitter_user_name)"
        let LastUpdate =  "\(obj.transactions_date_last_update)"
        let Status = "\(obj.transaction_request_status)"
        
        
        let maincolor = "#1A3665".getUIColor()
       
        cell.lblNo.text = Id
        
        let Descattribute: NSAttributedString = Description.attributedStringWithColor(["Description".localized()], color: maincolor)
        cell.lblDesc.attributedText = Descattribute
        
        let fromattributed: NSAttributedString = from.attributedStringWithColor(["From".localized()], color: maincolor)
        cell.lblFrom.attributedText = fromattributed
        
        let Toattributed: NSAttributedString = to.attributedStringWithColor(["To".localized()], color: maincolor)
        cell.lblTo.attributedText = Toattributed
        
        
        cell.lblBarCode.text = barcode
        
        let Typeattributed: NSAttributedString = type.attributedStringWithColor(["Type".localized()], color: maincolor)
        cell.lblType.attributedText = Typeattributed
        
        
        let Moduleattributed: NSAttributedString = Module.attributedStringWithColor(["Module".localized()], color: maincolor)
        cell.lblModule.attributedText = Moduleattributed
        
        let Formattributed: NSAttributedString = Form.attributedStringWithColor(["Form".localized()], color: maincolor)
        cell.lblForm.attributedText = Formattributed
        
        let writerattributed: NSAttributedString = writer.attributedStringWithColor(["By".localized()], color: maincolor)
        cell.lblWriter.attributedText = writerattributed
        
        let Submitterattributed: NSAttributedString = Submitter.attributedStringWithColor(["Submitter".localized()], color: maincolor)
        cell.lblSubmitter.attributedText = Submitterattributed
        
        cell.lblLastUpdate.text = LastUpdate
        
        let Statusattributed: NSAttributedString = Status.attributedStringWithColor(["Status".localized()], color: maincolor)
        cell.lblStatus.attributedText = Statusattributed
        
        
//        cell.viewBack.setcorner()
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.tag == 0 {
            
            print(indexPath.section)
            if indexPath.row   == arr_data.count - 1  {
                
                updateNextSet()
                print("next step")
                
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        
        print("Selected rows after selection: ", tableView.indexPathsForSelectedRows?.count ?? 0)
        let obj = self.arr_data[indexPath.item]
        
        let vc : TransactionFormDetailsVC = AppDelegate.TransactionSB.instanceVC()
        vc.Object = obj
        //vc.filePath = obj.url
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func updateNextSet(){
        print("On Completetion")
        if !allItemDownloaded {
            pageNumber = pageNumber + 1
            get_Transaction_data(showLoading: false, loadOnly: false)
        }
    }
}


extension TransactionsVC:UISearchBarDelegate {
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.SearchKey = searchBar.text!
        get_Transaction_data(showLoading: false, loadOnly: false)
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
}
