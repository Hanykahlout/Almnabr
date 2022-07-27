//
//  VactionDetailsViewController.swift
//  Almnabr
//
//  Created by Hany Alkahlout on 24/07/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import UIKit

class VactionDetailsViewController: UIViewController {

    
    @IBOutlet weak var empNameLabel: UILabel!
    @IBOutlet weak var mobileNumberlabel: UILabel!
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var branchLabel: UILabel!
    @IBOutlet weak var joiningDateLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var vactionTypeLabel: UILabel!
    @IBOutlet weak var vactionDaysLabel: UILabel!
    @IBOutlet weak var vactionStartDateLabel: UILabel!
    @IBOutlet weak var vactionEndDate: UILabel!
    @IBOutlet weak var afterVacationLabel: UILabel!
    @IBOutlet weak var paidAmountLabel: UILabel!
    @IBOutlet weak var directManagerLabel: UILabel!
    
    @IBOutlet weak var finButton: UIButton!
    var finData = [Finance]()
    override func viewDidLoad() {
        super.viewDidLoad()
        initlziation()
        // Do any additional setup after loading the view.
    }
    
    private func initlziation(){
        finButton.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    @IBAction func financialDetailsAction(_ sender: Any) {
        let vc = FinanceInfoViewController()
        vc.data = finData
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setData(data:FormHrv1VacationData?){
        
        empNameLabel.text = data?.employee_number ?? ""
        mobileNumberlabel.text = data?.primary_mobile ?? ""
        jobTitleLabel.text = data?.job_title ?? ""
        branchLabel.text = data?.branch ?? ""
        joiningDateLabel.text = "\(data?.joining_start_date_english ?? "") - \(data?.joining_start_date_arabic ?? "")"
        emailLabel.text = data?.primary_email ?? ""
        vactionTypeLabel.text = data?.vacation_type ?? ""
        vactionDaysLabel.text = data?.vacation_total_days ?? ""
        vactionStartDateLabel.text = "\(data?.vacation_start_date_english ?? "") - \(data?.vacation_start_date_arabic ?? "")"
        vactionEndDate.text = "\(data?.vacation_end_date_english ?? "") - \(data?.vacation_end_date_arabic ?? "")"
        afterVacationLabel.text = "\(data?.after_vacation_working_date_english ?? "") - \(data?.after_vacation_working_date_arabic ?? "")"
        paidAmountLabel.text = data?.vacation_total_paid_amount ?? ""
        directManagerLabel.text = data?.direct_manager_name ?? ""
        getFinicalData(data: data)
        
    }
    
}

// MARK: - API Hangling

extension VactionDetailsViewController{
    
    private func getFinicalData(data:FormHrv1VacationData?){
        showLoadingActivity()
        APIController.shard.showSelectionVactionResult(empNum: data?.employee_number ?? "" , vacation_type_id: data?.vacation_type_id ?? "", beforeDate: data?.before_vacation_working_date_english ?? "", afterDate: data?.after_vacation_working_date_english ?? "") { data in
            DispatchQueue.main.async {
                self.hideLoadingActivity()
                if let status = data.status,status{
                    self.finButton.isHidden = false
                    self.finData = data.result?.finance ?? []
                    
                    // height of the view that inside the first view in the vc which is scrollview
                    let height = self.view.subviews.first?.subviews.first?.bounds.height ?? 0.0
                    NotificationCenter.default.post(name: .init("ResetMainViewHeight"), object: height)
                    
                    
                }else{
                    self.finButton.isHidden = true
                    print("The fucking error is : \(data.error ?? "Noopooo")")
                }
            }
            
        }
        
    }
    
}
