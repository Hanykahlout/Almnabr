//
//  VactionViewController.swift
//  Almnabr
//
//  Created by Hany Alkahlout on 24/07/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import UIKit
import SCLAlertView

class VactionViewController: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
    @IBOutlet weak var requestNumLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var createdByLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var lastStepOpendLabel: UILabel!
    @IBOutlet weak var selectedStepLabel: UILabel!
    @IBOutlet weak var stepsNumLabel: UILabel!
    @IBOutlet weak var stepsProgress: UIProgressView!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var approveButton: UIButton!
    @IBOutlet weak var approveStackView: UIStackView!
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var rejectStackView: UIStackView!
    @IBOutlet weak var verficationCodeTextField: UITextField!
    @IBOutlet weak var nameOfRequestApprovalWritreLabel: UILabel!
    @IBOutlet weak var requestApprovalView: UIView!
    @IBOutlet weak var attachButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var personalDetailsButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    
    private var pageController:VactionPageViewController!
    
    private var ACCOUNT_TEAM = false
    private var CONFIGURATION = false
    private var DIRECT_MANAGER = true
    private var EMPLOYEE = false
    private var HUMAN_RESOURCE_MANAGER = false
    private var HUMAN_RESOURCE_TEAM = false
    private var completed = false
    private var last = false
    
    private var presonalDetails:[TransactionsPersons]?
    private var persons: [TransactionsPersons]?
    private var attachData: [FormHrv1AttachmentsRecords]?
    private var requestWaitingPerson:TransactionsPersons?
    private var notesData: [NoteRecordResponse]?
    
    
    var data:Tcore?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
        // Do any additional setup after loading the view.
    }
    
    private func initlization(){
        setUpPageViewController()
        addObserver()
        setUpSelectionRequestApproval()
        verficationCodeTextField.addTarget(self, action: #selector(verficationCodeTextFieldAction), for: .editingChanged)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addNavigationBarTitle(navigationTitle: "Vaction Form".localized())
        navigationController?.setNavigationBarHidden(false, animated: true)
        getVactionData()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    
    @objc private func verficationCodeTextFieldAction(){
        submitButton.isHidden = verficationCodeTextField.text!.isEmpty
    }
    
    
    private func addObserver(){
        NotificationCenter.default.addObserver(forName: .init("ResetMainViewHeight"), object: nil, queue: .main) { notify in
            guard let height = notify.object as? CGFloat else { return }
            self.mainViewHeight.constant = height
        }
        
        NotificationCenter.default.addObserver(forName: .init("ReloadVactionData"), object: nil, queue: .main) { notify in
            self.getVactionData()
        }
    }
    
    
    private func setUpSelectionRequestApproval(){
        approveStackView.isUserInteractionEnabled = true
        approveStackView.addTapGesture {
            self.approveButtonAction()
        }
        
        self.approveButton.addTapGesture {
            self.approveButtonAction()
        }
        
        
        rejectStackView.isUserInteractionEnabled = true
        rejectStackView.addTapGesture {
            self.rejectButtonAction()
        }
        self.rejectButton.addTapGesture {
            self.rejectButtonAction()
        }
        
        
    }
    
    private func approveButtonAction(){
        self.approveButton.isSelected = !self.approveButton.isSelected
        self.rejectButton.isSelected = !self.approveButton.isSelected
    }
    
    private func rejectButtonAction(){
        self.rejectButton.isSelected = !self.rejectButton.isSelected
        self.approveButton.isSelected = !self.rejectButton.isSelected
    }
    
    
    private func setUpPageViewController(){
        pageController =  AppDelegate.TransactionSB.instantiateViewController(withIdentifier: "VactionPageViewController") as? VactionPageViewController
        
        addChild(pageController)
        pageController.didMove(toParent: self)
        
        pageController.view.translatesAutoresizingMaskIntoConstraints = false
        
        mainView.addSubview(pageController.view)
        
        mainView.leadingAnchor.constraint(equalTo: pageController.view.leadingAnchor, constant: 0).isActive = true
        mainView.trailingAnchor.constraint(equalTo: pageController.view.trailingAnchor, constant: 0).isActive = true
        mainView.topAnchor.constraint(equalTo: pageController.view.topAnchor, constant: 0).isActive = true
        mainView.bottomAnchor.constraint(equalTo: pageController.view.bottomAnchor, constant: 0).isActive = true
    }
    
    private func setSelectedStep(){
        
        var isRequestApproval = false
        
        if let persons = persons{
            for person in persons{
                if person.user_id == Auth_User.user_id {
                    if person.transactions_persons_last_step == lastStepOpendLabel.text!{
                        isRequestApproval = true
                    }
                }
                if person.transactions_persons_view == "0"{
                    requestWaitingPerson = person
                }
            }
        }
        
        requestApprovalView.isHidden = !isRequestApproval
        if let requestWaitingPerson = requestWaitingPerson{
            switch requestWaitingPerson.transactions_persons_last_step{
            case "CONFIGURATION":
                stepsNumLabel.text = "step 1 of 7"
                stepsProgress.progress = 1.0/7.0
                selectedStepLabel.text = "Configurations"
            case "EMPLOYEE":
                stepsNumLabel.text = "step 2 of 7"
                stepsProgress.progress = 2.0/7.0
                selectedStepLabel.text = "Employee"
            case "DIRECT_MANAGER":
                stepsNumLabel.text = "step 3 of 7"
                stepsProgress.progress = 3.0/7.0
                selectedStepLabel.text = "Direct Manager"
            case "HUMAN_RESOURCE_TEAM":
                stepsNumLabel.text = "step 4 of 7"
                stepsProgress.progress = 4.0/7.0
                selectedStepLabel.text = "HR Team"
            case "ACCOUNT_TEAM":
                stepsNumLabel.text = "step 5 of 7"
                stepsProgress.progress = 5.0/7.0
                selectedStepLabel.text = "Account team"
            case "HUMAN_RESOURCE_MANAGER":
                stepsNumLabel.text = "step 6 of 7"
                stepsProgress.progress = 6.0/7.0
                selectedStepLabel.text = "HR Manager"
            default:
                stepsNumLabel.text = "step 7 of 7"
                stepsProgress.progress = 7.0/7.0
                selectedStepLabel.text = "Last Vacation Step"
            }
        }
    }
    
    
    @IBAction func beforeAction(_ sender: Any) {
        
        switch selectedStepLabel.text{
        case "Configurations":
            break
        case "Employee":
            stepsNumLabel.text = "step 1 of 7"
            stepsProgress.progress = 1.0/7.0
            selectedStepLabel.text = "Configurations"
        case "Direct Manager":
            
            stepsNumLabel.text = "step 2 of 7"
            stepsProgress.progress = 2.0/7.0
            selectedStepLabel.text = "Employee"
        case "HR Team":
            
            stepsNumLabel.text = "step 3 of 7"
            stepsProgress.progress = 3.0/7.0
            selectedStepLabel.text = "Direct Manager"
        case "Account team":
            
            stepsNumLabel.text = "step 4 of 7"
            stepsProgress.progress = 4.0/7.0
            selectedStepLabel.text = "HR Team"
        case "HR Manager":
            
            stepsNumLabel.text = "step 5 of 7"
            stepsProgress.progress = 5.0/7.0
            selectedStepLabel.text = "Account team"
            
        default:
            stepsNumLabel.text = "step 6 of 7"
            stepsProgress.progress = 6.0/7.0
            selectedStepLabel.text = "HR Manager"
        }
        
        let index = pageController.currentIndex - 1
        guard index >= 0 else { return }
        pageController.currentIndex = index
        pageController.changeVC(direction: .reverse)
        
        
    }
    
    
    @IBAction func forwardAction(_ sender: Any) {
        switch selectedStepLabel.text{
        case "Configurations":
            stepsNumLabel.text = "step 2 of 7"
            stepsProgress.progress = 2.0/7.0
            selectedStepLabel.text = "Employee"
            
        case "Employee":
            stepsNumLabel.text = "step 3 of 7"
            stepsProgress.progress = 3.0/7.0
            selectedStepLabel.text = "Direct Manager"
            
        case "Direct Manager":
            stepsNumLabel.text = "step 4 of 7"
            stepsProgress.progress = 4.0/7.0
            selectedStepLabel.text = "HR Team"
            
        case "HR Team":
            stepsNumLabel.text = "step 5 of 7"
            stepsProgress.progress = 5.0/7.0
            selectedStepLabel.text = "Account team"
            
        case "Account team":
            stepsNumLabel.text = "step 6 of 7"
            stepsProgress.progress = 6.0/7.0
            selectedStepLabel.text = "HR Manager"
            
        case "HR Manager":
            
            stepsNumLabel.text = "step 7 of 7"
            stepsProgress.progress = 7.0/7.0
            selectedStepLabel.text = "Last Vacation Step"
            
        default:
            break
        }
        
        let index = pageController.currentIndex + 1
        guard index < pageController.containerVCs.count  else { return }
        pageController.currentIndex = index
        pageController.changeVC(direction: .forward)
        
        
        
    }
    
    
    @IBAction func presonalDetailsAction(_ sender: Any) {
        let vc:PersonDetailsVC = AppDelegate.TransactionSB.instanceVC()
        vc.personalData = self.presonalDetails
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func historyAction(_ sender: Any) {
        let vc:HistoryVC = AppDelegate.TransactionSB.instanceVC()
        vc.notesData = notesData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func attachmentsAction(_ sender: Any) {
        
        let vc:FormsAttachmentsVC = AppDelegate.TransactionSB.instanceVC()
        vc.attachData = self.attachData
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func sendCodeAction(_ sender: Any) {
    }
    
    
    @IBAction func submitAction(_ sender: Any) {
        submitApprovalRequest()
    }
    
    
    @IBAction func previewPdfAction(_ sender: Any) {
        previewPDF()
    }
    
    
    @IBAction func editLastStepOpenedAction(_ sender: Any) {
        let vc = EditLastStepViewController()
        vc.isVaction = true
        vc.transactionRequestId = data?.transaction_request_id ?? ""
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overCurrentContext
        navigationController?.present(nav, animated: true)
    }
    
    
    @IBAction func infoLastStepAction(_ sender: Any) {
        if let requestWaitingPerson = requestWaitingPerson {
            SCLAlertView().showInfo("Waiting for: \(requestWaitingPerson.person_name ?? "")", subTitle: "")
        }
    }
    
}

// MARK: - API Handlign
extension VactionViewController{
    
    
    private func getVactionData(){
        showLoadingActivity()
        APIController.shard.getVactionData(vactionId: data?.transaction_request_id ?? "") { data in
            DispatchQueue.main.async {
                self.hideLoadingActivity()
                if let status = data.status,status{
                    let transctionDataFirstRecord = data.transactions_date?.records?.first
                    self.requestNumLabel.text = transctionDataFirstRecord?.transaction_request_id ?? "----"
                    self.statusLabel.text =  transctionDataFirstRecord?.transaction_request_status ?? "----"
                    self.createdByLabel.text = data.transactions_request?.created_name ?? "----"
                    self.createdDateLabel.text = data.transactions_request?.created_date ?? "----"
                    self.lastStepOpendLabel.text = data.last_request_step ?? ""
                    
                    self.ACCOUNT_TEAM = data.steps?.aCCOUNT_TEAM ?? false
                    self.CONFIGURATION = data.steps?.cONFIGURATION ?? false
                    self.DIRECT_MANAGER = data.steps?.dIRECT_MANAGER ?? false
                    self.EMPLOYEE = data.steps?.eMPLOYEE ?? false
                    self.HUMAN_RESOURCE_MANAGER = data.steps?.hUMAN_RESOURCE_MANAGER ?? false
                    self.HUMAN_RESOURCE_TEAM = data.steps?.hUMAN_RESOURCE_TEAM ?? false
                    self.completed = data.steps?.completed ?? false
                    self.last = data.steps?.last ?? false
                    self.presonalDetails = data.transactions_persons?.records
                    self.pageController.setVactionDetailsData(data: data.form_hrv1_vacation_data?.records)
                    
                    
                    self.nameOfRequestApprovalWritreLabel.text = data.last_request_step ?? ""
                    
                    self.persons = data.transactions_persons?.records
                    self.personalDetailsButton.isHidden = self.persons == nil
                    
                    self.attachData = data.form_hrv1_attachments?.records
                    self.attachButton.isHidden = self.attachData == nil
                    self.notesData = data.transactions_notes?.records
                    self.historyButton.isHidden = self.notesData == nil
                    
                    self.setSelectedStep()
                    
                }else{
                    let alertVC = UIAlertController(title: "error".localized(), message: data.error ?? "", preferredStyle: .alert)
                    alertVC.addAction(.init(title: "Cancel".localized(), style: .cancel,handler: { action in
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }))
                    self.present(alertVC, animated: true)
                }
            }
        }
    }
    
    private func previewPDF(){
        showLoadingActivity()
        APIController.shard.getImage(url: "form/FORM_HRV1/pr/\(data?.transaction_request_id ?? "")") { data in
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
    }
    
    private func submitApprovalRequest(){
        let transaction_request_id = data?.transaction_request_id ?? ""
        let approving_status = approveButton.isSelected ? "Approve" : "Reject"
        let note = noteTextView.text!
        let transactions_persons_action_code = verficationCodeTextField.text!
        showLoadingActivity()
        APIController.shard.submitApproval(formType:"FORM_HRV1",transaction_request_id: transaction_request_id, approving_status: approving_status, note: note, transactions_persons_action_code: transactions_persons_action_code) { data in
            DispatchQueue.main.async {
                self.hideLoadingActivity()
                if let status = data.status,status{
                    SCLAlertView().showSuccess("Success".localized(), subTitle: data.msg ?? "")
                    self.requestApprovalView.isHidden = true
                }else{
                    SCLAlertView().showError("error".localized(), subTitle: data.error ?? "")
                }
            }
        }
    }
    
    
}

