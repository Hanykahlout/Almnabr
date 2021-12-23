//
//  AllPrpjectsVC.swift
//  Almnabr
//
//  Created by MacBook on 10/10/2021.
//  Copyright © 2021 Samar Akkila. All rights reserved.
//

import UIKit
import DPLocalization
import FontAwesome_swift
import DropDown

class AllPrpjectsVC: UIViewController {
    
    
    @IBOutlet weak var imgNext1: UIImageView!
    @IBOutlet weak var imgNext2: UIImageView!
    
    @IBOutlet weak var lblHome: UIButton!
    @IBOutlet weak var lblMenuName: UILabel!
    @IBOutlet weak var lblSubMenuName: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblnodata: UILabel!
    
    @IBOutlet weak var lblsearchByServices: UILabel!
    @IBOutlet weak var lblsearchByBranch: UILabel!
    
    
    @IBOutlet weak var viewsearchByServices: UIView!
    @IBOutlet weak var viewsearchByBranch: UIView!
    
    @IBOutlet weak var imgDropServices: UIImageView!
    @IBOutlet weak var imgDropBranch: UIImageView!
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var header: HeaderView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var SearchKey:String = ""
    var StrTitle:String = ""
    var StrSubMenue:String = "All Projects".localized()
    var StrMenue:String = "Projects".localized()
    
    var StrsearchByServices:String = ""
    var StrsearchByBranch:String = ""
    var searchByTypeOfApproval:String = ""
    var pageNumber = 1
    var allItemDownloaded = false
    var MenuObj:MenuObj?
    var SubMenuObj:MenuObj?
    var arr_data:[projectObj] = []
    var arr_Services:[ModuleObj] = []
    var arr_ServicesLabel:[String] = []
    var arr_branch:[ModuleObj] = []
    var arr_branchLabel:[String] = []
    var arr_Admin:[String] = ["All".localized(),"Manual".localized(),"Auto".localized()]
    var cellWidths: [CGFloat] = [700]
    var arr_NoData:[String] = ["No items found".localized()]
    
    let fontStyle: FontAwesomeStyle = .solid
    
    let dropUpmage =  UIImage.fontAwesomeIcon(name: .chevronUp , style: .solid, textColor:  .gray, size: CGSize(width: 40, height: 40))
    
    let dropDownmage =  UIImage.fontAwesomeIcon(name: .chevronDown , style: .solid, textColor:  .gray, size: CGSize(width: 40, height: 40))
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        configGUI()
        get_Projects_data(showLoading: true, loadOnly: true)
        get_Services()
        get_Branch()
        
        header.btnAction = self.menu_select
      
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
        
        lblSubMenuName.textColor =  HelperClassSwift.acolor.getUIColor()
        lblSubMenuName.font = .kufiRegularFont(ofSize: 15)
        
        
        self.lblHome.titleLabel?.text =  "txt_Home".localized()
        self.lblHome.titleLabel?.font = .kufiRegularFont(ofSize: 15)
        
        self.lblnodata.text =  "txt_NoData".localized()
        self.lblnodata.font = .kufiRegularFont(ofSize: 15)
        self.lblnodata.isHidden = true
        
        self.viewsearchByBranch.setBorderGray()
        self.lblsearchByBranch.text =  "txt_searchByBranch".localized()
        self.lblsearchByBranch.font = .kufiRegularFont(ofSize: 15)
        
        
        self.viewsearchByServices.setBorderGray()
        self.lblsearchByServices.text =  "txt_searchByServices".localized()
        self.lblsearchByServices.font = .kufiRegularFont(ofSize: 15)
        searchBar.delegate = self
        
        self.mainView.setBorderGray()

        self.StrMenue =  MenuObj?.menu_name ?? "Projects".localized()
        self.lblMenuName.text = MenuObj?.menu_name ?? "All Projects".localized()
        self.lblSubMenuName.text =  StrSubMenue
        self.lblTitle.text =  StrSubMenue
        
        let nextimage =  UIImage.fontAwesomeIcon(name: .angleRight, style: self.fontStyle, textColor: HelperClassSwift.bcolor.getUIColor(), size: CGSize(width: 40, height: 40))
        self.imgNext1.image = nextimage
        self.imgNext2.image = nextimage
        
       
        
        self.imgDropBranch.image = dropDownmage
        self.imgDropServices.image = dropDownmage
        
        table.dataSource = self
        table.delegate = self
        let nib = UINib(nibName: "TransactionTVCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: "TransactionTVCell")
        
    }
    
    
    
    
    
    
    func get_Projects_data(showLoading: Bool, loadOnly: Bool){
        
        if showLoading {
            self.showLoadingActivity()
        }
        
        let search:String = SearchKey.replacingOccurrences(of: " ", with: "%20").trim()
        
        APIManager.sendRequestGetAuth(urlString: "MRpWxXzlMesi27d/1/10?branch_id=\(StrsearchByBranch)&search_services=\(StrsearchByServices)&search_key=\(search)" ) { (response) in
            
            if self.pageNumber == 1 {
                self.arr_data.removeAll()
            }
            let status = response["status"] as? Bool
            if loadOnly {
                self.table.reloadData()
            }
            
            
            let page = response["page"] as? [String:Any]
            if status == true{
                if  let records = response["records"] as? NSArray{
                    for i in records {
                        let dict = i as? [String:Any]
                        let obj = projectObj.init(dict!)
                        self.arr_data.append(obj)
                    }
                    let pageObj = PageObj(page!)
                  
                    if pageObj.total_pages > self.pageNumber {
                        self.allItemDownloaded = false
                    }else{
                        self.allItemDownloaded = true
                    }
                    if records.count == 0 {
                        self.lblnodata.isHidden = false
                    }else{
                        self.lblnodata.isHidden = true
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
    
    
    func get_Services(){
        
        self.showLoadingActivity()
        APIManager.sendRequestGetAuth(urlString: "aB8Vlmue0xVSv8O/projects_view" ) { (response) in
            
            
            let status = response["status"] as? Bool
            if status == true{
                if  let list = response["records"] as? NSArray{
                    for i in list {
                        let dict = i as? [String:Any]
                        let obj = ModuleObj.init(dict!)
                        self.arr_Services.append(obj)
                        // for echitem in obj{
                        self.arr_ServicesLabel.append(obj.label)
                        // }
                        
                    }
                    self.hideLoadingActivity()
                }
            }
            
            
        }
    }
    
    
    func get_Branch(){
        
        self.showLoadingActivity()
        APIManager.sendRequestGetAuth(urlString: "tc/tbranches" ) { (response) in
            
            
            let status = response["status"] as? Bool
            if status == true{
                if  let list = response["records"] as? NSArray{
                    for i in list {
                        let dict = i as? [String:Any]
                        let obj = ModuleObj.init(dict!)
                        self.arr_branch.append(obj)
                        // for echitem in obj{
                        self.arr_branchLabel.append(obj.label)
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
    

 
    
    
    @IBAction func btnSearchBranch_Click(_ sender: Any) {
        
      
        self.imgDropBranch.image = dropUpmage
        
        let dropDown = DropDown()
        dropDown.anchorView = view
        dropDown.backgroundColor = .white
        dropDown.cornerRadius = 2.0
        
        dropDown.dataSource = self.arr_branchLabel
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            if item == self.arr_branchLabel[index] {
                self.lblsearchByBranch.text =  item
                let i =  self.arr_branch[index].value
                self.StrsearchByBranch = i
                self.imgDropBranch.image = dropDownmage
                get_Projects_data(showLoading: true, loadOnly: true)
            }
            
        }
        dropDown.direction = .bottom
        dropDown.anchorView = viewsearchByBranch
        dropDown.bottomOffset = CGPoint(x: 0, y: viewsearchByBranch.bounds.height)
        dropDown.width = viewsearchByBranch.bounds.width
        dropDown.show()
    }
    
    
    
    @IBAction func btnSearchServices_Click(_ sender: Any) {
        
        self.imgDropServices.image = dropUpmage
        let dropDown = DropDown()
        dropDown.anchorView = view
        dropDown.backgroundColor = .white
        dropDown.cornerRadius = 2.0
        
        dropDown.dataSource = self.arr_ServicesLabel
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            if item == self.arr_ServicesLabel[index] {
                self.lblsearchByServices.text =  item
                let i =  self.arr_Services[index].value
                self.StrsearchByServices = i
                self.imgDropServices.image = dropDownmage
                get_Projects_data(showLoading: true, loadOnly: true)
            }
            
        }
        dropDown.direction = .bottom
        dropDown.anchorView = viewsearchByServices
        dropDown.bottomOffset = CGPoint(x: 0, y: viewsearchByServices.bounds.height)
        dropDown.width = viewsearchByServices.bounds.width
        dropDown.show()
    }
    
    
}





extension AllPrpjectsVC: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTVCell", for: indexPath) as! TransactionTVCell
        
        let obj = arr_data[indexPath.item]
      
        
        let no =  "Project ID".localized() + "  \(obj.projects_profile_id)"
        let Description = "Project Title".localized() + "  \(obj.project_title)"
        let from = "Branch".localized() + "  \(obj.branch_name)"
        let to = "Project Type".localized() + "  \(obj.customer_type)"
        let type = "Customers".localized() + "  \(obj.customer_title_en)"
        let writer = "Writer".localized() + "  \(obj.writer)"
        let LastUpdate = "On Date".localized() + "  \(obj.projects_profile_created_datetime)"
       
        
        cell.lbKeylNo.text = no
        cell.lblKeyDesc.text = Description
        cell.lblKeyFrom.text = from
        cell.lblKeyTo.text = to
        cell.lblKeyType.text = type
        cell.lblKeyWriter.text = writer
        cell.lblKeyLastUpdate.text = LastUpdate
        
        cell.lblKeyBarCode.isHidden = true
        cell.lblKeyStatus.isHidden = true
        cell.lblKeySubmitter.isHidden = true
        cell.lblKeyModule.isHidden = true
        cell.lblKeyBarCode.isHidden = true
        
        
        let attributedWithTextColor: NSAttributedString = no.attributedStringWithColor(["Project ID".localized()], color: HelperClassSwift.acolor.getUIColor())
        cell.lbKeylNo.attributedText = attributedWithTextColor
        
        let Descriptionattributed: NSAttributedString = Description.attributedStringWithColor(["Project Title".localized()], color: HelperClassSwift.acolor.getUIColor())
        cell.lblKeyDesc.attributedText = Descriptionattributed
        
        let fromattributed: NSAttributedString = from.attributedStringWithColor(["Branch".localized()], color: HelperClassSwift.acolor.getUIColor())
        cell.lblKeyFrom.attributedText = fromattributed
        
        let Toattributed: NSAttributedString = to.attributedStringWithColor(["Project Type".localized()], color: HelperClassSwift.acolor.getUIColor())
        cell.lblKeyTo.attributedText = Toattributed
        
        
       
        let Typeattributed: NSAttributedString = type.attributedStringWithColor(["Customers".localized()], color: HelperClassSwift.acolor.getUIColor())
        cell.lblKeyType.attributedText = Typeattributed
        
        
        
        let Writerattributed: NSAttributedString = writer.attributedStringWithColor(["Writer".localized()], color: HelperClassSwift.acolor.getUIColor())
        cell.lblKeyWriter.attributedText = Writerattributed
      
        let Lastattributed: NSAttributedString = LastUpdate.attributedStringWithColor(["On Date".localized()], color: HelperClassSwift.acolor.getUIColor())
        cell.lblKeyLastUpdate.attributedText = Lastattributed
        
       
        
        
        cell.viewBack.setcorner()
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white
        cell.selectedBackgroundView = backgroundView
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
                let obj = arr_data[indexPath.item]
                let vc:ProjectDetailsVC = AppDelegate.mainSB.instanceVC()
                vc.title =  self.title
                vc.Object = obj
                vc.MenuObj = self.MenuObj
                vc.StrSubMenue =  self.StrSubMenue
                vc.StrMenue = self.StrMenue
                _ =  panel?.center(vc)
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
                get_Projects_data(showLoading: false, loadOnly: true)
            }
       }
}
    

extension AllPrpjectsVC:UISearchBarDelegate {
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
       self.SearchKey = searchBar.text!
        get_Projects_data(showLoading: false, loadOnly: false)
    }

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.SearchKey = searchBar.text!
        get_Projects_data(showLoading: false, loadOnly: false)
        searchBar.resignFirstResponder()
    }
    
    
}

 
