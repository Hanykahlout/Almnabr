//
//  ContactsVC.swift
//  Almnabr
//
//  Created by MacBook on 20/10/2021.
//  Copyright © 2021 Samar Akkila. All rights reserved.
//
import UIKit
import DPLocalization
import FontAwesome_swift
import DropDown

class ContactsVC: UIViewController {
    
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblnodata: UILabel!
    
    @IBOutlet weak var lblContact: UILabel!
    
    @IBOutlet weak var viewContact: UIView!
    
    @IBOutlet weak var btnContact: UIButton!
    
    @IBOutlet weak var imgDropContact: UIImageView!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var StrTitle:String = ""
    var StrSubMenue:String = ""
    var StrContact:String = ""
    var SearchKey:String = ""
    
    
    var pageNumber = 1
    var total:Int = 0
    var allItemDownloaded = false
    var MenuObj:MenuObj?
    var SubMenuObj:MenuObj?
    var arr_data:[ContactObj] = []
    var arr_ContactLabel:[String] = ["All".localized(),"Contractors".localized(),"Customers".localized(),"Others".localized()]
    var arr_Contactvalue:[String] = ["","1","2","3"]
    var arr_NoData:[String] = ["No items found".localized()]
    
    let dropUpmage =  UIImage.fontAwesomeIcon(name: .chevronUp , style: .solid, textColor:  .gray, size: CGSize(width: 40, height: 40))
    
    let dropDownmage =  UIImage.fontAwesomeIcon(name: .chevronDown , style: .solid, textColor:  .gray, size: CGSize(width: 40, height: 40))
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        configGUI()
        get_Contact_data(showLoading: true, loadOnly: true)
        
        
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
        
        
        self.viewContact.setBorderGray()
        self.lblContact.text =  "All".localized()
        self.lblContact.font = .kufiRegularFont(ofSize: 15)
        
        
        searchBar.delegate = self
        btnContact.isHidden = true
        
        self.mainView.setBorderGray()
        
        self.lblTitle.text =  "Contacts".localized()
        self.lblnodata.isHidden = false
        
        
        self.imgDropContact.image = dropDownmage
        
        
        table.dataSource = self
        table.delegate = self
        let nib = UINib(nibName: "TransactionTVCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: "TransactionTVCell")
        
        
    }
    
    func get_Contact_data(showLoading: Bool, loadOnly: Bool){
        
        if showLoading {
            self.showLoadingActivity()
        }
        let search:String = SearchKey.replacingOccurrences(of: " ", with: "%20").trim()
        
        APIManager.sendRequestGetAuth(urlString: "ckhGSW9rIyAlGX6/\(projects_profile_id)/\(projects_supervision_id)/\(pageNumber)/10?searchKey=\(search)&contacts_type=\(StrContact)" ) { (response) in
            
            if self.pageNumber == 1 {
                self.arr_data.removeAll()
            }
            let status = response["status"] as? Bool
            // let total = response["total"] as? Int
            if loadOnly {
                self.table.reloadData()
            }
            
            let page = response["page"] as? [String:Any]
            // let list = response["list"] as? [String:Any]
            if status == true{
                //   self.total = total!
                
                if  let records = response["records"] as? NSArray{
                    for i in records {
                        let dict = i as? [String:Any]
                        let obj = ContactObj.init(dict!)
                        self.arr_data.append(obj)
                    }
                    
                    let pageObj = PageObj(page!)
                    
                    
                    if self.arr_data.count == 0 {
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
    
    
//    func get_Contact(){
//
//        self.showLoadingActivity()
//        APIManager.sendRequestGetAuth(urlString: "/366484fd45" ) { (response) in
//
//
//            let status = response["status"] as? Bool
//            if status == true{
//                if  let list = response["records"] as? NSArray{
//                    for i in list {
//                        let dict = i as? [String:Any]
//                        let obj = ModuleObj.init(dict!)
//                        self.arr_Contact.append(obj)
//
//                        self.arr_ContactLabel.append(obj.label)
//
//
//                    }
//                    self.hideLoadingActivity()
//                }
//            }
//            self.hideLoadingActivity()
//
//        }
//    }
    
    
    
    @IBAction func btnContact_Click(_ sender: Any) {
        
        self.imgDropContact.image = dropUpmage
        let dropDown = DropDown()
        dropDown.anchorView = view
        dropDown.backgroundColor = .white
        dropDown.cornerRadius = 2.0
        
        if self.arr_ContactLabel.count == 0 {
            dropDown.dataSource = self.arr_NoData
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                self.imgDropContact.image = dropDownmage
            }
            dropDown.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }else{
            
        dropDown.dataSource = self.arr_ContactLabel
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            if item == self.arr_ContactLabel[index] {
                self.lblContact.text =  item
                let i =  self.arr_Contactvalue[index]
                self.StrContact = i
                self.imgDropContact.image = dropDownmage
                //self.btnContact.isHidden = false
                get_Contact_data(showLoading: true, loadOnly: true)
                
            }
            
        }}
        dropDown.direction = .bottom
        dropDown.anchorView = viewContact
        dropDown.bottomOffset = CGPoint(x: 0, y: viewContact.bounds.height)
        dropDown.width = viewContact.bounds.width
        dropDown.show()
    }
    
    
    @IBAction func btnContactDelete_Click(_ sender: Any) {
        self.lblContact.text = "All".localized()
        self.btnContact.isHidden = true
        self.StrContact = ""
        get_Contact_data(showLoading: true, loadOnly: true)
    }
    
}


extension ContactsVC: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTVCell", for: indexPath) as! TransactionTVCell
        
        let obj = arr_data[indexPath.item]
        
        let no =  "Name".localized() + "  \(obj.contacts_name)"
        let Description = "Type".localized() + "  \(obj.contacts_type)"
        let from = "Email".localized() + "  \(obj.contacts_email)"
        let to = "Mobile".localized() + "  \(obj.contacts_mobile)"
        
        let Submitter = "Whatsapp".localized() + "  \(obj.contacts_whatsapp)"
        let Status = "Fax".localized() + "  \(obj.contacts_fax)"
        let writer = "Writer".localized() + "  \(obj.writer)"
        let LastUpdate = "On Date".localized() + "  \(obj.contacts_created_datetime)"
        
        
        cell.lbKeylNo.text = no
        cell.lblKeyDesc.text = Description
        cell.lblKeyFrom.text = from
        cell.lblKeyTo.text = to
        cell.lblKeyWriter.text = writer
        cell.lblKeyLastUpdate.text = LastUpdate
        cell.lblKeySubmitter.text = Submitter
        cell.lblKeyStatus.text = Status
        
        cell.lblKeyModule.isHidden = true
        cell.lblKeyBarCode.isHidden = true
        cell.lblKeyType.isHidden = true
        
        
        let attributedWithTextColor: NSAttributedString = no.attributedStringWithColor(["Name".localized()], color: HelperClassSwift.acolor.getUIColor())
        cell.lbKeylNo.attributedText = attributedWithTextColor
        
        let Descriptionattributed: NSAttributedString = Description.attributedStringWithColor(["Type".localized()], color: HelperClassSwift.acolor.getUIColor())
        cell.lblKeyDesc.attributedText = Descriptionattributed
        
        let fromattributed: NSAttributedString = from.attributedStringWithColor(["Email".localized()], color: HelperClassSwift.acolor.getUIColor())
        cell.lblKeyFrom.attributedText = fromattributed
        
        let Toattributed: NSAttributedString = to.attributedStringWithColor(["Mobile".localized()], color: HelperClassSwift.acolor.getUIColor())
        cell.lblKeyTo.attributedText = Toattributed
        
        
        let Writerattributed: NSAttributedString = writer.attributedStringWithColor(["Writer".localized()], color: HelperClassSwift.acolor.getUIColor())
        cell.lblKeyWriter.attributedText = Writerattributed
        
        
        let Lastattributed: NSAttributedString = LastUpdate.attributedStringWithColor(["On Date".localized()], color: HelperClassSwift.acolor.getUIColor())
        cell.lblKeyLastUpdate.attributedText = Lastattributed
        
        
        let Submitterattributed: NSAttributedString = Submitter.attributedStringWithColor(["Whatsapp".localized()], color: HelperClassSwift.acolor.getUIColor())
        cell.lblKeySubmitter.attributedText = Submitterattributed
        
        let Statusattributed: NSAttributedString = Status.attributedStringWithColor(["Fax".localized()], color: HelperClassSwift.acolor.getUIColor())
        cell.lblKeyStatus.attributedText = Statusattributed
        
        
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
            get_Contact_data(showLoading: false, loadOnly: false)
        }
    }
}

extension ContactsVC:UISearchBarDelegate {
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
       self.SearchKey = searchBar.text!
        get_Contact_data(showLoading: false, loadOnly: false)
    }

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
}
