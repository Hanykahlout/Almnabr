//
//  ProjectDetailsVC.swift
//  Almnabr
//
//  Created by MacBook on 11/10/2021.
//  Copyright © 2021 Samar Akkila. All rights reserved.
//

import UIKit
import DPLocalization
import FontAwesome_swift

class ProjectDetailsVC: UIViewController {
    
    
    
    @IBOutlet weak var imgNext1: UIImageView!
    @IBOutlet weak var imgNext2: UIImageView!
    
    @IBOutlet weak var lblHome: UIButton!
    @IBOutlet weak var btnAddQuotation: UIButton!
    @IBOutlet weak var lblMenuName: UILabel!
    @IBOutlet weak var lblSubMenuName: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblnodata: UILabel!
    @IBOutlet weak var lblQuotationsnodata: UILabel!
    
    @IBOutlet weak var lblBranchName: UILabel!
    @IBOutlet weak var lblProjectNameEn: UILabel!
    @IBOutlet weak var lblProjectNameAr: UILabel!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblcustomer_type: UILabel!
    @IBOutlet weak var lblWriter: UILabel!
    @IBOutlet weak var lblOnDate: UILabel!
    @IBOutlet weak var lblOnupdated: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    
    @IBOutlet weak var lblValBranchName: UILabel!
    @IBOutlet weak var lblValProjectNameEn: UILabel!
    @IBOutlet weak var lblValProjectNameAr: UILabel!
    @IBOutlet weak var lblValCustomerName: UILabel!
    @IBOutlet weak var lblValcustomer_type: UILabel!
    @IBOutlet weak var lblValWriter: UILabel!
    @IBOutlet weak var lblValOnDate: UILabel!
    @IBOutlet weak var lblValOnupdated: UILabel!
    @IBOutlet weak var lblValLocation: UILabel!
    
    @IBOutlet weak var lblServicesTitle: UILabel!
    @IBOutlet weak var view_img: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblServices: UILabel!
    @IBOutlet weak var lblQuotations: UILabel!
    @IBOutlet weak var lblProjects: UILabel!
    @IBOutlet weak var lblProjectTitle: UILabel!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var projectView: UIView!
    @IBOutlet weak var projectVieww: UIView!
    
    @IBOutlet weak var View_project: UIView!
    @IBOutlet weak var View_Quotation: UIView!
    
    @IBOutlet weak var SelectedView_project: UIView!
    @IBOutlet weak var SelectedView_Quotation: UIView!
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var collectionQuotation: UICollectionView!
    @IBOutlet weak var collectionServieces: UICollectionView!
    @IBOutlet weak var Services:ServicesView!
    
    @IBOutlet weak var header: HeaderView!
    
    @IBOutlet weak var tableQuotation: UITableView!
    @IBOutlet weak var tableProjects: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var QuotationSearchKey:String = ""
    var ProjectSearchKey:String = ""
    var StrTitle:String = ""
    var StrSubMenue:String = ""
    var StrMenue:String = ""
    var projectId:String = ""
    var CustomerName:String = ""
    
    var pageNumber = 1
    var allItemDownloaded = false
    var IsPrpjectTable = true
    var MenuObj:MenuObj?
    var SubMenuObj:MenuObj?
    
    var Object:projectObj?
    var arr_Projectdata:[projectQuotObj] = []
    
    var arr_data:[projectQuotObj] = []
    
    var arr_Services:[ModuleObj] = []
    var arr_Users:[ModuleObj] = []
    var arr_ServicesLabel:[String] = []
    var arr_branch:[ModuleObj] = []
    var arr_branchLabel:[String] = []
    
    var cellWidths: [CGFloat] = [900]
    
    let fontStyle: FontAwesomeStyle = .solid
    

    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        configGUI()
        setupCollection()
        
        
        get_Projects_data(showLoading: true, loadOnly: true)
        get_quotation_data(showLoading: true, loadOnly: true)
        get_Projects_Details()
        
        header.btnAction = menu_select
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
        
        
        self.tableProjects.isHidden = false
        //self.tableQuotation.isHidden = true
        
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
        
        self.lblQuotationsnodata.text =  "txt_NoData".localized()
        self.lblQuotationsnodata.font = .kufiRegularFont(ofSize: 15)
        self.lblQuotationsnodata.isHidden = true
        
        self.lblBranchName.text =  "Branch".localized() + " :"
        self.lblBranchName.font = .kufiRegularFont(ofSize: 15)
        self.lblBranchName.textColor =  HelperClassSwift.bcolor.getUIColor()
        
        self.lblProjectNameEn.text =  "txt_Project_Name_En".localized() + " :"
        self.lblProjectNameEn.font = .kufiRegularFont(ofSize: 15)
        self.lblProjectNameEn.textColor =  HelperClassSwift.bcolor.getUIColor()
        
        self.lblProjectNameAr.text =  "txt_Project_Name_Ar".localized() + " :"
        self.lblProjectNameAr.font = .kufiRegularFont(ofSize: 15)
        self.lblProjectNameAr.textColor =  HelperClassSwift.bcolor.getUIColor()
        
        self.lblCustomerName.text =  "Customers".localized() + " :"
        self.lblCustomerName.font = .kufiRegularFont(ofSize: 15)
        self.lblCustomerName.textColor =  HelperClassSwift.bcolor.getUIColor()
        
        self.lblcustomer_type.text =  "txt_Project_Type".localized() + " :"
        self.lblcustomer_type.font = .kufiRegularFont(ofSize: 15)
        self.lblcustomer_type.textColor =  HelperClassSwift.bcolor.getUIColor()
        
        self.lblWriter.text =  "Writer".localized() + " :"
        self.lblWriter.font = .kufiRegularFont(ofSize: 15)
        self.lblWriter.textColor =  HelperClassSwift.bcolor.getUIColor()
        
        self.lblOnDate.text =  "On Date".localized() + " :"
        self.lblOnDate.font = .kufiRegularFont(ofSize: 15)
        self.lblOnDate.textColor =  HelperClassSwift.bcolor.getUIColor()
        
        self.lblOnupdated.text =  "txt_update".localized() + " :"
        self.lblOnupdated.font = .kufiRegularFont(ofSize: 15)
        self.lblOnupdated.textColor =  HelperClassSwift.bcolor.getUIColor()
        
        self.lblLocation.text =  "txt_location".localized() + " :"
        self.lblLocation.font = .kufiRegularFont(ofSize: 15)
        self.lblLocation.textColor =  HelperClassSwift.bcolor.getUIColor()
        
        self.lblValBranchName.text =  Object?.branch_name
        self.lblValBranchName.font = .kufiBoldFont(ofSize: 14)
        self.lblValBranchName.textColor =  HelperClassSwift.bcolor.getUIColor()
        
        self.lblValProjectNameEn.text =  Object?.projects_profile_name_en
        self.lblValProjectNameEn.font = .kufiBoldFont(ofSize: 14)
        
        self.lblValProjectNameAr.text =  Object?.projects_profile_name_ar
        self.lblValProjectNameAr.font = .kufiBoldFont(ofSize: 14)
        
        self.lblValCustomerName.text =  Object?.customer_name
        self.lblValCustomerName.font = .kufiBoldFont(ofSize: 14)
        
        self.lblValcustomer_type.text =  Object?.customer_type
        self.lblValcustomer_type.font = .kufiBoldFont(ofSize: 14)
        
        self.lblValWriter.text =  Object?.writer
        self.lblValWriter.font = .kufiBoldFont(ofSize: 14)
        
        self.lblValOnDate.text =  Object?.projects_profile_created_datetime
        self.lblValOnDate.font = .kufiBoldFont(ofSize: 14)
        
        self.lblValOnupdated.text =  Object?.projects_profile_updated_datetime
        self.lblValOnupdated.font = .kufiBoldFont(ofSize: 14)
        
        self.lblValLocation.text =  Object?.projects_profile_location
        self.lblValLocation.font = .kufiBoldFont(ofSize: 14)
        
        
        self.lblServices.text =  "Services".localized()
        self.lblServices.font = .kufiRegularFont(ofSize: 14)
        self.lblServices.textColor =  HelperClassSwift.bcolor.getUIColor()
        
        self.lblQuotations.text =  "txt_Quotations".localized()
        self.lblQuotations.font = .kufiBoldFont(ofSize: 12)
        self.lblQuotations.textColor =  HelperClassSwift.bcolor.getUIColor()
        
        self.lblProjects.text =  "txt_Projects".localized()
        self.lblProjects.font = .kufiBoldFont(ofSize: 12)
        self.lblProjects.textColor =  HelperClassSwift.bcolor.getUIColor()
        
        self.lblProjectTitle.text =  "txt_Projects".localized()
        self.lblProjectTitle.font = .kufiBoldFont(ofSize: 15)
        self.lblProjectTitle.textColor =  HelperClassSwift.bcolor.getUIColor()
        
        
        self.View_project.setBorderGrayNoCorner()
        self.View_Quotation.setBorderGrayNoCorner()
        
        self.SelectedView_Quotation.isHidden = true
        
        self.mainView.setBorderGray()
        self.projectView.setBorderGray()
        self.projectVieww.setBorderGray()
        
        self.lblMenuName.text =  self.StrMenue
        self.lblSubMenuName.text =  StrSubMenue
        self.lblTitle.text =  "Project Details".localized()
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(GoToAllProject))

        lblSubMenuName.isUserInteractionEnabled = true
        lblSubMenuName.addGestureRecognizer(tapGesture)
        
        self.btnAddQuotation.isHidden = true
        
        let nextimage =  UIImage.fontAwesomeIcon(name: .angleRight, style: self.fontStyle, textColor: HelperClassSwift.bcolor.getUIColor(), size: CGSize(width: 40, height: 40))
        self.imgNext1.image = nextimage
        self.imgNext2.image = nextimage
        
        self.SelectedView_project.backgroundColor = HelperClassSwift.bcolor.getUIColor()
        self.SelectedView_Quotation.backgroundColor = HelperClassSwift.bcolor.getUIColor()
        
        
        let Addimage =  UIImage.fontAwesomeIcon(name: .plus, style: self.fontStyle, textColor: HelperClassSwift.bcolor.getUIColor(), size: CGSize(width: 25, height: 25))
        self.btnAddQuotation.setImage(Addimage, for: .normal)
        
        
       
    }
    
    
    func setupCollection(){
        
        collectionServieces.delegate = self
        collectionServieces.dataSource = self
        
        
        let nib = UINib(nibName: "TransactionTVCell", bundle: nil)
        tableProjects.register(nib, forCellReuseIdentifier: "TransactionTVCell")
        
    }
    
    
    
    //MARK: - Get Projects Data
    //------------------------------------------------------
    
    
    func get_Projects_data(showLoading: Bool, loadOnly: Bool){
        
        if showLoading {
            self.showLoadingActivity()
        }
        
        let search:String = ProjectSearchKey.replacingOccurrences(of: " ", with: "%20").trim()
        
        APIManager.sendRequestGetAuth(urlString: "xZLCctvSvZ9DGb8/\(Object!.projects_profile_id)/1/10?search_key=\(search)" ) { (response) in
            
            if self.pageNumber == 1 {
                self.arr_Projectdata.removeAll()
            }
            let status = response["status"] as? Bool
            if loadOnly {
                self.tableProjects.reloadData()
            }
            
            
            let page = response["page"] as? [String:Any]
            if status == true{
                if  let records = response["records"] as? NSArray{
                    for i in records {
                        let dict = i as? [String:Any]
                        let obj = projectQuotObj.init(dict!)
                        self.arr_Projectdata.append(obj)
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
                    self.tableProjects.reloadData()
                    self.hideLoadingActivity()
                }
                
            }else{
                self.hideLoadingActivity()
                self.lblnodata.isHidden = false
            }
            self.lblQuotationsnodata.isHidden = true
            
            
        }
    }
    
    
    
    
    //MARK: - Get quotation data
    //------------------------------------------------------
    func get_quotation_data(showLoading: Bool, loadOnly: Bool){
        
        if showLoading {
            self.showLoadingActivity()
        }
        
        let search:String = QuotationSearchKey.replacingOccurrences(of: " ", with: "%20").trim()
        
        APIManager.sendRequestGetAuth(urlString: "squotest/\(Object!.projects_profile_id)/1/10?search_key=\(search)" ) { (response) in
            
            if self.pageNumber == 1 {
                self.arr_data.removeAll()
            }
            let status = response["status"] as? Bool
            if loadOnly {
              //  self.tableQuotation.reloadData()
            }
            
            
            let page = response["page"] as? [String:Any]
            if status == true{
                if  let records = response["records"] as? NSArray{
                    for i in records {
                        let dict = i as? [String:Any]
                        let obj = projectQuotObj.init(dict!)
                        self.arr_data.append(obj)
                    }
                    let pageObj = PageObj(page!)
                    
                    if pageObj.total_pages > self.pageNumber {
                        self.allItemDownloaded = false
                    }else{
                        self.allItemDownloaded = true
                    }
                    
                    if records.count == 0 {
                        self.lblQuotationsnodata.isHidden = false
                    }else{
                        self.lblQuotationsnodata.isHidden = true
                    }
                    //self.tableQuotation.reloadData()
                    self.hideLoadingActivity()
                }
                
            }else{
                self.lblnodata.isHidden = true
                self.hideLoadingActivity()
                self.lblQuotationsnodata.isHidden = false
            }
            
            
        }
    }
    
    
    
    
    //MARK: - Get Project Details
    //------------------------------------------------------
    
    
    
    func get_Projects_Details(){
        
        self.showLoadingActivity()
        
        APIManager.sendRequestGetAuth(urlString: "TEd1bgyHSC0GPcq/\(Object!.projects_profile_id)") { (response) in
            
            
            let status = response["status"] as? Bool
            
            let service_user_data = response["service_user_data"] as? [String:Any]
            if status == true{
                if  let users = service_user_data!["users"] as? NSArray{
                    for i in users {
                        let dict = i as? [String:Any]
                        let obj = ModuleObj.init(dict!)
                        self.arr_Users.append(obj)
                        self.CustomerName.append(obj.label  + "\n")
                    }
                    self.lblValCustomerName.text = self.CustomerName
                }
                if  let services = service_user_data!["services"] as? NSArray{
                    
                    for i in services {
                        let dict = i as? [String:Any]
                        let obj = ModuleObj.init(dict!)
                        self.arr_Services.append(obj)
                    }
                 
                    
                    self.collectionServieces.reloadData()
                    self.hideLoadingActivity()
                }
                
            }else{
                self.hideLoadingActivity()
               
            }
            
            
        }
    
        self.lblQuotationsnodata.isHidden = true
    }
    
    
    
    func menu_select(){
        let language = dp_get_current_language()
        if language == "ar"{
            panel?.openRight(animated: true)
        }else{
            panel?.openLeft(animated: true)
        }
        
    }
    
    @objc func GoToAllProject() {
        let vc:AllPrpjectsVC = AppDelegate.mainSB.instanceVC()
     //   vc.title =  self.title
        vc.MenuObj = MenuObj
        vc.StrSubMenue =  "All Projects".localized()
        vc.StrMenue = "Projects".localized()
        _ =  panel?.center(vc)
    }
    
    @IBAction func btnProject_Click(_ sender: Any) {
        
        self.IsPrpjectTable = true
        self.tableProjects.reloadData()
        self.SelectedView_project.isHidden = false
        self.SelectedView_Quotation.isHidden = true
        self.lblProjectTitle.text =  "txt_Projects".localized()
        self.btnAddQuotation.isHidden = true
        
        self.lblnodata.isHidden = false
        self.lblQuotationsnodata.isHidden = true
        
            UIView.transition(with: tableProjects, duration: 0.4,
                              options: .transitionFlipFromTop,
                              animations: {
                                self.tableProjects.isHidden = false
                              })
            
    }
    
    @IBAction func btnQuotation_Click(_ sender: Any) {
        //self.tableProjects.isHidden = true
        self.IsPrpjectTable = false
        self.tableProjects.reloadData()
        self.btnAddQuotation.isHidden = false
        self.SelectedView_project.isHidden = true
        self.SelectedView_Quotation.isHidden = false
        self.lblProjectTitle.text =  "txt_Quotations".localized()
        self.lblnodata.isHidden = true
        self.lblQuotationsnodata.isHidden = false
        
            UIView.transition(with: tableProjects, duration: 0.4,
                              options: .transitionFlipFromTop,
                              animations: {
                                self.tableProjects.isHidden = false
                              })
       
       
    }
    
    @IBAction func btnAddQuotation_Click(_ sender: Any) {
        
    }
    
}

extension ProjectDetailsVC: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        if IsPrpjectTable == true{
            return arr_Projectdata.count
        }else{
            return arr_data.count
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTVCell", for: indexPath) as! TransactionTVCell
        
       //if tableView == tableProjects{
        if IsPrpjectTable == true{
            let obj = arr_Projectdata[indexPath.item]
            
            let no =  "Project ID".localized() + "  \(obj.projects_supervision_id)"
            let Description = "Quotation Number".localized() + "  \(obj.projects_quotation_id)"
            let from = "Subject".localized() + "  \(obj.quotation_subject)"
            let to = "Grand Total".localized() + "  \(obj.quotation_grand_total)"
            let type = "Tax Amount".localized() + "  \(obj.quotation_tax_amount)"
            let Module = "Net Amount".localized() + "  \(obj.quotation_net_amount)"
            let Submitter = "Approved Date".localized() + "  \(obj.quotation_approved_date)"
            let writer = "Writer".localized() + "  \(obj.writer)"
            let LastUpdate = "On Date".localized() + "  \(obj.quotation_created_date)"
            
            
            cell.lbKeylNo.text = no
            cell.lblKeyDesc.text = Description
            cell.lblKeyFrom.text = from
            cell.lblKeyTo.text = to
            cell.lblKeyType.text = type
            cell.lblKeyWriter.text = writer
            cell.lblKeyLastUpdate.text = LastUpdate
            cell.lblKeySubmitter.text = Submitter
            cell.lblKeyModule.text = Module
            
            cell.lblKeyBarCode.isHidden = true
            cell.lblKeyStatus.isHidden = true
            cell.lblKeyBarCode.isHidden = true
            
            
            let attributedWithTextColor: NSAttributedString = no.attributedStringWithColor(["Project ID".localized()], color: HelperClassSwift.acolor.getUIColor())
            cell.lbKeylNo.attributedText = attributedWithTextColor
            
            let Descriptionattributed: NSAttributedString = Description.attributedStringWithColor(["Quotation Number".localized()], color: HelperClassSwift.acolor.getUIColor())
            cell.lblKeyDesc.attributedText = Descriptionattributed
            
            let fromattributed: NSAttributedString = from.attributedStringWithColor(["Subject".localized()], color: HelperClassSwift.acolor.getUIColor())
            cell.lblKeyFrom.attributedText = fromattributed
            
            let Toattributed: NSAttributedString = to.attributedStringWithColor(["Grand Total".localized()], color: HelperClassSwift.acolor.getUIColor())
            cell.lblKeyTo.attributedText = Toattributed
            
            
           
            let Typeattributed: NSAttributedString = type.attributedStringWithColor(["Tax Amount".localized()], color: HelperClassSwift.acolor.getUIColor())
            cell.lblKeyType.attributedText = Typeattributed
            
            
            let Moduleattributed: NSAttributedString = Module.attributedStringWithColor(["Net Amount".localized()], color: HelperClassSwift.acolor.getUIColor())
            cell.lblKeyModule.attributedText = Moduleattributed
            
            let Writerattributed: NSAttributedString = writer.attributedStringWithColor(["Writer".localized()], color: HelperClassSwift.acolor.getUIColor())
            cell.lblKeyWriter.attributedText = Writerattributed
            
            let Submitterattributed: NSAttributedString = Submitter.attributedStringWithColor(["Approved Date".localized()], color: HelperClassSwift.acolor.getUIColor())
            cell.lblKeySubmitter.attributedText = Submitterattributed
            
          
            let Lastattributed: NSAttributedString = LastUpdate.attributedStringWithColor(["On Date".localized()], color: HelperClassSwift.acolor.getUIColor())
            cell.lblKeyLastUpdate.attributedText = Lastattributed
            
            cell.viewBack.setcorner()
            let backgroundView = UIView()
            backgroundView.backgroundColor = .white
            cell.selectedBackgroundView = backgroundView
            
            return cell
        }else{
            let obj = arr_data[indexPath.item]
         
                     let Description = "Quotation Number".localized() + "  \(obj.projects_quotation_id)"
                     let from = "Subject".localized() + "  \(obj.quotation_subject)"
                     let to = "Grand Total".localized() + "  \(obj.quotation_grand_total)"
                     let type = "Tax Amount".localized() + "  \(obj.quotation_tax_amount)"
                     let Module = "Net Amount".localized() + "  \(obj.quotation_net_amount)"
         
                     let Submitter = "Approved Date".localized() + "  \(obj.quotation_approved_date)"
                     let writer = "Writer".localized() + "  \(obj.writer)"
                     let LastUpdate = "Submitted Date".localized() + "  \(obj.quotation_created_date)"
                     let Status = "Status".localized() + "New"
         
         
                     cell.lblKeyDesc.text = Description
                     cell.lblKeyFrom.text = from
                     cell.lblKeyTo.text = to
                     cell.lblKeyType.text = type
                     cell.lblKeyWriter.text = writer
                     cell.lblKeyLastUpdate.text = LastUpdate
                     cell.lblKeySubmitter.text = Submitter
                     cell.lblKeyModule.text = Module
                     cell.lblKeyStatus.text = Status
         
         
                     cell.lblKeyBarCode.isHidden = true
                     cell.lbKeylNo.isHidden = true
                     cell.lblKeyBarCode.isHidden = true
         
         
            let Descriptionattributed: NSAttributedString = Description.attributedStringWithColor(["Quotation Number".localized()], color: HelperClassSwift.acolor.getUIColor())
                     cell.lblKeyDesc.attributedText = Descriptionattributed
         
            let fromattributed: NSAttributedString = from.attributedStringWithColor(["Subject".localized()], color: HelperClassSwift.acolor.getUIColor())
                     cell.lblKeyFrom.attributedText = fromattributed
         
            let Toattributed: NSAttributedString = to.attributedStringWithColor(["Grand Total".localized()], color: HelperClassSwift.acolor.getUIColor())
                     cell.lblKeyTo.attributedText = Toattributed
         
         
         
            let Typeattributed: NSAttributedString = type.attributedStringWithColor(["Tax Amount".localized()], color: HelperClassSwift.acolor.getUIColor())
                     cell.lblKeyType.attributedText = Typeattributed
         
         
            let Moduleattributed: NSAttributedString = Module.attributedStringWithColor(["Net Amount".localized()], color: HelperClassSwift.acolor.getUIColor())
                     cell.lblKeyModule.attributedText = Moduleattributed
         
            let Writerattributed: NSAttributedString = writer.attributedStringWithColor(["Writer".localized()], color: HelperClassSwift.acolor.getUIColor())
                     cell.lblKeyWriter.attributedText = Writerattributed
         
         
         
            let Submitterattributed: NSAttributedString = Submitter.attributedStringWithColor(["Approved Date".localized()], color: HelperClassSwift.acolor.getUIColor())
                     cell.lblKeySubmitter.attributedText = Submitterattributed
         
         
            let Lastattributed: NSAttributedString = LastUpdate.attributedStringWithColor(["Submitted Date".localized()], color: HelperClassSwift.acolor.getUIColor())
                     cell.lblKeyLastUpdate.attributedText = Lastattributed
         
            let Statusattributed: NSAttributedString = Status.attributedStringWithColor(["Status".localized()], color: HelperClassSwift.acolor.getUIColor())
                     cell.lblKeyStatus.attributedText = Statusattributed
         
         
         
                     cell.viewBack.setcorner()
         
                     let backgroundView = UIView()
                     backgroundView.backgroundColor = .white
                     cell.selectedBackgroundView = backgroundView
         
                     return cell
            
        }
  
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if IsPrpjectTable == true{
                let obj = arr_Projectdata[indexPath.item]
            projects_profile_id = obj.projects_profile_id
            projects_work_area_id = obj.projects_work_area_id
            projects_supervision_id = obj.projects_supervision_id
                let vc:SubProjectDetailsVC = AppDelegate.mainSB.instanceVC()
                vc.title =  self.title
                vc.Object = Object
                vc.StrSubMenue =  self.StrSubMenue
                vc.StrMenue = self.StrMenue
                vc.MenuObj = self.MenuObj
                _ =  panel?.center(vc)
                
        }else{
            print("nil")
        }
       
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.tag == 0 {
            
            
            print(indexPath.row)
            if IsPrpjectTable == true{
                if indexPath.row   == arr_data.count - 1  {
                        updateNextSet()
                        print("next step")
                    
                }
            }else{
                
                if indexPath.row   == arr_data.count - 1  {
                    updateNextQutationSet()
                        print("next step")
                    
                }
                
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
        
        func updateNextQutationSet(){
               print("On Completetion")
            if !allItemDownloaded {
                pageNumber = pageNumber + 1
                get_quotation_data(showLoading: false, loadOnly: true)
            }
       }

}



extension ProjectDetailsVC: UICollectionViewDataSource ,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr_Services.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestCell", for: indexPath) as! TestCell
        
        let item = arr_Services[indexPath.item]
        cell.obj_ModuleObj = item
        cell.lbl_Title.font = .kufiRegularFont(ofSize: 13)
        cell.lbl_Title.textColor = HelperClassSwift.bcolor.getUIColor()
        
        cell.view_img.setBorderGrayWidth(3)
        cell.view_img.setRounded()
        
        cell.img.image = UIImage.fontAwesomeIcon(name: .codeBranch, style: self.fontStyle, textColor: .white, size: CGSize(width: 40, height: 40))
        
        if indexPath.item == 0 {
            cell.view_img.backgroundColor = HelperClassSwift.acolor.getUIColor()
        }else{
            cell.view_img.backgroundColor = HelperClassSwift.bcolor.getUIColor()
        }
        
        
        return cell
    }
    
    
}


extension ProjectDetailsVC:UISearchBarDelegate {
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if IsPrpjectTable == true{
            self.ProjectSearchKey = searchBar.text!
             get_Projects_data(showLoading: false, loadOnly: false)
        }else{
            self.QuotationSearchKey = searchBar.text!
            get_quotation_data(showLoading: false, loadOnly: false)
        }
      
    }

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if IsPrpjectTable == true{
            self.ProjectSearchKey = searchBar.text!
             get_Projects_data(showLoading: false, loadOnly: false)
        }else{
            self.QuotationSearchKey = searchBar.text!
            get_quotation_data(showLoading: false, loadOnly: false)
        }
        searchBar.resignFirstResponder()
    }
    
    
}

 
