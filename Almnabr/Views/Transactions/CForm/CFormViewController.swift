//
//  CFormViewController.swift
//  Almnabr
//
//  Created by Hany Alkahlout on 22/12/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import UIKit
import SCLAlertView
class CFormViewController: UIViewController {

    
    @IBOutlet weak var transactionNumberLabel: UILabel!
    @IBOutlet weak var requestNumberLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var createdByLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var moduleLabel: UILabel!
    
    @IBOutlet weak var responseFormTitleLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var attachmentLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toOrganizationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    @IBOutlet weak var issueDateEnglishLabel: UILabel!
    @IBOutlet weak var issueDateArabicLabel: UILabel!
    @IBOutlet weak var issuedNumberLabel: UILabel!
    @IBOutlet weak var receipientLabel: UILabel!
    
    @IBOutlet weak var issuedDetailsStackView: UIStackView!
        
    @IBOutlet weak var jobTitleALabel: UILabel!
    @IBOutlet weak var jobTitleBLabel: UILabel!
    @IBOutlet weak var jobTitleCLabel: UILabel!
    @IBOutlet weak var employeeNameALabel: UILabel!
    @IBOutlet weak var employeeNameBLabel: UILabel!
    @IBOutlet weak var employeeNameCLabel: UILabel!
    
    @IBOutlet weak var signatureStampStackView: UIStackView!
    
    @IBOutlet weak var markersLabel: UILabel!
    @IBOutlet weak var reviewersLabel: UILabel!
    
    @IBOutlet weak var markersStackVew: UIStackView!
    @IBOutlet weak var reviewersStackView: UIStackView!
    
    var isOutging = true
    var transactionId = ""
    private var persons : [TransactionsPersons]?
    private var c1Attachments = [FormC1File]()
    private var c2Attachments = [form_c2_filesRecords]()
    private var historyData = [TransactionsContractRecord]()
    private var extraVal = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addNavigationBarTitle(navigationTitle: isOutging ? "Outgoing" : "Incoming")
        navigationController?.setNavigationBarHidden(false, animated: true)
        issuedDetailsStackView.isHidden = isOutging
        signatureStampStackView.isHidden = !isOutging
        reviewersStackView.isHidden = !isOutging
        isOutging ? getC1FormData() : getC2FormData()
        
    }
    
    
    @IBAction func contentTextAction(_ sender: Any) {
        previewContentFile()
    }
    
    
    @IBAction func personalDetailsAction(_ sender: Any) {
        let vc:PersonDetailsVC = AppDelegate.TransactionSB.instanceVC()
        vc.personalData = self.persons
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func historyAction(_ sender: Any) {
        let vc:HistoryVC = AppDelegate.TransactionSB.instanceVC()
        vc.recordsData = historyData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func attachmentsAction(_ sender: Any) {
        let vc:CFormAttachViewController = CFormAttachViewController()
        vc.isOutgoing = isOutging
        vc.c1Attachments = self.c1Attachments
        vc.c2Attachments = self.c2Attachments
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


// MARK: - API Handling
extension CFormViewController{
    private func getC1FormData(){
        self.markersLabel.text! = ""
        self.reviewersLabel.text! = ""
        showLoadingActivity()
        APIController.shard.getC1FormData(transactionId: transactionId) { data in
            DispatchQueue.main.async {
                self.hideLoadingActivity()
                if let status = data.status,status{
                    
                    self.transactionNumberLabel.text = data.transactions_request?.transaction_request_id ?? "- - - -"
                    self.requestNumberLabel.text = data.transactions_request?.tbv_barcodeData ?? "- - - -"
                    self.statusLabel.text = data.transactions_request?.transaction_request_status ?? "- - - -"
                    self.createdByLabel.text = data.transactions_request?.created_name ?? "- - - -"
                    self.createdDateLabel.text = data.transactions_request?.created_date ?? "- - - -"
                    self.moduleLabel.text = data.transactions_request?.module_name ?? "- - - -"
                    
                    self.responseFormTitleLabel.text = data.transactions_request?.transaction_request_description ?? "- - - -"
                    self.subjectLabel.text = data.transactions_request?.transaction_request_description ?? "- - - -"
                    self.attachmentLabel.text = data.form_c1_data?.records?.first?.attachment ?? "- - - -"
                    self.languageLabel.text = data.transactions_request?.language_name ?? "- - - -"
                    self.fromLabel.text = data.transactions_request?.transaction_from_name ?? "- - - -"
                    self.toOrganizationLabel.text = data.transactions_request?.transaction_to_name ?? "- - - -"
                    self.descriptionLabel.text = data.form_c1_data?.records?.first?.content ?? "- - - -"
                    let persons = data.transactions_persons?.records ?? []
                    
                    for person in persons{
                        if person.transaction_persons_type == "signature" {
                            switch person.transactions_persons_val1 ?? "" {
                            case "A":
                                self.jobTitleALabel.text = person.transactions_persons_val2 ?? ""
                                self.employeeNameALabel.text = person.person_name ?? ""
                            case "B":
                                self.jobTitleBLabel.text = person.transactions_persons_val2 ?? ""
                                self.employeeNameBLabel.text = person.person_name ?? ""
                            case "C":
                                self.jobTitleCLabel.text = person.transactions_persons_val2 ?? ""
                                self.employeeNameCLabel.text = person.person_name ?? ""
                            default:
                                break
                            }
                        }else if person.transaction_persons_type == "marks" {
                            self.markersLabel.text! += "\(person.person_name ?? "") ,"
                        }else if person.transaction_persons_type == "reviews" {
                            self.reviewersLabel.text! += "\(person.person_name ?? "") ,"
                        }
                    }
                    
                    let extras = data.transactions_extra?.records ?? []
                    for extra in extras{
                        if extra.extra_custom_key == "url_of_content_text"{
                            self.extraVal = extra.extra_custom_val ?? ""
                            break
                        }
                    }
                    
                    self.persons = data.transactions_persons?.records ?? []
                    self.c1Attachments = data.form_c1_files?.records ?? []
                    self.historyData = data.transactions_records?.records ?? []
                    self.markersStackVew.isHidden = self.markersLabel.text!.isEmpty
                    
                }else{
                    SCLAlertView().showError("error".localized(), subTitle: data.error ?? "")
                }
            }
        }
    }
    
    private func getC2FormData(){
        self.markersLabel.text! = ""
        APIController.shard.getC2FormData(transactionId: transactionId) { data in
            DispatchQueue.main.async {
                self.hideLoadingActivity()
                if let status = data.status,status{
                    
                    self.transactionNumberLabel.text = data.transactions_request?.transaction_request_id ?? "- - - -"
                    self.requestNumberLabel.text = data.transactions_request?.tbv_barcodeData ?? "- - - -"
                    self.statusLabel.text = data.transactions_request?.transaction_request_status ?? "- - - -"
                    self.createdByLabel.text = data.transactions_request?.created_name ?? "- - - -"
                    self.createdDateLabel.text = data.transactions_request?.created_date ?? "- - - -"
                    self.moduleLabel.text = data.transactions_request?.module_name ?? "- - - -"
                    
                    self.responseFormTitleLabel.text = data.transactions_request?.transaction_request_description ?? "- - - -"
                    self.subjectLabel.text = data.transactions_request?.transaction_request_description ?? "- - - -"
                    self.attachmentLabel.text = data.form_c2_data?.records?.first?.attachment ?? "- - - -"
                    self.languageLabel.text = data.transactions_request?.language_name ?? "- - - -"
                    self.fromLabel.text = data.transactions_request?.transaction_from_name ?? "- - - -"
                    self.toOrganizationLabel.text = data.transactions_request?.transaction_to_name ?? "- - - -"
                    self.descriptionLabel.text = data.form_c2_data?.records?.first?.content ?? "- - - -"
                    
                    self.issueDateEnglishLabel.text = data.form_c2_data?.records?.first?.issued_date_m ?? "- - - -"
                    self.issueDateArabicLabel.text = data.form_c2_data?.records?.first?.issued_date_h ?? "- - - -"
                    self.issuedNumberLabel.text = data.form_c2_data?.records?.first?.issued_number ?? "- - - -"
                    
                    let persons = data.transactions_persons?.records ?? []
                    
                    for person in persons{
                        if person.transaction_persons_type == "marks" {
                            self.markersLabel.text! += "\(person.person_name ?? "") ,"
                        }else if person.transaction_persons_type == "signature" {
                            self.receipientLabel.text = person.person_name ?? "- - - -"
                        }
                    }
                    let extras = data.transactions_extra?.records ?? []
                    for extra in extras{
                        if extra.extra_custom_key == "url_of_content_text"{
                            self.extraVal = extra.extra_custom_val ?? ""
                            break
                        }
                    }
                    
                    self.persons = data.transactions_persons?.records ?? []
                    self.c2Attachments = data.form_c2_files?.records ?? []
                    self.historyData = data.transactions_records?.records ?? []
                    self.markersStackVew.isHidden = self.markersLabel.text!.isEmpty
                }else{
                    SCLAlertView().showError("error".localized(), subTitle: data.error ?? "There is an unknow error !!")
                }
            }
        }
    }
    
    private func previewContentFile(){
        showLoadingActivity()
        APIController.shard.showContentPreview(extraVal: extraVal) { data in
            DispatchQueue.main.async {
                self.hideLoadingActivity()
                if let status = data.status , status{
                    let vc = WebViewViewController()
                    vc.data = data
                    self.navigationController?.present(UINavigationController(rootViewController: vc), animated: true)
                }else{
                    SCLAlertView().showError("error".localized(), subTitle: data.error ?? "There is an unknow error !!")
                }
            }
        }
    }
}
