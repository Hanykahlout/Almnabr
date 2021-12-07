//
//  TeamUserVC.swift
//  Almnabr
//
//  Created by MacBook on 19/10/2021.
//  Copyright © 2021 Samar Akkila. All rights reserved.
//

import UIKit
import DPLocalization
import FontAwesome_swift
import DropDown

class TeamUserVC: UIViewController {

   
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblnodata: UILabel!
    
    @IBOutlet weak var lblPosition: UILabel!
    
    @IBOutlet weak var viewPosition: UIView!
    
    @IBOutlet weak var btnPosition: UIButton!
    
    @IBOutlet weak var imgDropPosition: UIImageView!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var StrTitle:String = ""
    var StrSubMenue:String = ""
    var StrPosition:String = ""
    var SearchKey:String = ""
    
   
    var pageNumber = 1
    var total:Int = 0
    var allItemDownloaded = false
    var MenuObj:MenuObj?
    var SubMenuObj:MenuObj?
    var arr_data:[projectQuotObj] = []
    var arr_Position:[ModuleObj] = []
    var arr_PositionLabel:[String] = []
    var arr_NoData:[String] = ["No items found".localized()]
    
    let dropUpmage =  UIImage.fontAwesomeIcon(name: .chevronUp , style: .solid, textColor:  .gray, size: CGSize(width: 40, height: 40))
    
    let dropDownmage =  UIImage.fontAwesomeIcon(name: .chevronDown , style: .solid, textColor:  .gray, size: CGSize(width: 40, height: 40))
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        configGUI()
        get_TeamUsers_data(showLoading: true, loadOnly: true)
        get_Position()
       
        
        
        
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
      
        
        self.viewPosition.setBorderGray()
        self.lblPosition.text =  "txt_Position".localized()
        self.lblPosition.font = .kufiRegularFont(ofSize: 15)
        
        
        
        btnPosition.isHidden = true
      
        self.mainView.setBorderGray()
        
        self.lblTitle.text =  "Team Users".localized()
        self.lblnodata.isHidden = false
        searchBar.delegate = self
        
        self.imgDropPosition.image = dropDownmage
        
        table.dataSource = self
        table.delegate = self
        let nib = UINib(nibName: "TransactionTVCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: "TransactionTVCell")
       
        
    }
    
    func get_TeamUsers_data(showLoading: Bool, loadOnly: Bool){
        
        if showLoading {
            self.showLoadingActivity()
        }
        let search:String = SearchKey.replacingOccurrences(of: " ", with: "%20").trim()
        
        APIManager.sendRequestGetAuth(urlString: "PMypAe3X1IuW3jx/\(projects_profile_id)/\(projects_work_area_id)/\(pageNumber)/10?searchKey=\(search)&positions=\(StrPosition)" ) { (response) in
            
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
                        let obj = projectQuotObj.init(dict!)
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
    
    
    func get_Position(){
        
        self.showLoadingActivity()
        APIManager.sendRequestGetAuth(urlString: "/366484fd45" ) { (response) in
            
            
            let status = response["status"] as? Bool
            if status == true{
                if  let list = response["records"] as? NSArray{
                    for i in list {
                        let dict = i as? [String:Any]
                        let obj = ModuleObj.init(dict!)
                        self.arr_Position.append(obj)
                        
                        self.arr_PositionLabel.append(obj.label)
                      
                        
                    }
                    self.hideLoadingActivity()
                }
            }
            self.hideLoadingActivity()
            
        }
    }
    
 
    
    @IBAction func btnPosition_Click(_ sender: Any) {
        
        self.imgDropPosition.image = dropUpmage
        let dropDown = DropDown()
        dropDown.anchorView = view
        dropDown.backgroundColor = .white
        dropDown.cornerRadius = 2.0
        
        
        if self.arr_PositionLabel.count == 0 {
            dropDown.dataSource = self.arr_NoData
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                self.imgDropPosition.image = dropDownmage
            }
            dropDown.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }else{
        dropDown.dataSource = self.arr_PositionLabel
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            if item == self.arr_PositionLabel[index] {
                self.lblPosition.text =  item
                let i =  self.arr_Position[index]
                self.StrPosition = i.value
                self.btnPosition.isHidden = false
                self.imgDropPosition.image = dropDownmage
                get_TeamUsers_data(showLoading: true, loadOnly: true)
              
            }
            
        }}
    
        dropDown.direction = .bottom
        dropDown.anchorView = viewPosition
        dropDown.bottomOffset = CGPoint(x: 0, y: viewPosition.bounds.height)
        dropDown.width = viewPosition.bounds.width
        dropDown.show()
    }
    
    
    @IBAction func btnPositionDelete_Click(_ sender: Any) {
        self.lblPosition.text = "txt_Position".localized()
        self.btnPosition.isHidden = true
        self.StrPosition = ""
        get_TeamUsers_data(showLoading: true, loadOnly: true)
    }
    
}


extension TeamUserVC: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTVCell", for: indexPath) as! TransactionTVCell
        
        let obj = arr_data[indexPath.item]
        
        let no =  "Name".localized() + "  \(obj.label)"
        let Description = "Title".localized() + "  \(obj.teamtitle)"
        let from = "Positions".localized() + "  \(obj.position)"
        let to = "Role".localized() + "  \(obj.project_user_group_mention_key)"
        let writer = "Writer".localized() + "  \(obj.writer)"
        let LastUpdate = "On Date".localized() + "  \(obj.project_user_group_created_datetime)"
        
        
        cell.lbKeylNo.text = no
        cell.lblKeyDesc.text = Description
        cell.lblKeyFrom.text = from
        cell.lblKeyTo.text = to
        cell.lblKeyWriter.text = writer
        cell.lblKeyLastUpdate.text = LastUpdate
        
        cell.lblKeyModule.isHidden = true
        cell.lblKeyBarCode.isHidden = true
        cell.lblKeyType.isHidden = true
        cell.lblKeySubmitter.isHidden = true
        
        cell.lblKeyStatus.isHidden = true
        
        
        let attributedWithTextColor: NSAttributedString = no.attributedStringWithColor(["Name".localized()], color: HelperClassSwift.acolor.getUIColor())
        cell.lbKeylNo.attributedText = attributedWithTextColor
        
        let Descriptionattributed: NSAttributedString = Description.attributedStringWithColor(["Title".localized()], color: HelperClassSwift.acolor.getUIColor())
        cell.lblKeyDesc.attributedText = Descriptionattributed
        
        let fromattributed: NSAttributedString = from.attributedStringWithColor(["Positions".localized()], color: HelperClassSwift.acolor.getUIColor())
        cell.lblKeyFrom.attributedText = fromattributed
        
        let Toattributed: NSAttributedString = to.attributedStringWithColor(["Role".localized()], color: HelperClassSwift.acolor.getUIColor())
        cell.lblKeyTo.attributedText = Toattributed
        
        
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
            get_TeamUsers_data(showLoading: false, loadOnly: false)
        }
    }
}


extension TeamUserVC:UISearchBarDelegate {
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
       self.SearchKey = searchBar.text!
        get_TeamUsers_data(showLoading: false, loadOnly: false)
    }

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //searchBar.resignFirstResponder()
        self.SearchKey = searchBar.text!
         get_TeamUsers_data(showLoading: false, loadOnly: false)
        searchBar.resignFirstResponder()
    }
    
    
}
