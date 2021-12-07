//
//  NotificationVC.swift
//  Almnabr
//
//  Created by MacBook on 23/11/2021.
//  Copyright © 2021 Samar Akkila. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController {
    
    
    @IBOutlet weak var imgBack: UIButton!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblnodata: UILabel!
    
    @IBOutlet weak var table: UITableView!
    
    
    var arr_data:[NotificationObj] = []
    
    var pageNumber = 1
    var allItemDownloaded = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configGUI()
        
        get_Notificaions_data(showLoading: true, loadOnly: true)
        
    }
    
    
    
    //MARK: - Config GUI
    //------------------------------------------------------
    func configGUI() {
        
        
        lblTitle.font = .kufiBoldFont(ofSize: 20)
        lblTitle.text = "Notification"
        
        
        table.dataSource = self
        table.delegate = self
        let nib = UINib(nibName: "NotificationCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: "NotificationCell")
        
    }
    
    
    
    func get_Notificaions_data(showLoading: Bool, loadOnly: Bool){
        
        if showLoading {
            self.showLoadingActivity()
        }
        
        
        APIManager.sendRequestGetAuth(urlString: "notification/get_noti_list?page=\(pageNumber)" ) { (response) in
            
            
            //self.arr_data.removeAll()
            
            if self.pageNumber == 1 {
                self.arr_data.removeAll()
            }
            let status = response["status"] as? Bool
            if loadOnly {
                self.table.reloadData()
            }
            
            
            let page = response["page"] as? [String:Any]
            if status == true{
                if  let records = response["lists"] as? NSArray{
                    for i in records {
                        let dict = i as? [String:Any]
                        let obj = NotificationObj.init(dict!)
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
                self.hideLoadingActivity()
            }else{
                self.hideLoadingActivity()
                self.lblnodata.isHidden = false
            }
            if self.arr_data.count == 0 {
                self.lblnodata.isHidden = false
            }else{
                self.lblnodata.isHidden = true
            }
            
            self.hideLoadingActivity()
            // self.lblnodata.isHidden = false
        }
    }
    
    
    
    
    func get_Delete_notification(message_id:String){
        
        self.showLoadingActivity()
        
        
        
        APIManager.sendRequestGetAuth(urlString: "notification/delete_noti?noty_messages_id=\(message_id)" ) { (response) in
            
            
            let status = response["status"] as? Bool
            
            if status == true{
                self.get_Notificaions_data(showLoading: true, loadOnly: true)
                
                self.showAMessage(withTitle: "success", message: "The notification was deleted successfully")
            }else{
                self.showAMessage(withTitle: "error", message: "The notification wasn't  deleted ")
            }
            
            
            self.hideLoadingActivity()
            // self.lblnodata.isHidden = false
        }
    }
    
    
    
    
    @IBAction func btn_back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
}



extension NotificationVC: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        
        let obj = arr_data[indexPath.item]
        
        cell.lblDate.text = obj.noty_messages_date_time
        cell.lblTitle.text = obj.noty_messages_title
        cell.lblSubTitle.text = obj.noty_messages_body
        
        cell.lblDate.font = .kufiRegularFont(ofSize: 13)
        cell.lblTitle.font = .kufiBoldFont(ofSize: 16)
        cell.lblSubTitle.font = .kufiRegularFont(ofSize: 15)
        
        cell.btnDeleteAction = {
            () in
            self.get_Delete_notification(message_id:obj.noty_messages_id)
        }
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //                let obj = arr_data[indexPath.item]
        //                let vc:ProjectDetailsVC = AppDelegate.mainSB.instanceVC()
        //                vc.title =  self.title
        //                vc.Object = obj
        //                vc.MenuObj = self.MenuObj
        //                vc.StrSubMenue =  self.StrSubMenue
        //                vc.StrMenue = self.StrMenue
        //                _ =  panel?.center(vc)
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
            get_Notificaions_data(showLoading: false, loadOnly: true)
        }
    }
}

