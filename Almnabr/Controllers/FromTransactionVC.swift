//
//  FromTransactionVC.swift
//  Almnabr
//
//  Created by MacBook on 18/10/2021.
//  Copyright © 2021 Samar Akkila. All rights reserved.
//

var projects_profile_id:String = ""
var projects_work_area_id:String = ""
var projects_supervision_id:String = ""

import UIKit
import DPLocalization
import FontAwesome_swift
import DropDown
import FAPanels

class FromTransactionVC: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblnodata: UILabel!
    
    @IBOutlet weak var lblsearchTemplateName: UILabel!
    @IBOutlet weak var lblsearchGroupType: UILabel!
    @IBOutlet weak var lblsearchGroupe1: UILabel!
    @IBOutlet weak var lblsearchGroupe2: UILabel!
    
    @IBOutlet weak var viewsearchTemplateName: UIView!
    @IBOutlet weak var viewsearchGroupType: UIView!
    @IBOutlet weak var viewsearchGroupe1: UIView!
    @IBOutlet weak var viewsearchGroupe2: UIView!
    
    @IBOutlet weak var btnsearchTemplateName: UIButton!
    @IBOutlet weak var btnsearchGroupType: UIButton!
    @IBOutlet weak var btnsearchGroupe1: UIButton!
    @IBOutlet weak var btnsearchGroupe2: UIButton!
    
    @IBOutlet weak var imgDropTemplateName: UIImageView!
    @IBOutlet weak var imgDropGroupType: UIImageView!
    @IBOutlet weak var imgDropGroupe1: UIImageView!
    @IBOutlet weak var imgDropGroupe2: UIImageView!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var StrTitle:String = ""
    var StrSubMenue:String = ""
    var StrsearchByTempelate:String = ""
    var StrsearchByTempelateCode:String = ""
    var StrsearchGroupType:String = ""
    var StrsearchGroupTypeCode:String = ""
    var StrsearchGroup1:String = ""
    var StrsearchGroup1Code:String = ""
    var StrsearchGroup2:String = ""
    
    var SearchKey:String = ""
    
    var StrsearchByAdmin:Bool = true
    var pageNumber = 1
    var total:Int = 0
    var allItemDownloaded = false
    var MenuObj:MenuObj?
    var SubMenuObj:MenuObj?
    var arr_data:[templateObj] = []
    var arr_Tempelate:[ModuleObj] = []
    var arr_TempelateLabel:[String] = []
    var arr_GroupType:[ModuleObj] = []
    var arr_GroupTypeLabel:[String] = []
    var arr_Group1:[ModuleObj] = []
    var arr_Group1Label:[String] = []
    var arr_Group2:[ObjPlatformGroup] = []
    var arr_Group2Label:[String] = []
    var arr_NoData:[String] = ["No items found".localized()]
    
    let dropUpmage =  UIImage.fontAwesomeIcon(name: .chevronUp , style: .solid, textColor:  .gray, size: CGSize(width: 40, height: 40))
    
    let dropDownmage =  UIImage.fontAwesomeIcon(name: .chevronDown , style: .solid, textColor:  .gray, size: CGSize(width: 40, height: 40))
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        configGUI()
        //  setupCollection()
        get_FormTransaction_data(showLoading: true, loadOnly: true)
        get_Template_name()
//        get_Group_Type()
//        get_Group1()
        
        
        
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
        
        
        lblTitle.textColor =  HelperClassSwift.acolor.getUIColor()
        lblTitle.font = .kufiBoldFont(ofSize: 15)
        
      
        self.lblnodata.text =  "txt_NoData".localized()
        self.lblnodata.font = .kufiRegularFont(ofSize: 15)
        self.lblnodata.isHidden = true
      
        
        self.viewsearchTemplateName.setBorderGray()
        self.lblsearchTemplateName.text =  "txt_TemplateName".localized()
        self.lblsearchTemplateName.font = .kufiRegularFont(ofSize: 15)
        
        self.viewsearchGroupType.setBorderGray()
        self.lblsearchGroupType.text =  "txt_GroupType".localized()
        self.lblsearchGroupType.font = .kufiRegularFont(ofSize: 15)
        
        self.viewsearchGroupe1.setBorderGray()
        self.lblsearchGroupe1.text =  "txt_Groupe1".localized()
        self.lblsearchGroupe1.font = .kufiRegularFont(ofSize: 15)
        
        self.viewsearchGroupe2.setBorderGray()
        self.lblsearchGroupe2.text =  "txt_Groupe2".localized()
        self.lblsearchGroupe2.font = .kufiRegularFont(ofSize: 15)
        
        self.lblnodata.isHidden = false
        
        btnsearchTemplateName.isHidden = true
        btnsearchGroupType.isHidden = true
        btnsearchGroupe1.isHidden = true
        btnsearchGroupe2.isHidden = true
       
        self.imgDropTemplateName.image = dropDownmage
        self.imgDropGroupe1.image = dropDownmage
        self.imgDropGroupe2.image = dropDownmage
        self.imgDropGroupType.image = dropDownmage
        
        searchBar.delegate = self
        
        self.mainView.setBorderGray()
        
        self.lblTitle.text =  "Form Transaction".localized()
        
        
        table.dataSource = self
        table.delegate = self
        
        let nib = UINib(nibName: "TransactionTVCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: "TransactionTVCell")
       
        
    }
    
    func get_FormTransaction_data(showLoading: Bool, loadOnly: Bool){
        
        if showLoading {
            self.showLoadingActivity()
        }
        let search:String = SearchKey.replacingOccurrences(of: " ", with: "%20").trim()
        
        APIManager.sendRequestGetAuth(urlString:   "p/formstransactions/\(projects_profile_id)/\(pageNumber)/10?search_key=\(search)&projects_profile_id=\(projects_profile_id)&platform_group1_code_system=\(StrsearchGroup1Code)&platform_group_type_code_system=\(StrsearchGroupTypeCode)&platform_group2_code_system=\(StrsearchGroup2)&template_id=\(StrsearchByTempelateCode)" ) { (response) in
          
            if self.pageNumber == 1 {
                self.arr_data.removeAll()
            }
            let status = response["status"] as? Bool
           // let total = response["total"] as? Int
            if loadOnly {
                self.table.reloadData()
            }
            
            let page = response["page"] as? [String:Any]
            if status == true{
               // self.total = total!
                
                if  let records = response["records"] as? NSArray{
                    for i in records {
                        let dict = i as? [String:Any]
                        let obj = templateObj.init(dict!)
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
                    // self.collection.scrollToItem(at:IndexPath(item: self.arr_data.count - 1, section: self.arr_data.count - 1), at: .left, animated: false)
                    self.hideLoadingActivity()
                }
                
            }else{
                self.hideLoadingActivity()
                self.lblnodata.isHidden = false
                // self.showAMessage(withTitle: "error", message: "Please try again")
            }
            
            
        }
    }
    
    
    
  
    
    func get_Template_name(){
        
        self.showLoadingActivity()
        let language = dp_get_current_language()
        APIManager.sendRequestGetAuth(urlString: "p/get_templates_for_transactions?lang_key=\(language ?? "ar")&projects_work_area_id=\(projects_work_area_id)" ) { (response) in
            
            
            let status = response["status"] as? Bool
            if status == true{
                if  let list = response["records"] as? NSArray{
                    for i in list {
                        let dict = i as? [String:Any]
                        let obj = ModuleObj.init(dict!)
                        self.arr_Tempelate.append(obj)
                        // for echitem in obj{
                        self.arr_TempelateLabel.append(obj.label)
                        // }
                        
                    }
                    self.hideLoadingActivity()
                }
            }
            self.hideLoadingActivity()
            
        }
    }
    
    
    func get_Group_Type(){
        
        //pforms/get_group1_type_group2?projects_work_area_id=1&template_id=1&required_type=type&group1=2&type=
        self.showLoadingActivity()
        APIManager.sendRequestGetAuth(urlString: "pforms/get_group1_type_group2?projects_work_area_id=\(projects_work_area_id)&template_id=\(StrsearchByTempelateCode)&required_type=type&group1=\(self.StrsearchGroup1Code)&type=" ) { (response) in
            
            
            let status = response["status"] as? Bool
            if status == true{
                if  let list = response["records"] as? NSArray{
                    for i in list {
                        let dict = i as? [String:Any]
                        let obj = ModuleObj.init(dict!)
                        self.arr_GroupType.append(obj)
                        // for echitem in obj{
                        self.arr_GroupTypeLabel.append(obj.label)
                        // }
                        
                    }
                    self.hideLoadingActivity()
                }
            }
            
            
        }
    }
    
    
    func get_Group1(){
        

        //pforms/get_group1_type_group2?projects_work_area_id=1&template_id=1&required_type=group1&group1=&type=
        self.showLoadingActivity()
        APIManager.sendRequestGetAuth(urlString: "pforms/get_group1_type_group2?projects_work_area_id=\(projects_work_area_id)&template_id=\(StrsearchByTempelateCode)&required_type=group1&group1=&type=" ) { (response) in
            
            
            let status = response["status"] as? Bool
            if status == true{
                if  let list = response["records"] as? NSArray{
                    for i in list {
                        let dict = i as? [String:Any]
                        let obj = ModuleObj.init(dict!)
                        self.arr_Group1.append(obj)
                        // for echitem in obj{
                        self.arr_Group1Label.append(obj.label)
                        // }
                        
                    }
                    self.hideLoadingActivity()
                }
            }
            self.hideLoadingActivity()
            
        }
    }
    
    
    func get_Group2(){
       
        //StrsearchGroupTypeCode
        
   //https://nahidh.sa/backend/pforms/get_group1_type_group2?projects_work_area_id=1&template_id=1&required_type=group2&group1=2&type=WIR
        self.arr_Group2Label = []
        self.showLoadingActivity()
        APIManager.sendRequestGetAuth(urlString: "pforms/get_group1_type_group2?projects_work_area_id=\(projects_work_area_id)&template_id=\(StrsearchByTempelateCode)&required_type=group2&group1=\(self.StrsearchGroup1Code)&type=\(self.StrsearchGroupTypeCode)" ) { (response) in
            
            
            let status = response["status"] as? Bool
            if status == true{
                if  let list = response["records"] as? NSArray{
                    for i in list {
                        let dict = i as? [String:Any]
                        let obj = ObjPlatformGroup.init(dict!)
                        self.arr_Group2.append(obj)
                        // for echitem in obj{
                        self.arr_Group2Label.append(obj.label)
                        // }
                        
                    }
                    self.hideLoadingActivity()
                }
            }else{
                self.hideLoadingActivity()
            }
            
            
        }
    }
    


//
//    func sendData(MyStringToSend : String) {
//
//    let CVC = childViewControllers.last as! LanguageVC
//    CVC.ChangeLabel( MyStringToSend)
//    }
    
    
    @IBAction func btnSearchTemplateName_Click(_ sender: Any) {
        
        self.imgDropTemplateName.image = dropUpmage
        
        let dropDown = DropDown()
        dropDown.anchorView = view
        dropDown.backgroundColor = .white
        dropDown.cornerRadius = 2.0
        
        if self.arr_TempelateLabel.count == 0 {
            dropDown.dataSource = self.arr_NoData
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                self.imgDropTemplateName.image = dropDownmage
            }
            dropDown.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }else{
            dropDown.dataSource = self.arr_TempelateLabel
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                
                if item == self.arr_TempelateLabel[index] {
                    self.lblsearchTemplateName.text =  item
                    let i =  self.arr_Tempelate[index]
                    self.StrsearchByTempelateCode = i.value
                    self.imgDropTemplateName.image = dropDownmage
                    self.btnsearchTemplateName.isHidden = false
                  
                    self.get_Group1()
                }
                
            }

        }
        dropDown.direction = .bottom
        dropDown.anchorView = viewsearchTemplateName
        dropDown.bottomOffset = CGPoint(x: 0, y: viewsearchTemplateName.bounds.height)
        dropDown.width = viewsearchTemplateName.bounds.width
        dropDown.show()
    }
    
    
    @IBAction func btnSearchGroupType_Click(_ sender: Any) {
        
        self.imgDropGroupType.image = dropUpmage
        let dropDown = DropDown()
        dropDown.anchorView = view
        dropDown.backgroundColor = .white
        dropDown.cornerRadius = 2.0
        
        if self.arr_GroupTypeLabel.count == 0 {
            dropDown.dataSource = self.arr_NoData
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                self.imgDropGroupType.image = dropDownmage
            }
            dropDown.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }else{
            dropDown.dataSource = self.arr_GroupTypeLabel
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                
                if item == self.arr_GroupTypeLabel[index] {
                    self.lblsearchGroupType.text =  item
                    let i =  self.arr_GroupType[index]
                    self.StrsearchGroupType = i.value
                    self.StrsearchGroupTypeCode = i.value
                    self.imgDropGroupType.image = dropDownmage
                    self.btnsearchGroupType.isHidden = false
                    self.get_Group2()
                   
                }
                
            }

        }
        dropDown.direction = .bottom
        dropDown.anchorView = viewsearchGroupType
        dropDown.bottomOffset = CGPoint(x: 0, y: viewsearchGroupType.bounds.height)
        dropDown.width = viewsearchGroupType.bounds.width
        dropDown.show()
    }
    
    
    
    
    @IBAction func btnSearchGroupe1_Click(_ sender: Any) {
        
        self.imgDropGroupe1.image = dropUpmage
        let dropDown = DropDown()
        dropDown.anchorView = view
        dropDown.backgroundColor = .white
        dropDown.cornerRadius = 2.0
        
        if self.arr_Group1Label.count == 0 {
            dropDown.dataSource = self.arr_NoData
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                self.imgDropGroupe1.image = dropDownmage
            }
            dropDown.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }else{
            dropDown.dataSource = self.arr_Group1Label
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                
                if item == self.arr_Group1Label[index] {
                    self.lblsearchGroupe1.text =  item
                    let i =  self.arr_Group1[index].value
                    self.StrsearchGroup1 = i
                    self.StrsearchGroup1Code = i
                    self.btnsearchGroupe1.isHidden = false
                    self.imgDropGroupe1.image = dropDownmage
                    //get_Group2()
                    self.get_Group_Type()
                  
                }
                
            }
        }
   
        dropDown.direction = .bottom
        dropDown.anchorView = viewsearchGroupe1
        dropDown.bottomOffset = CGPoint(x: 0, y: viewsearchGroupe1.bounds.height)
        dropDown.width = viewsearchGroupe1.bounds.width
        dropDown.show()
    }
    
    
    @IBAction func btnSearchGroupe2_Click(_ sender: Any) {
        
        self.imgDropGroupe2.image = dropUpmage
        let dropDown = DropDown()
        dropDown.anchorView = view
        dropDown.backgroundColor = .white
        dropDown.cornerRadius = 2.0
        if self.arr_Group2Label.count == 0 {
            dropDown.dataSource = self.arr_NoData
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                self.imgDropGroupe2.image = dropDownmage
            }
            dropDown.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }else{
            dropDown.dataSource = self.arr_Group2Label
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                
                if item == self.arr_Group2Label[index] {
                    self.lblsearchGroupe2.text =  item
                    let i =  self.arr_Group2[index].value
                    self.StrsearchGroup2 = i
                    self.btnsearchGroupe2.isHidden = false
                    self.imgDropGroupe2.image = dropDownmage
                    self.get_FormTransaction_data(showLoading: true, loadOnly: true)
                }
                
            }
        }
  
        dropDown.direction = .bottom
        dropDown.anchorView = viewsearchGroupe2
        dropDown.bottomOffset = CGPoint(x: 0, y: viewsearchGroupe2.bounds.height)
        dropDown.width = viewsearchGroupe2.bounds.width
        dropDown.show()
    }
    
    @IBAction func btnSearchTemplateNameDelete_Click(_ sender: Any) {
        self.lblsearchTemplateName.text = "txt_TemplateName".localized()
        self.btnsearchTemplateName.isHidden = true
    }
    
    @IBAction func btnSearchGroupTypeDelete_Click(_ sender: Any) {
        self.lblsearchGroupType.text = "txt_GroupType".localized()
        self.btnsearchGroupType.isHidden = true
    }
    
    @IBAction func btnSearchGroupe1Delete_Click(_ sender: Any) {
        self.lblsearchGroupe1.text = "txt_Groupe1".localized()
        self.btnsearchGroupe1.isHidden = true
    }
    
    @IBAction func btnSearchGroupe2Delete_Click(_ sender: Any) {
        self.lblsearchGroupe2.text = "txt_Groupe2".localized()
      
        self.btnsearchGroupe2.isHidden = true
    }
    
    
   
}


extension FromTransactionVC: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTVCell", for: indexPath) as! TransactionTVCell
        
        let obj = arr_data[indexPath.item]
        
        let no =  "Platform Code System".localized() + "  \(obj.template_platform_code_system)"
        let Description = "Platform".localized() + "  \(obj.platformname)"
        let from = "Template Name".localized() + "  \(obj.templatename)"
        let to = "Group One".localized() + "  \(obj.group1name)"
        let barcode = "Group Type    ".localized() + "  \(obj.typename)"
        let type = "Group Two".localized() + "  \(obj.group2name)"
        
        cell.lbKeylNo.text = no
        cell.lblKeyDesc.text = Description
        cell.lblKeyFrom.text = from
        cell.lblKeyTo.text = to
        cell.lblKeyBarCode.text = barcode
        cell.lblKeyType.text = type
        
        
        cell.lblKeyModule.isHidden = true
        cell.lblKeyWriter.isHidden = true
        cell.lblKeySubmitter.isHidden = true
        cell.lblKeyLastUpdate.isHidden = true
        cell.lblKeyStatus.isHidden = true
        
        
        let attributedWithTextColor: NSAttributedString = no.attributedStringWithColor(["Platform Code System".localized()], color: HelperClassSwift.acolor.getUIColor())
        cell.lbKeylNo.attributedText = attributedWithTextColor
        
        let Descriptionattributed: NSAttributedString = Description.attributedStringWithColor(["Platform".localized()], color: HelperClassSwift.acolor.getUIColor())
        cell.lblKeyDesc.attributedText = Descriptionattributed
        
        let fromattributed: NSAttributedString = from.attributedStringWithColor(["Template Name".localized()], color: HelperClassSwift.acolor.getUIColor())
        cell.lblKeyFrom.attributedText = fromattributed
        
        let Toattributed: NSAttributedString = to.attributedStringWithColor(["Group One".localized()], color: HelperClassSwift.acolor.getUIColor())
        cell.lblKeyTo.attributedText = Toattributed
        
        
        let Barcodeattributed: NSAttributedString = barcode.attributedStringWithColor(["Group Type".localized()], color: HelperClassSwift.acolor.getUIColor())
        cell.lblKeyBarCode.attributedText = Barcodeattributed
        
        let Typeattributed: NSAttributedString = type.attributedStringWithColor(["Group Two".localized()], color: HelperClassSwift.acolor.getUIColor())
        cell.lblKeyType.attributedText = Typeattributed
        
       
        cell.viewBack.setcorner()
        
       
        return cell
        
    }
    
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        
        print("Selected rows after selection: ", tableView.indexPathsForSelectedRows?.count ?? 0)
        let obj = self.arr_data[indexPath.item]
        
        let vc : FormDetailsVC = AppDelegate.mainSB.instanceVC()
      
        let nav = UINavigationController.init(rootViewController: vc)
      
        vc.title =  self.title
        vc.ProjectObj = obj
        vc.MenuObj = self.MenuObj
        vc.StrSubMenue =  self.StrSubMenue
       // vc.Object = self.ob
        _ =  panel?.center(nav)
    }
 
     
    
            
           // self.present(vc, animated: true, completion: nil)
     
       // self.navigationController?.pushViewController(vc, animated: true)
       // top_vc()?.panel?.center(vc)
        
       // vc.MenuObj = self.MenuObj
       // vc.StrMenue = self.StrMenue
       // self.navigationController?.pushViewController(vc, animated: true)
      
        //_ =  panel?.center(vc)
   // }
    
//    func top_vc() -> UIViewController? {
//        if let window = UIApplication.window {
//            if let menu = window.rootViewController as? FAPanelController {
//                return menu
////                if let nav = menu.children[2] as? UINavigationController {
////                    if let top = nav.topViewController {
////                        return top
////                    }
////                }
//                return nil
//            }
//        }
//
//        return nil
//    }
    

    
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
            get_FormTransaction_data(showLoading: false, loadOnly: false)
        }
    }
}


extension FromTransactionVC:UISearchBarDelegate {
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
       self.SearchKey = searchBar.text!
        get_FormTransaction_data(showLoading: false, loadOnly: false)
    }

    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.SearchKey = searchBar.text!
         get_FormTransaction_data(showLoading: false, loadOnly: false)
        searchBar.resignFirstResponder()
    }
    
    
}

 
extension UIApplication {
    static var window: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }

}

 