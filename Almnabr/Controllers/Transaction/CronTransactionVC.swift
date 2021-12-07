//
//  CronTransactionVC.swift
//  Almnabr
//
//  Created by MacBook on 04/10/2021.
//  Copyright © 2021 Samar Akkila. All rights reserved.
//

import UIKit
import DPLocalization
import FontAwesome_swift
import DropDown

class CronTransactionVC: UIViewController {
    
    @IBOutlet weak var viewTheme: UIView!
    @IBOutlet weak var header: HeaderView!
    @IBOutlet weak var btnMenu: UIView!
    @IBOutlet weak var imgNext1: UIImageView!
    @IBOutlet weak var imgNext2: UIImageView!
    
    @IBOutlet weak var lblHome: UIButton!
    @IBOutlet weak var lblMenuName: UILabel!
    @IBOutlet weak var lblSubMenuName: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblnodata: UILabel!
    
    @IBOutlet weak var btnRefrsh: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var collection: UICollectionView!
    
    var StrTitle:String = ""
    var StrSubMenue:String = ""
    
    var pageNumber = 1
    var allItemDownloaded = false
    var MenuObj:MenuObj?
    var SubMenuObj:MenuObj?
    var arr_data:[CronJobObj] = []
  
    var cellWidths: [CGFloat] = [700]
    
    let fontStyle: FontAwesomeStyle = .solid
    

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        configGUI()
        get_Transaction_data(showLoading: true, loadOnly: true)
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
        
        
        self.lblHome.titleLabel?.text =  "Home".localized()
        self.lblHome.titleLabel?.font = .kufiRegularFont(ofSize: 15)
        
        
        self.lblnodata.text =  "txt_NoData".localized()
        self.lblnodata.font = .kufiRegularFont(ofSize: 15)
        self.lblnodata.isHidden = true
        
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
        APIManager.sendRequestGetAuth(urlString: "/tc/cronjoblist" ) { (response) in
            
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
                        let obj = CronJobObj.init(dict!)
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

    
    
    
    func menu_select(){
        let language = dp_get_current_language()
        if language == "ar"{
            panel?.openRight(animated: true)
        }else{
            panel?.openLeft(animated: true)
        }
  
    }
    
    
    @IBAction func btnRefresh_Click(_ sender: Any) {
       
        get_Transaction_data(showLoading: true, loadOnly: true)
    }
    
}



extension CronTransactionVC: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTVCell", for: indexPath) as! TransactionTVCell
        
        let obj = arr_data[indexPath.item]
        
       
        
        let no =  "No.".localized() + "  \(obj.transaction_request_id)"
        let Description = "Form Name".localized() + "  \(obj.transaction_key)"
        let from = "Attempt".localized() + "  \(obj.transactions_cronjob_last_update)"
        let to = "Last Update".localized() + "  \(obj.transactions_cronjob_last_update)"
        let type = "Error".localized() + "  \(obj.transactions_cronjob_err)"
        
        cell.lbKeylNo.text = no
        cell.lblKeyDesc.text = Description
        cell.lblKeyFrom.text = from
        cell.lblKeyTo.text = to
        cell.lblKeyType.text = type
        
        cell.lblKeyBarCode.isHidden = true
        cell.lblKeyStatus.isHidden = true
        cell.lblKeyModule.isHidden = true
        cell.lblKeySubmitter.isHidden = true
        cell.lblKeyLastUpdate.isHidden = true
        cell.lblKeyStatus.isHidden = true
        cell.lblKeyWriter.isHidden = true
        
        let attributedWithTextColor: NSAttributedString = no.attributedStringWithColor(["No.".localized()], color: HelperClassSwift.acolor.getUIColor())
        cell.lbKeylNo.attributedText = attributedWithTextColor
        
        let Descriptionattributed: NSAttributedString = Description.attributedStringWithColor(["Form Name".localized()], color: HelperClassSwift.acolor.getUIColor())
        cell.lblKeyDesc.attributedText = Descriptionattributed
        
        let fromattributed: NSAttributedString = from.attributedStringWithColor(["Attempt".localized()], color: HelperClassSwift.acolor.getUIColor())
        cell.lblKeyFrom.attributedText = fromattributed
        
        let Toattributed: NSAttributedString = to.attributedStringWithColor(["Last Update".localized()], color: HelperClassSwift.acolor.getUIColor())
        cell.lblKeyTo.attributedText = Toattributed
        
        
       
        let Typeattributed: NSAttributedString = type.attributedStringWithColor(["Error".localized()], color: HelperClassSwift.acolor.getUIColor())
        cell.lblKeyType.attributedText = Typeattributed
        
        
        cell.btnDelete.isHidden = false
        
        
        cell.viewBack.setcorner()
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white
        cell.selectedBackgroundView = backgroundView
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.tag == 0 {
            
            
            print(indexPath.item)
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
    
