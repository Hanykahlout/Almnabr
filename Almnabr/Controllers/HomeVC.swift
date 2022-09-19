//
//  HomeVC.swift
//  Almnabr
//
//  Created by MacBook on 24/09/2021.
//  Copyright © 2021 Samar Akkila. All rights reserved.
//

import UIKit
import DPLocalization
import WebKit
import PassKit
import CoreNFC
import SocketIO
import SCLAlertView

var userObj :UserObj?
var arr_Menu : [MenuObj]?

class HomeVC: UIViewController   {
    
    @IBOutlet weak var viewTheme: UIView!
    @IBOutlet weak var btnMenu: UIView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var header: HeaderView!
    @IBOutlet weak var tf_message: UITextField!
    @IBOutlet weak var lbl_allCopyRes: UILabel!
    
    @IBOutlet weak var incompleteTasksLabel: UILabel!
    @IBOutlet weak var pendingTransactionLabel: UILabel!
    @IBOutlet weak var employeeNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var contractEndDateLabel: UILabel!
    @IBOutlet weak var joiningDateEnglishLabel: UILabel!
    @IBOutlet weak var passportExpiryDateEnglishLabel: UILabel!
    @IBOutlet weak var iqamaExpiryDateLabel: UILabel!
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var nationalityLabel: UILabel!
    @IBOutlet weak var balanceVocationPaidDaysLabel: UILabel!
    @IBOutlet weak var vacationDeservedPaidDaysLabel: UILabel!
    @IBOutlet weak var totalDetectionDaysLabel: UILabel!
    @IBOutlet weak var paidDaysLabel: UILabel!
    @IBOutlet weak var unpaidDaysLabel: UILabel!
    @IBOutlet weak var employeeAllContractWorkedDaysLabel: UILabel!
    @IBOutlet weak var employeeActiveContractTotalDaysLabel: UILabel!
    @IBOutlet weak var remainingWorkingDaysLabel: UILabel!
    @IBOutlet weak var workingDaysPerYearLabel: UILabel!
    @IBOutlet weak var membershipExpiryDateEnglishLabel: UILabel!
    
    var session: NFCNDEFReaderSession?
    var message:String = ""
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        SocketIOController.shard.connect()
        get_Userdata()
        header.btnAction = menu_select
        check_notifi()
        
        self.lbl_allCopyRes.font = .kufiRegularFont(ofSize: 12)

    
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        getDashboardData()
    }
    
    
    func get_Userdata(){
        //self.showLoadingActivity()
        
        APIManager.sendRequestGetAuth(urlString: "user?user_id=\(Auth_User.user_id)" ) { (response) in
            self.hideLoadingActivity()
            
            let status = response["status"] as? Bool
            if status == true{
                if  let records = response["result"] as? NSArray{
                    
                    for i in records {
                        let dict = i as? [String:Any]
                        let obj = UserObj.init(dict!)
                        userObj = obj
                    }
                }
            }
        }
    }
    
    
    func menu_select(){
        let language =  L102Language.currentAppleLanguage()
        if language == "ar"{
            panel?.openRight(animated: true)
        }else{
            panel?.openLeft(animated: true)
        }
        
    }
    
    func Notification_select(){
        let vc:NotificationVC = AppDelegate.mainSB.instanceVC()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func buttonMenuAction(sender: UIButton!) {
        
        let language =  L102Language.currentAppleLanguage()
        if language == "ar"{
            panel?.openRight(animated: true)
        }else{
            panel?.openLeft(animated: true)
        }
    }
    
    
    
}
extension HomeVC {
    func check_notifi() {
        didLoadHome = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            NotifiRoute.shared.check_notifi()
        }
    }
}
//MARK: - API Handling
extension HomeVC{
    private func getDashboardData(){
        showLoadingActivity()
        APIController.shard.getDashboardData { [unowned self] data in
            self.hideLoadingActivity()
            if let status = data.status , status {
                
                self.incompleteTasksLabel.text = data.employee_tasks?.incomplete_tasks ?? "----"
                self.pendingTransactionLabel.text = data.employee_tasks?.total_pending_transaction ?? "----"
                self.employeeNameLabel.text = data.employee_info?.employee_name ?? "----"
                self.statusLabel.text = data.employee_info?.employee_status == "1" ? "Active" : "Inavtive"
                self.contractEndDateLabel.text = data.employee_info?.contract_actual_end_date ?? "----"
                self.joiningDateEnglishLabel.text = data.employee_info?.first_joining_date ?? "--"
                self.passportExpiryDateEnglishLabel.text = data.employee_info?.passport_expiry_date_english ?? "----"
                self.iqamaExpiryDateLabel.text = data.employee_info?.iqama_expiry_date_english ?? "----"
                self.jobTitleLabel.text = data.employee_info?.job_title_iqama ?? "----"
                self.nationalityLabel.text = data.employee_info?.nationality ?? "----"
                self.balanceVocationPaidDaysLabel.text = data.extra_data?.balance_vocation_paid_days ?? "----"
                self.vacationDeservedPaidDaysLabel.text = data.extra_data?.vacation_deserved_paid_days ?? "----"
                self.totalDetectionDaysLabel.text = data.extra_data?.total_detection_days ?? "----"
                self.paidDaysLabel.text = data.extra_data?.paid_days ?? "----"
                self.unpaidDaysLabel.text = data.extra_data?.unpaid_days ?? "----"
                self.employeeAllContractWorkedDaysLabel.text = "\(data.extra_data?.employee_all_contract_worked_days ?? 0)"
                self.employeeActiveContractTotalDaysLabel.text = "\(data.extra_data?.employee_active_contract_total_days ?? 0)"
                self.remainingWorkingDaysLabel.text = "\(data.extra_data?.employee_remaining_working_days ?? 0)"
                self.workingDaysPerYearLabel.text = "\(data.extra_data?.working_days_per_year ?? 0)"
                self.membershipExpiryDateEnglishLabel.text = "----"
                
            }
        }
    }
}
