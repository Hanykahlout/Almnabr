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
import MOLH

class ProjectDetailsVC: UIViewController {
    
    @IBOutlet weak var imgnodata: UIImageView!
    
    @IBOutlet weak var lblProjectName: UILabel!
    
    
    @IBOutlet weak var lblServices: UILabel!
    @IBOutlet weak var lblQuotations: UILabel!
    @IBOutlet weak var lblProjects: UILabel!
    
    @IBOutlet weak var projectVieww: UIView!
    
    @IBOutlet weak var View_project: UIView!
    @IBOutlet weak var View_Quotation: UIView!
    
    @IBOutlet weak var SelectedView_project: UIView!
    @IBOutlet weak var SelectedView_Quotation: UIView!
    
    @IBOutlet weak var collectionServieces: UICollectionView!
    
    @IBOutlet weak var header: HeaderView!
    
    @IBOutlet weak var tableProjects: UITableView!
    
    
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
    
    var add:Bool = false
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
    let maincolor = "#1A3665".getUIColor()

    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        configGUI()
        setupCollection()
        
        get_Projects_Details()
        get_Projects_data(showLoading: true, loadOnly: true)
        get_quotation_data(showLoading: true, loadOnly: true)
       
        
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
        
        
        lblProjectName.textColor =  maincolor
        lblProjectName.font = .kufiBoldFont(ofSize: 15)
        lblProjectName.text = Object!.projects_profile_name_en ?? "---"
        
//        let barnch = "Branch".localized() + " : " + Object!.branch_name ?? "---"
//        let branchAtr: NSAttributedString = barnch.attributedStringWithColor(["Branch".localized()], color: HelperClassSwift.acolor.getUIColor())
//        self.lblBranchName.attributedText = branchAtr
//        lblBranchName.font = .kufiRegularFont(ofSize: 15)
        
//        let project_name = "txt_Project_Name_En".localized() + " : " + Object!.projects_profile_name_en ?? "---"
//        let project_nameAtr: NSAttributedString = project_name.attributedStringWithColor(["txt_Project_Name_En".localized()], color: HelperClassSwift.acolor.getUIColor())
//        self.lblProjectNameEn.attributedText = project_nameAtr
//        lblProjectNameEn.font = .kufiRegularFont(ofSize: 15)
        
//        let project_nameAr = "txt_Project_Name_Ar".localized() + " : " + Object!.projects_profile_name_en ?? "---"
//        let project_nameArAtr: NSAttributedString = project_nameAr.attributedStringWithColor(["txt_Project_Name_Ar".localized()], color: HelperClassSwift.acolor.getUIColor())
//        self.lblProjectNameAr.attributedText = project_nameArAtr
//        lblProjectNameAr.font = .kufiRegularFont(ofSize: 15)
//
//        let customer_name = "Customers".localized() + " : " + Object!.customer_name ?? "---"
//        let customer_nameAtr: NSAttributedString = customer_name.attributedStringWithColor(["Customers".localized()], color: HelperClassSwift.acolor.getUIColor())
//        self.lblCustomerName.attributedText = customer_nameAtr
//        lblCustomerName.font = .kufiRegularFont(ofSize: 15)
//
//
//        let Project_Type = "txt_Project_Type".localized() + " : " + Object!.customer_type_id ?? "---"
//        let Project_TypeAtr: NSAttributedString = Project_Type.attributedStringWithColor(["txt_Project_Type".localized()], color: HelperClassSwift.acolor.getUIColor())
//        self.lblcustomer_type.attributedText = Project_TypeAtr
//        lblcustomer_type.font = .kufiRegularFont(ofSize: 15)
//
//
//        let Writer = "Writer".localized() + " : " + Object!.writer ?? "---"
//        let WriterAtr: NSAttributedString = Writer.attributedStringWithColor(["Writer".localized()], color: HelperClassSwift.acolor.getUIColor())
//        self.lblWriter.attributedText = WriterAtr
//        lblWriter.font = .kufiRegularFont(ofSize: 15)
//
//        let On_date = "On Date".localized() + " : " + Object!.projects_profile_created_datetime ?? "---"
//        let On_dateAtr: NSAttributedString = On_date.attributedStringWithColor(["On Date".localized()], color: HelperClassSwift.acolor.getUIColor())
//        self.lblOnDate.attributedText = On_dateAtr
//        lblOnDate.font = .kufiRegularFont(ofSize: 15)
//
//
//        let updated = "txt_update".localized() + " : " + Object!.projects_profile_updated_datetime ?? "---"
//        let updatedAtr: NSAttributedString = updated.attributedStringWithColor(["txt_update".localized()], color: HelperClassSwift.acolor.getUIColor())
//        self.lblOnupdated.attributedText = updatedAtr
//        lblOnupdated.font = .kufiRegularFont(ofSize: 15)
//
//        let location = "txt_location".localized() + " : " + Object!.projects_profile_location ?? "---"
//        let locationAtr: NSAttributedString = location.attributedStringWithColor(["txt_location".localized()], color: HelperClassSwift.acolor.getUIColor())
//        self.lblLocation.attributedText = locationAtr
//        lblLocation.font = .kufiRegularFont(ofSize: 15)
        
        
//        self.lblBranchName.text =  "Branch".localized() + " :"
//        self.lblBranchName.font =  .kufiBoldFont(ofSize: 14)
//        self.lblBranchName.textColor =  HelperClassSwift.bcolor.getUIColor()
//
//        self.lblProjectNameEn.text =  "txt_Project_Name_En".localized() + " :"
//        self.lblProjectNameEn.font =  .kufiBoldFont(ofSize: 14)
//        self.lblProjectNameEn.textColor =  HelperClassSwift.bcolor.getUIColor()
        
//        self.lblProjectNameAr.text =  "txt_Project_Name_Ar".localized() + " :"
//        self.lblProjectNameAr.font =  .kufiBoldFont(ofSize: 14)
//        self.lblProjectNameAr.textColor =  HelperClassSwift.bcolor.getUIColor()
        
//        self.lblCustomerName.text =  "Customers".localized() + " :"
//        self.lblCustomerName.font =  .kufiBoldFont(ofSize: 14)
//        self.lblCustomerName.textColor =  HelperClassSwift.bcolor.getUIColor()
//
//        self.lblcustomer_type.text =  "txt_Project_Type".localized() + " :"
//        self.lblcustomer_type.font =  .kufiBoldFont(ofSize: 14)
//        self.lblcustomer_type.textColor =  HelperClassSwift.bcolor.getUIColor()
        
//        self.lblWriter.text =  "Writer".localized() + " :"
//        self.lblWriter.font =  .kufiBoldFont(ofSize: 14)
//        self.lblWriter.textColor =  HelperClassSwift.bcolor.getUIColor()
        
//        self.lblOnDate.text =  "On Date".localized() + " :"
//        self.lblOnDate.font =  .kufiBoldFont(ofSize: 14)
//        self.lblOnDate.textColor =  HelperClassSwift.bcolor.getUIColor()
        
//        self.lblOnupdated.text =  "txt_update".localized() + " :"
//        self.lblOnupdated.font =  .kufiBoldFont(ofSize: 14)
//        self.lblOnupdated.textColor =  HelperClassSwift.bcolor.getUIColor()
        
//        self.lblLocation.text =  "txt_location".localized() + " :"
//        self.lblLocation.font =  .kufiBoldFont(ofSize: 14)
//        self.lblLocation.textColor =  HelperClassSwift.bcolor.getUIColor()
        
//        lblValBranchName.isHidden = true
//        lblValProjectNameEn.isHidden = true
//        lblValProjectNameAr.isHidden = true
//        lblValCustomerName.isHidden = true
//        lblValcustomer_type.isHidden = true
//        lblValWriter.isHidden = true
//        lblValOnDate.isHidden = true
//        lblValOnupdated.isHidden = true
//        lblValLocation.isHidden = true
        
//        self.lblValBranchName.text =  Object?.branch_name
//        self.lblValBranchName.font = .kufiRegularFont(ofSize: 14)
//        self.lblValBranchName.textColor =  HelperClassSwift.bcolor.getUIColor()
//
//        self.lblValProjectNameEn.text =  Object?.projects_profile_name_en
//        self.lblValProjectNameEn.font = .kufiRegularFont(ofSize: 14)
//
//        self.lblValProjectNameAr.text =  Object?.projects_profile_name_ar
//        self.lblValProjectNameAr.font = .kufiRegularFont(ofSize: 14)
//
//        self.lblValCustomerName.text =  Object?.customer_name
//        self.lblValCustomerName.font = .kufiRegularFont(ofSize: 14)
//
//        self.lblValcustomer_type.text =  Object?.customer_type
//        self.lblValcustomer_type.font = .kufiRegularFont(ofSize: 14)
//
//        self.lblValWriter.text =  Object?.writer
//        self.lblValWriter.font = .kufiRegularFont(ofSize: 14)
//
//        self.lblValOnDate.text =  Object?.projects_profile_created_datetime
//        self.lblValOnDate.font = .kufiRegularFont(ofSize: 14)
//
//        self.lblValOnupdated.text =  Object?.projects_profile_updated_datetime
//        self.lblValOnupdated.font = .kufiRegularFont(ofSize: 14)
//
//        self.lblValLocation.text =  Object?.projects_profile_location
//        self.lblValLocation.font = .kufiRegularFont(ofSize: 14)
        
        
        self.lblServices.text =  "Services".localized()
        self.lblServices.font = .kufiRegularFont(ofSize: 17)
        self.lblServices.textColor =  HelperClassSwift.bcolor.getUIColor()
        
        self.lblQuotations.text =  "txt_Quotations".localized()
        self.lblQuotations.font = .kufiRegularFont(ofSize: 15)
        //self.lblQuotations.textColor =  maincolor
        
        self.lblProjects.text =  "txt_Projects".localized()
        self.lblProjects.font = .kufiRegularFont(ofSize: 15)
        //self.lblProjects.textColor =  maincolor
        
        self.SelectedView_project.backgroundColor = maincolor
        self.SelectedView_Quotation.backgroundColor = maincolor
        
//        self.View_project.setBorderGrayNoCorner()
//        self.View_Quotation.setBorderGrayNoCorner()
        
        self.SelectedView_Quotation.isHidden = true
        
//        self.mainView.setBorderGray()
//        self.projectView.setBorderGray()
//        self.projectVieww.setBorderGray()
      
        
       // self.btnAddQuotation.isHidden = true
      
      
       
    }
    
    func is_hide_Qutation(){
        
        if userObj?.is_admin == "1" || add == true {
            self.View_Quotation.isHidden = false
        }else{
            self.View_Quotation.isHidden = true
        }
    }
    
    func setupCollection(){
        
        collectionServieces.delegate = self
        collectionServieces.dataSource = self
        
        
        let nib = UINib(nibName: "SubProjectTVCell", bundle: nil)
        tableProjects.register(nib, forCellReuseIdentifier: "SubProjectTVCell")
        
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
                        self.imgnodata.isHidden = false
                    }else{
                        self.imgnodata.isHidden = true
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
                self.imgnodata.isHidden = false
            }
//            self.lblQuotationsnodata.isHidden = true
            
            
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
                        self.imgnodata.isHidden = false
                    }else{
                        self.imgnodata.isHidden = true
                    }
                    //self.tableQuotation.reloadData()
                    self.hideLoadingActivity()
                }
                
            }else{
                self.imgnodata.isHidden = true
                self.hideLoadingActivity()
                //self.lblQuotationsnodata.isHidden = false
            }
            
            self.is_hide_Qutation()
        }
    }
    
    
    
    
    //MARK: - Get Project Details
    //------------------------------------------------------
    
    
    
    func get_Projects_Details(){
        
        self.showLoadingActivity()
        
        APIManager.sendRequestGetAuth(urlString: "TEd1bgyHSC0GPcq/\(Object!.projects_profile_id)") { (response) in
            
            
            let status = response["status"] as? Bool
            let add = response["add"] as? Bool

            self.add = add ?? false
            self.tableProjects.reloadData()
            //self.tableQuotation.reloadData()
            
            let service_user_data = response["service_user_data"] as? [String:Any]
            if status == true{
                if  let users = service_user_data!["users"] as? NSArray{
                    for i in users {
                        let dict = i as? [String:Any]
                        let obj = ModuleObj.init(dict!)
                        self.arr_Users.append(obj)
                        self.CustomerName.append(obj.label  + "\n")
                    }
                   // self.lblValCustomerName.text = self.CustomerName
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
    
       // self.lblQuotationsnodata.isHidden = true
    }
    
    
    
    func menu_select(){
        let language =  MOLHLanguage.currentAppleLanguage()
        if language == "ar"{
            panel?.openRight(animated: true)
        }else{
            panel?.openLeft(animated: true)
        }
        
    }
    
  
    
    @IBAction func btnProject_Click(_ sender: Any) {
        
        self.IsPrpjectTable = true
        self.tableProjects.reloadData()
        self.SelectedView_project.isHidden = false
        self.SelectedView_Quotation.isHidden = true
        //self.lblProjectTitle.text =  "txt_Projects".localized()
        //self.btnAddQuotation.isHidden = true
        
//        self.lblnodata.isHidden = false
//        self.lblQuotationsnodata.isHidden = true
        
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
       // self.btnAddQuotation.isHidden = false
        self.SelectedView_project.isHidden = true
        self.SelectedView_Quotation.isHidden = false
        //self.lblProjectTitle.text =  "txt_Quotations".localized()
//        self.lblnodata.isHidden = true
//        self.lblQuotationsnodata.isHidden = false
        
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
        
       // let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTVCell", for: indexPath) as! TransactionTVCell
        
        if IsPrpjectTable == true{
            let Projectell = tableView.dequeueReusableCell(withIdentifier: "SubProjectTVCell", for: indexPath) as! SubProjectTVCell
            
            
            let obj = arr_Projectdata[indexPath.item]
            
            let Id =  "ID".localized() + ": \(obj.projects_supervision_id)"
            let Q_No = "Quotation Number".localized() + ": \(obj.projects_quotation_id)"
            let subject = "Subject".localized() + "  \(obj.quotation_subject)"
            let Grand_Total = "\(obj.quotation_grand_total)"
            let Tax_Amount =   "\(obj.quotation_tax_amount)"
            let net_amount =  "\(obj.quotation_net_amount)"
            let ApprovedDate = "Approved Date".localized() + ": \(obj.quotation_approved_date)"
            let writer = "By".localized() + ": \(obj.writer)"
            let date = "\(obj.quotation_created_date)"
            
            
            
            Projectell.lblTaxAmount.text = "Tax Amount".localized()
            Projectell.lblNetAmount.text = "Net Amount".localized()
            Projectell.lblGrandTotal.text = "Grand Total".localized()
            
            if userObj?.is_admin == "1" || self.add == true {
                Projectell.lblSubject.isHidden = false
                Projectell.StackAmount.isHidden = false
                Projectell.lblWriter.isHidden = false
                Projectell.lblDate.isHidden = false
                Projectell.lblApprovedDate.isHidden = false
                Projectell.lblQ_No.isHidden = false
            }else{
                
                Projectell.lblSubject.isHidden = false
                Projectell.StackAmount.isHidden = true
                Projectell.StackDate.isHidden = true
                Projectell.StackWriter.isHidden = true
                Projectell.height.constant = 90
                Projectell.lblWriter.isHidden = true
                Projectell.lblDate.isHidden = true
                Projectell.lblApprovedDate.isHidden = true
                Projectell.lblQ_No.isHidden = true
            }
            
            
            let Idattribute: NSAttributedString = Id.attributedStringWithColor(["ID".localized()], color: maincolor)
            Projectell.lblId.attributedText = Idattribute
            
            let Q_Noattribute: NSAttributedString = Q_No.attributedStringWithColor(["Quotation Number".localized()], color: maincolor)
            Projectell.lblQ_No.attributedText = Q_Noattribute
            
            let Subjectattribute: NSAttributedString = subject.attributedStringWithColor(["Subject".localized()], color: maincolor)
            Projectell.lblSubject.attributedText = Subjectattribute
            
            
            Projectell.lblValGrandTotal.text = Grand_Total
            Projectell.lblValTaxAmount.text = Tax_Amount
            Projectell.lblValNetAmount.text = net_amount
            
            let Writerattribute: NSAttributedString = writer.attributedStringWithColor(["By".localized()], color: maincolor)
            Projectell.lblWriter.attributedText = Writerattribute
            
            let ApprovedDateAtt: NSAttributedString = ApprovedDate.attributedStringWithColor(["Approved Date".localized()], color: maincolor)
            Projectell.lblApprovedDate.attributedText = ApprovedDateAtt
            
          
            Projectell.lblDate.text = date
            
            Projectell.viewBack.layer.applySketchShadow(
              color: .black,
              alpha: 0.6,
              x: 0,
              y: 13,
              blur: 16,
              spread: 0)
            Projectell.viewBack.setRounded(20)
            //Projectell.viewBack.setcorner()
            
            return Projectell
        }
//        else{
//            let obj = arr_data[indexPath.item]
//
//                     let Description = "Quotation Number".localized() + "  \(obj.projects_quotation_id)"
//                     let from = "Subject".localized() + "  \(obj.quotation_subject)"
//                     let to = "Grand Total".localized() + "  \(obj.quotation_grand_total)"
//                     let type = "Tax Amount".localized() + "  \(obj.quotation_tax_amount)"
//                     let Module = "Net Amount".localized() + "  \(obj.quotation_net_amount)"
//
//                     let Submitter = "Approved Date".localized() + "  \(obj.quotation_approved_date)"
//                     let writer = "Writer".localized() + "  \(obj.writer)"
//                     let LastUpdate = "Submitted Date".localized() + "  \(obj.quotation_created_date)"
//                     let Status = "Status".localized() + "New"
//
//
//                     cell.lblKeyDesc.text = Description
//                     cell.lblKeyFrom.text = from
//                     cell.lblKeyTo.text = to
//                     cell.lblKeyType.text = type
//                     cell.lblKeyWriter.text = writer
//                     cell.lblKeyLastUpdate.text = LastUpdate
//                     cell.lblKeySubmitter.text = Submitter
//                     cell.lblKeyModule.text = Module
//                     cell.lblKeyStatus.text = Status
//
//
//                     cell.lblKeyBarCode.isHidden = true
//                     cell.lbKeylNo.isHidden = true
//                     cell.lblKeyBarCode.isHidden = true
//
//
//            let Descriptionattributed: NSAttributedString = Description.attributedStringWithColor(["Quotation Number".localized()], color: HelperClassSwift.acolor.getUIColor())
//                     cell.lblKeyDesc.attributedText = Descriptionattributed
//
//            let fromattributed: NSAttributedString = from.attributedStringWithColor(["Subject".localized()], color: HelperClassSwift.acolor.getUIColor())
//                     cell.lblKeyFrom.attributedText = fromattributed
//
//            let Toattributed: NSAttributedString = to.attributedStringWithColor(["Grand Total".localized()], color: HelperClassSwift.acolor.getUIColor())
//                     cell.lblKeyTo.attributedText = Toattributed
//
//
//
//            let Typeattributed: NSAttributedString = type.attributedStringWithColor(["Tax Amount".localized()], color: HelperClassSwift.acolor.getUIColor())
//                     cell.lblKeyType.attributedText = Typeattributed
//
//
//            let Moduleattributed: NSAttributedString = Module.attributedStringWithColor(["Net Amount".localized()], color: HelperClassSwift.acolor.getUIColor())
//                     cell.lblKeyModule.attributedText = Moduleattributed
//
//            let Writerattributed: NSAttributedString = writer.attributedStringWithColor(["Writer".localized()], color: HelperClassSwift.acolor.getUIColor())
//                     cell.lblKeyWriter.attributedText = Writerattributed
//
//
//
//            let Submitterattributed: NSAttributedString = Submitter.attributedStringWithColor(["Approved Date".localized()], color: HelperClassSwift.acolor.getUIColor())
//                     cell.lblKeySubmitter.attributedText = Submitterattributed
//
//
//            let Lastattributed: NSAttributedString = LastUpdate.attributedStringWithColor(["Submitted Date".localized()], color: HelperClassSwift.acolor.getUIColor())
//                     cell.lblKeyLastUpdate.attributedText = Lastattributed
//
//            let Statusattributed: NSAttributedString = Status.attributedStringWithColor(["Status".localized()], color: HelperClassSwift.acolor.getUIColor())
//                     cell.lblKeyStatus.attributedText = Statusattributed
//
//
//
//                     cell.viewBack.setcorner()
//
//
//                     return cell
//
//        }
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if IsPrpjectTable == true{
            let obj = arr_Projectdata[indexPath.item]
            projects_profile_id = obj.projects_profile_id
            projects_work_area_id = obj.projects_work_area_id
            projects_supervision_id = obj.projects_supervision_id
            let vc:SupervisionOperationVC = AppDelegate.mainSB.instanceVC()
            vc.title =  self.title
            vc.Object = Object
            vc.StrSubMenue =  self.StrSubMenue
            vc.StrMenue = self.StrMenue
            vc.MenuObj = self.MenuObj
            self.navigationController?.pushViewController(vc, animated: true)
//            _ =  panel?.center(vc)
                
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
       // cell.view_img.backgroundColor = HelperClassSwift.acolor.getUIColor()
        
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

 


///https://nahidh.sa/backend/MRpWxXzlMesi27d/1/10?branch_id=&search_services=&search_key=
/////All project
///
