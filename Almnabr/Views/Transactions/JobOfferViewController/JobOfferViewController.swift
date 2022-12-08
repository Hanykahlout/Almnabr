//
//  JobOfferViewController.swift
//  Almnabr
//
//  Created by Hany Alkahlout on 08/12/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import UIKit
import SCLAlertView
class JobOfferViewController: UIViewController {
    
    
    @IBOutlet weak var approvalView: UIView!
    @IBOutlet weak var finalResultView: UIView!
    @IBOutlet weak var noPermmtionView: UIView!
    @IBOutlet weak var noPermmtionImageView: UIImageView!
    
    @IBOutlet weak var requestNumberLabel: UILabel!
    @IBOutlet weak var barcodeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var createdByLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var previewLabel: UILabel!
    @IBOutlet weak var lastStepOpenedLabel: UILabel!
    @IBOutlet weak var selectedStepLabel: UILabel!
    @IBOutlet weak var stepsNumberLabel: UILabel!
    @IBOutlet weak var approvalViewTitle: UILabel!
    @IBOutlet weak var emptyNoteViewLabel: UILabel!
    @IBOutlet weak var finalViewLabel: UILabel!
    
    @IBOutlet weak var approveStackView: UIStackView!
    @IBOutlet weak var rejectStackView: UIStackView!
    
    @IBOutlet weak var verificationCodeTextField: UITextField!
    
    @IBOutlet weak var noteTextView: UITextView!
    
    @IBOutlet weak var pdfPreviewButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var approveButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var submitFormButton: UIButton!
    
    @IBOutlet weak var stepsProgress: UIProgressView!
    var transactionId = ""
    
    private var presonalDetails:[TransactionsPersons] = []
    private var recordsData:[Transactions_notes_record] = []
    private var approvalStep:String? = nil
    private var previewFileData:GetImageResponse?
    private var progress:Float = 0 {
        didSet{
            stepsProgress.progress = self.progress/5
            changeCurrentStep()
        }
    }
    private var isWaitingThisUser = false
    private let steps:[Int:String] = [1:"CONFIGURATION",2:"ACCOUNT_TEAM",3:"HUMAN_RESOURCE_MANAGER",4:"FIRST_PARTY",5:"completed"]
    private var waitingUsers = ""
    private var overtimeData = [Form_ovr1_records]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDeductionFormData()
        addNavigationBarTitle(navigationTitle: "Job Offer Form")
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func initialization(){
        addNoPermissionImage()
        editButton.isHidden = !Auth_User.isAdmin
        NotificationCenter.default.addObserver(forName: .init("ReloadJobOfferData"), object: nil, queue: .main) { notify in
            self.getDeductionFormData()
        }
        noteTextView.delegate = self
        setUpRaduioButtonStackViews()
        self.verificationCodeTextField.addTarget(self, action: #selector(verificationCodeAction), for: .editingChanged)
    }
    
    private func addNoPermissionImage(){
        if let image = UIImage.gif(name: "no-permission2"){
            noPermmtionImageView.image = image
        }
    }
    
    
    private func setUpRaduioButtonStackViews(){
        approveStackView.addTapGesture {
            self.approveButton.isSelected = !self.approveButton.isSelected
            self.rejectButton.isSelected = !self.approveButton.isSelected
        }
        
        rejectStackView.addTapGesture {
            
            self.rejectButton.isSelected = !self.rejectButton.isSelected
            self.approveButton.isSelected = !self.rejectButton.isSelected
        }
    }
    
    private func getPrviewFile(base64:String?){
        var url = ""
        if let base64 = base64 {
            url = base64
        }else{
            url = "form/FORM_JF/pr/\(transactionId)"
        }
        APIController.shard.getImage(url: url) { [weak self] data in
            
            if let status = data.status ,status , let self = self{
                self.pdfPreviewButton.isHidden = false
                self.previewFileData = data
            }
        }
    }
    
    private func changeCurrentStep(){
        switch progress{
        case 1:
            selectedStepLabel.text = "Configuration"
        case 2:
            selectedStepLabel.text = "Account Team"
        case 3:
            selectedStepLabel.text = "HR Manager"
        case 4:
            selectedStepLabel.text = "First Party"
        case 5:
            selectedStepLabel.text = "last step"
        default:
            break
        }
        
        finalResultView.isHidden = (approvalStep != "last" && approvalStep != "completed") || progress != 5
        
        stepsNumberLabel.text = "step \(Int(progress)) of 5"
        if isWaitingThisUser{
            approvalView.isHidden = steps[Int(progress)] != approvalStep
        }else{
            approvalView.isHidden = true
        }
        
        
        noPermmtionView.isHidden = !approvalView.isHidden || ((approvalStep == "last" || approvalStep == "completed") && progress == 5)
        
    }
    
    private func setUpApprovalViewExistent(data:Transactions_persons?){
        waitingUsers.removeAll()
        if let data = data ,let records = data.records , let approvalStep = approvalStep{
            for record in records{
                if approvalStep == record.transactions_persons_last_step{
                    waitingUsers.append("\(waitingUsers.isEmpty ? "" : " - ")\(record.person_name ?? "")")
                }
                
                if record.user_id == Auth_User.user_id{
                    self.isWaitingThisUser = record.transactions_persons_last_step == approvalStep
                    approvalView.isHidden = record.transactions_persons_last_step != approvalStep
                }
            }
            noPermmtionView.isHidden = !approvalView.isHidden || ((approvalStep == "last" || approvalStep == "completed") && progress == 5)
            
        }
    }
    
    
    @objc private func verificationCodeAction(){
        submitFormButton.isHidden = verificationCodeTextField.text!.isEmpty
    }
    
    
    @IBAction func previewAction(_ sender: Any) {
        if let data = previewFileData {
            let vc = WebViewViewController()
            vc.data = data
            let nav = UINavigationController(rootViewController: vc)
            self.navigationController?.present(nav, animated: true)
        }
    }
    
    @IBAction func infoAction(_ sender: Any) {
        let alertVC = UIAlertController(title: "Waited Users", message: waitingUsers, preferredStyle: .alert)
        alertVC.addAction(.init(title: "Cancel", style: .cancel))
        present(alertVC, animated: true)
        
    }
    
    
    @IBAction func editAction(_ sender: Any) {
        let vc = EditLastStepViewController()
        vc.formStr = "FORM_JF"
        vc.transactionRequestId = transactionId
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overCurrentContext
        navigationController?.present(nav, animated: true)
    }
    
    @IBAction func reverseAction(_ sender: Any) {
        if progress > 1{
            progress -= 1
        }
    }
    
    @IBAction func forwordAction(_ sender: Any) {
        if progress < 5{
            progress += 1
        }
    }
    
    
    
    @IBAction func sendCodeAction(_ sender: Any) {
        let vc = SendCodeWaysVC()
        vc.id = transactionId
        vc.approvalStep = approvalStep
        let nav = UINavigationController(rootViewController: vc)
        nav.setNavigationBarHidden(true, animated: false)
        nav.modalPresentationStyle = .overCurrentContext
        navigationController?.present(nav, animated: true)
    }
    
    @IBAction func submitAction(_ sender: Any) {
        sendApproval()
    }
    
    @IBAction func personalDetailsAction(_ sender: Any) {
        let vc:PersonDetailsVC = AppDelegate.TransactionSB.instanceVC()
        vc.personalData = self.presonalDetails
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func historyAction(_ sender: Any) {
        let vc:HistoryVC = AppDelegate.TransactionSB.instanceVC()
        vc.jobOfferData = recordsData
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - API Controller
extension JobOfferViewController{
    private func getDeductionFormData(){
        showLoadingActivity()
        APIController.shard.getJobOfferFormData(transactionId: transactionId) { data in
            DispatchQueue.main.async {
                self.hideLoadingActivity()
                if let status = data.status , status{
                    let lastStep = data.transactions_request?.transaction_request_last_step ?? ""
                    self.previewLabel.text = (lastStep == "completed" || lastStep == "last") ? "View" : "Preview"
                    self.requestNumberLabel.text = data.transactions_request?.transaction_request_id ?? "----"
                    self.barcodeLabel.text = data.transactions_request?.tbv_barcodeData ?? "----"
                    self.statusLabel.text = data.transactions_request?.transaction_request_status ?? "----"
                    self.createdByLabel.text = data.transactions_request?.created_name ?? ""
                    self.createdDateLabel.text = data.transactions_request?.created_date ?? ""
                    self.presonalDetails = data.transactions_persons?.records ?? []
                    self.recordsData = data.transactions_notes?.records ?? []
                    
                    self.approvalStep = data.transactions_request?.transaction_request_last_step ?? ""
                    self.getPrviewFile(base64: self.approvalStep == "completed" ? data.transactions_request?.view_link : nil)
                    switch data.transactions_request?.transaction_request_last_step{
                    case "CONFIGURATION":
                        self.progress = 1
                        self.lastStepOpenedLabel.text = "Configuration"
                    case "ACCOUNT_TEAM":
                        self.progress = 2
                        self.lastStepOpenedLabel.text = "Account Team"
                    case "HUMAN_RESOURCE_MANAGER":
                        self.progress = 3
                        self.lastStepOpenedLabel.text = "Human Resource Manager"
                    case "FIRST_PARTY":
                        self.progress = 4
                        self.lastStepOpenedLabel.text = "First Party"
                    case "last":
                        self.progress = 5
                        self.lastStepOpenedLabel.text = "Processing"
                        self.finalViewLabel.text = "Thank you, we will review your request. wait the result soon."
                    case "completed":
                        self.progress = 5
                        self.lastStepOpenedLabel.text = "Completed"
                        self.finalViewLabel.text = "lang_completed_msg"
                    default:
                        break
                    }
                    
                    self.setUpApprovalViewExistent(data: data.transactions_persons)
                }
            }
            
        }
    }
    
    private func sendApproval(){
        showLoadingActivity()
        APIController.shard.submitApproval(formType: "FORM_JF", transaction_request_id: transactionId, approving_status: approveButton.isSelected ? "Approve" : "Reject", note: noteTextView.text!, transactions_persons_action_code: verificationCodeTextField.text!) { data in
            DispatchQueue.main.async {
                self.hideLoadingActivity()
                if let status = data.status ,status{
                    self.getDeductionFormData()
                }else{
                    SCLAlertView().showError("error".localized(), subTitle: data.error ?? "There is an unknown error")
                }
            }
        }
    }
}



extension JobOfferViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        emptyNoteViewLabel.isHidden = true
    }
}

