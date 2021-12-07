//
//  ApproveTransactionVC.swift
//  Almnabr
//
//  Created by MacBook on 04/10/2021.
//  Copyright © 2021 Samar Akkila. All rights reserved.
//

    import UIKit
    import DPLocalization
    import FontAwesome_swift
    import DropDown

    class ApproveTransactionVC: UIViewController {

        @IBOutlet weak var viewTheme: UIView!
        @IBOutlet weak var btnMenu: UIView!
        @IBOutlet weak var imgNext1: UIImageView!
        @IBOutlet weak var imgNext2: UIImageView!
        
        @IBOutlet weak var lblHome: UIButton!
        @IBOutlet weak var lblMenuName: UILabel!
        @IBOutlet weak var lblSubMenuName: UILabel!
        @IBOutlet weak var lblTitle: UILabel!
        
        @IBOutlet weak var lblnodata: UILabel!
        
        @IBOutlet weak var lblsearchAdmin: UILabel!
        @IBOutlet weak var lblsearchByModule: UILabel!
        @IBOutlet weak var lblsearchByForm: UILabel!
        
        
        @IBOutlet weak var viewsearchAdmin: UIView!
        @IBOutlet weak var viewsearchByModule: UIView!
        @IBOutlet weak var viewsearchByForm: UIView!
     
        @IBOutlet weak var imgDropAdmin: UIImageView!
        @IBOutlet weak var imgDropModule: UIImageView!
        @IBOutlet weak var imgDropForm: UIImageView!
        
        
        @IBOutlet weak var mainView: UIView!
        @IBOutlet weak var table: UITableView!
        
        @IBOutlet weak var collection: UICollectionView!
        
        @IBOutlet weak var header: HeaderView!
        
        @IBOutlet weak var searchBar: UISearchBar!
        
        var StrTitle:String = ""
        var StrSubMenue:String = ""
        var StrsearchByModule:String = ""
        var StrsearchByForm:String = ""
        var searchByTypeOfApproval:String = ""
        var SearchKey:String = ""
        var pageNumber = 1
        var allItemDownloaded = false
        var MenuObj:MenuObj?
        var SubMenuObj:MenuObj?
        var arr_data:[Tcore] = []
        var arr_module:[ModuleObj] = []
        var arr_moduleLabel:[String] = []
        var arr_form:[ModuleObj] = []
        var arr_formeLabel:[String] = []
        var arr_Admin:[String] = ["All".localized(),"Manual".localized(),"Auto".localized()]
        var cellWidths: [CGFloat] = [1200]
        var arr_NoData:[String] = ["No items found".localized()]
        
        let fontStyle: FontAwesomeStyle = .solid
        
        let dropUpmage =  UIImage.fontAwesomeIcon(name: .chevronUp , style: .solid, textColor:  .gray, size: CGSize(width: 40, height: 40))
        
        let dropDownmage =  UIImage.fontAwesomeIcon(name: .chevronDown , style: .solid, textColor:  .gray, size: CGSize(width: 40, height: 40))
        
        
        override public func viewDidLoad() {
            super.viewDidLoad()
            configGUI()
            get_Transaction_data(showLoading: true, loadOnly: true)
            get_module()
            get_forms()
            header.btnAction = {
                    () in
                self.menu_select()
            }
        }
        
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            // Hide the Navigation Bar
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            // Show the Navigation Bar
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
        
        // MARK: - Config Navigation
        func configNavigation() {
            _ = self.navigationController?.preferredStatusBarStyle
            self.view.backgroundColor = "FFFFFF".getUIColor() //F0F4F8
            navigationController?.navigationBar.barTintColor = .red
            
            addNavigationBarTitle(navigationTitle: StrTitle)
        }
        
        
        //MARK: - Config GUI
        //------------------------------------------------------
        func configGUI() {
     
            
            lblHome.titleLabel?.textColor =  HelperClassSwift.bcolor.getUIColor()
            lblHome.titleLabel?.font = .kufiRegularFont(ofSize: 15)
            
            lblMenuName.textColor =  HelperClassSwift.acolor.getUIColor()
            lblMenuName.font = .kufiRegularFont(ofSize: 15)
            
            lblTitle.textColor =  HelperClassSwift.acolor.getUIColor()
            lblTitle.font = .kufiBoldFont(ofSize: 15)
            
            self.lblnodata.text =  "txt_NoData".localized()
            self.lblnodata.font = .kufiRegularFont(ofSize: 15)
            self.lblnodata.isHidden = true
            
            
            lblSubMenuName.textColor =  HelperClassSwift.acolor.getUIColor()
            lblSubMenuName.font = .kufiRegularFont(ofSize: 15)
            
           
            self.lblHome.titleLabel?.text =  "txt_Home".localized()
            self.lblHome.titleLabel?.font = .kufiRegularFont(ofSize: 15)
          
            self.viewsearchByForm.setBorderGray()
            self.lblsearchByForm.text =  "txt_searchByForm".localized()
            self.lblsearchByForm.font = .kufiRegularFont(ofSize: 15)
            
            self.viewsearchAdmin.setBorderGray()
            self.lblsearchAdmin.text =  "txt_searchAll".localized()
            self.lblsearchAdmin.font = .kufiRegularFont(ofSize: 15)
            
            self.viewsearchByModule.setBorderGray()
            self.lblsearchByModule.text =  "txt_searchByModule".localized()
            self.lblsearchByModule.font = .kufiRegularFont(ofSize: 15)
            
            self.imgDropAdmin.image = dropDownmage
            self.imgDropForm.image = dropDownmage
            self.imgDropModule.image = dropDownmage
            
            
            searchBar.delegate = self
            self.mainView.setBorderGray()
            
            self.lblMenuName.text =  MenuObj?.menu_name
            self.lblSubMenuName.text =  StrSubMenue
            self.lblTitle.text =  StrSubMenue
            
            let nextimage =  UIImage.fontAwesomeIcon(name: .angleRight, style: self.fontStyle, textColor: HelperClassSwift.bcolor.getUIColor(), size: CGSize(width: 40, height: 40))
            self.imgNext1.image = nextimage
            self.imgNext2.image = nextimage
            
            table.dataSource = self
            table.delegate = self
            let nib = UINib(nibName: "TransactionTVCell", bundle: nil)
            table.register(nib, forCellReuseIdentifier: "TransactionTVCell")
         
        }
        

        
        
        
        func get_Transaction_data(showLoading: Bool, loadOnly: Bool){
            
            if showLoading {
                self.showLoadingActivity()
            }
            
            let search:String = SearchKey.replacingOccurrences(of: " ", with: "%20").trim()
            
           // &searchByModule=&searchByForm=&searchByTypeOfApproval=
            APIManager.sendRequestGetAuth(urlString: "tc/myapprovaldoclist/1/10?searchKey=\(search)&searchByTypeOfApproval=\(searchByTypeOfApproval)&searchByModule=\(StrsearchByModule)&searchByForm=\(StrsearchByForm)" ) { (response) in
                
                if self.pageNumber == 1 {
                    self.arr_data.removeAll()
                }
                let status = response["status"] as? Bool
                if loadOnly {
                    self.table.reloadData()
                }
                
             
                let page = response["page"] as? [String:Any]
                let list = response["list"] as? [String:Any]
                if status == true{
                    if  let records = list!["records"] as? NSArray{
                        for i in records {
                            let dict = i as? [String:Any]
                            let obj = Tcore.init(dict!)
                            self.arr_data.append(obj)
                        }
                        let pageObj = PageObj(page!)
                        if records.count == 0 {
                            self.lblnodata.isHidden = false
                        }else{
                            self.lblnodata.isHidden = true
                        }
                        if pageObj.total_pages > self.pageNumber {
                            self.allItemDownloaded = false
                        }else{
                            self.allItemDownloaded = true
                        }
                        self.table.reloadData()
                        self.hideLoadingActivity()
                    }
                    
                }else{
                    self.hideLoadingActivity()
                    self.lblnodata.isHidden = false
                 
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
                           // for echitem in obj{
                                self.arr_moduleLabel.append(obj.label)
                           // }
                             
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
            let language = dp_get_current_language()
            if language == "ar"{
                panel?.openRight(animated: true)
            }else{
                panel?.openLeft(animated: true)
            }
      
        }
    
        
        @IBAction func btnSearchAdmin_Click(_ sender: Any) {
            
            self.imgDropAdmin.image = dropUpmage
           
            let dropDown = DropDown()
            dropDown.anchorView = view
            dropDown.backgroundColor = .white
            dropDown.cornerRadius = 2.0
      
            if self.arr_Admin.count == 0 {
                dropDown.dataSource = self.arr_NoData
                dropDown.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                self.imgDropAdmin.image = dropDownmage
            }else{
           dropDown.dataSource = self.arr_Admin
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                
                if item == self.arr_Admin[index] {
                    self.lblsearchAdmin.text =  item
                    self.searchByTypeOfApproval = item
                    self.imgDropAdmin.image = dropDownmage
                    get_Transaction_data(showLoading: true, loadOnly: true)
                }
                
            }}
            dropDown.direction = .bottom
            dropDown.anchorView = viewsearchAdmin
            dropDown.bottomOffset = CGPoint(x: 0, y: viewsearchAdmin.bounds.height)
            dropDown.width = viewsearchAdmin.bounds.width
            dropDown.show()
        }
        
        
        
        @IBAction func btnSearchForm_Click(_ sender: Any) {
            
            self.imgDropForm.image = dropUpmage
            
            let dropDown = DropDown()
            dropDown.anchorView = view
            dropDown.backgroundColor = .white
            dropDown.cornerRadius = 2.0
      
            if self.arr_formeLabel.count == 0 {
                dropDown.dataSource = self.arr_NoData
                dropDown.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                self.imgDropForm.image = dropDownmage
            }else{
            dropDown.dataSource = self.arr_formeLabel
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                
                if item == self.arr_formeLabel[index] {
                    self.lblsearchByForm.text =  item
                    let i =  self.arr_form[index].value
                        self.StrsearchByForm = i
                    self.imgDropForm.image = dropDownmage
                    get_Transaction_data(showLoading: true, loadOnly: true)
                }
            }
            }
            dropDown.direction = .bottom
            dropDown.anchorView = viewsearchByForm
            dropDown.bottomOffset = CGPoint(x: 0, y: viewsearchByForm.bounds.height)
            dropDown.width = viewsearchByForm.bounds.width
            dropDown.show()
        }
        
        
        
        @IBAction func btnSearchModule_Click(_ sender: Any) {
            
            self.imgDropModule.image = dropUpmage
            let dropDown = DropDown()
            dropDown.anchorView = view
            dropDown.backgroundColor = .white
            dropDown.cornerRadius = 2.0
      
            if self.arr_moduleLabel.count == 0 {
                dropDown.dataSource = self.arr_NoData
                dropDown.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                self.imgDropModule.image = dropDownmage
            }else{
            dropDown.dataSource = self.arr_moduleLabel
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                
                if item == self.arr_moduleLabel[index] {
                    self.lblsearchByModule.text =  item
                    let i =  self.arr_module[index].value
                        self.StrsearchByModule = i
                    self.imgDropModule.image = dropDownmage
                    get_Transaction_data(showLoading: true, loadOnly: true)
                }
            }
            }
            dropDown.direction = .bottom
            dropDown.anchorView = viewsearchByModule
            dropDown.bottomOffset = CGPoint(x: 0, y: viewsearchByModule.bounds.height)
            dropDown.width = viewsearchByModule.bounds.width
            dropDown.show()
        }

        
    }

 



extension ApproveTransactionVC: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTVCell", for: indexPath) as! TransactionTVCell
        
        let obj = arr_data[indexPath.item]
        
        
        let no =  "No.".localized() + "  \(obj.transaction_request_id)"
        let Description = "Description".localized() + "  \(obj.transaction_request_description)"
        let from = "from".localized() + "  \(obj.transaction_from_name)"
        let to = "To".localized() + "  \(obj.transaction_to_name)"
        let type = "Type".localized() + "  \(obj.transactions_type_name)"
        let Module = "Module".localized() + "  \(obj.module_name)"
        let writer = "Writer".localized() + "  \(obj.transaction_request_user_name_writer)"
        let Submitter = "Transaction Date".localized() + "  \(obj.create_datetime)"
        let LastUpdate = "Approval Type".localized() + "  \(obj.transaction_request_type_of_approval)"
        
        cell.lbKeylNo.text = no
        cell.lblKeyDesc.text = Description
        cell.lblKeyFrom.text = from
        cell.lblKeyTo.text = to
        cell.lblKeyType.text = type
        cell.lblKeyModule.text = Module
        cell.lblKeyWriter.text = writer
        cell.lblKeySubmitter.text = Submitter
        cell.lblKeyLastUpdate.text = LastUpdate
        
        cell.lblKeyBarCode.isHidden = true
        cell.lblKeyStatus.isHidden = true
       
        let attributedWithTextColor: NSAttributedString = no.attributedStringWithColor(["No."], color: HelperClassSwift.acolor.getUIColor())
        cell.lbKeylNo.attributedText = attributedWithTextColor
        
        let Descriptionattributed: NSAttributedString = Description.attributedStringWithColor(["Description"], color: HelperClassSwift.acolor.getUIColor())
        cell.lblKeyDesc.attributedText = Descriptionattributed
        
        let fromattributed: NSAttributedString = from.attributedStringWithColor(["from"], color: HelperClassSwift.acolor.getUIColor())
        cell.lblKeyFrom.attributedText = fromattributed
        
        let Toattributed: NSAttributedString = to.attributedStringWithColor(["To".localized()], color: HelperClassSwift.acolor.getUIColor())
        cell.lblKeyTo.attributedText = Toattributed
        
        
       
        let Typeattributed: NSAttributedString = type.attributedStringWithColor(["Type".localized()], color: HelperClassSwift.acolor.getUIColor())
        cell.lblKeyType.attributedText = Typeattributed
        
        
        let Moduleattributed: NSAttributedString = Module.attributedStringWithColor(["Module".localized()], color: HelperClassSwift.acolor.getUIColor())
        cell.lblKeyModule.attributedText = Moduleattributed
        
        let Writerattributed: NSAttributedString = writer.attributedStringWithColor(["Writer".localized()], color: HelperClassSwift.acolor.getUIColor())
        cell.lblKeyWriter.attributedText = Writerattributed
        
        let Submitterattributed: NSAttributedString = Submitter.attributedStringWithColor(["Transaction Date".localized()], color: HelperClassSwift.acolor.getUIColor())
        cell.lblKeySubmitter.attributedText = Submitterattributed
        
        let Lastattributed: NSAttributedString = LastUpdate.attributedStringWithColor(["Approval Type".localized()], color: HelperClassSwift.acolor.getUIColor())
        cell.lblKeyLastUpdate.attributedText = Lastattributed
        
       
        
        
        cell.viewBack.setcorner()
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white
        cell.selectedBackgroundView = backgroundView
        
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
    
        func updateNextSet(){
               print("On Completetion")
            if !allItemDownloaded {
                pageNumber = pageNumber + 1
                get_Transaction_data(showLoading: false, loadOnly: true)
            }
       }
}
    
extension ApproveTransactionVC:UISearchBarDelegate {
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
       self.SearchKey = searchBar.text!
        get_Transaction_data(showLoading: false, loadOnly: false)
    }

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
}
