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
    @IBOutlet weak var imgnodata: UIImageView!
    
    @IBOutlet weak var table: UITableView!
    
    
    var arr_data:[NotificationObj] = []
    
    var pageNumber = 1
    var allItemDownloaded = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configGUI()
        configNavigation()
        get_Notificaions_data(showLoading: true, loadOnly: true)
        
    }
    
    
    
    //MARK: - Config GUI
    //------------------------------------------------------
    func configGUI() {
        
        table.dataSource = self
        table.delegate = self
        let nib = UINib(nibName: "NotificationCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: "NotificationCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the Navigation Bar
        if self.isMovingFromParent {
            self.update_Notification()
            //  self.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Config Navigation
    func configNavigation() {
        
        _ = self.navigationController?.preferredStatusBarStyle
        self.view.backgroundColor = maincolor //F0F4F8
        //navigationController?.navigationBar.barTintColor = .buttonBackgroundColor()
        navigationController?.navigationBar.barTintColor = maincolor
        addNavigationBarTitle(navigationTitle: "Notifications".localized())
        UINavigationBar.appearance().backgroundColor = maincolor
    }
    
    
    
    func get_Notificaions_data(showLoading: Bool, loadOnly: Bool){
        
        if showLoading {
            self.showLoadingActivity()
        }

        APIController.shard.sendRequestGetAuth(urlString: "notification/get_noti_list?page=\(pageNumber)" ) { (response) in
            
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
                        self.imgnodata.isHidden = false
                    }else{
                        self.imgnodata.isHidden = true
                    }
                    self.table.reloadData()
                    self.hideLoadingActivity()
                }
                self.hideLoadingActivity()
            }else{
                self.hideLoadingActivity()
                self.imgnodata.isHidden = false
            }
            if self.arr_data.count == 0 {
                self.imgnodata.isHidden = false
            }else{
                self.imgnodata.isHidden = true
            }
            
            self.hideLoadingActivity()
        }
    }
    
    
    
    
    func get_Delete_notification(message_id:String){
        
        self.showLoadingActivity()
        
        
        
        APIController.shard.sendRequestGetAuth(urlString: "notification/delete_noti?noty_messages_id=\(message_id)" ) { (response) in
            
            
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
        self.table.removeFromSuperview()
        self.view.removeFromSuperview()
        
        
    }
    
    private func update_Notification() {
        NotificationCenter.default.post(name: NSNotification.Name("update_Function"),
                                        object: nil)
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
        
        cell.lblDate.font = .kufiRegularFont(ofSize: 12)
        cell.lblTitle.font = .kufiRegularFont(ofSize: 13)
        cell.lblSubTitle.font = .kufiRegularFont(ofSize: 12)
        
        cell.btnDeleteAction = {
            () in
            self.get_Delete_notification(message_id:obj.noty_messages_id)
        }
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let obj = arr_data[indexPath.item]
        
        if let ios = obj.extra_data["ios"] as? String {
            if ios != "" {
                if let typeUrl = obj.extra_data["urlType"] as? String,typeUrl == "pdf"{
                    showLoadingActivity()
                    APIController.shard.getImage(url: ios) { data in
                        DispatchQueue.main.async {
                            self.hideLoadingActivity()
                            if let status = data.status,status{
                                let vc = WebViewViewController()
                                vc.data = data
                                self.navigationController?.present(UINavigationController(rootViewController: vc), animated: true)
                            }else{
                                let alertVC = UIAlertController(title: "error".localized(), message: data.error ?? "", preferredStyle: .alert)
                                alertVC.addAction(.init(title: "Cancel".localized(), style: .cancel))
                                self.present(alertVC, animated: true)
                            }
                        }
                    }
                }else{
                    if ios.contains("transactions") {
                        let requestArr = ios.components(separatedBy: "/")
                        if ios.contains("FORM_HRV1"){
                            // Vaction Form
                            if let last = requestArr.last {
                                let vc = VactionViewController()
                                vc.transaction_request_id = last
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }else if ios.contains("FORM_WIR"){
                            // WIR Form
                            let splitString = ios.components(separatedBy: "ios/transactions")
                            let vc: TransactionFormDetailsVC = AppDelegate.TransactionSB.instanceVC()
                            vc.str_url = "\(splitString[1])"
                            vc.IsFromNotification = true
                            self.navigationController?.pushViewController(vc, animated: true)
                        }else if ios.contains("FORM_CT1"){
                            // New Contract Form
                            if let last = requestArr.last{
                                let vc = NewContractVC()
                                vc.transaction_request_id = last
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                        
                    }else if  ios.contains("task") {
                        let vc:TaskDetailVC = AppDelegate.TicketSB.instanceVC()
                        vc.task_id =  String(ios.split(separator: "/").last ?? "")
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
            
        }
        
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

