//
//  TransactionFormDetailsVC.swift
//  Almnabr
//
//  Created by MacBook on 04/12/2021.
//  Copyright © 2021 Samar Akkila. All rights reserved.
//

import UIKit
import DPLocalization
import FontAwesome_swift

import AMPopTip

var StatusObject:StepStatusObj?
var obj_transaction:Tcore?
var obj_FormWir:WorkAreaInfoObj?
var arr_Technical_Assistants_Evaluation:[Technical_Assistants_EvaluationObj] = []

class TransactionFormDetailsVC: UIViewController {
    
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblRequestNumber: UILabel!
    @IBOutlet weak var lblProjectTitle: UILabel!
    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var lblFormCode: UILabel!
    @IBOutlet weak var lblDivision: UILabel!
    @IBOutlet weak var lblChapter: UILabel!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblFormSpecifications: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblFormVersions: UILabel!
    @IBOutlet weak var lblPreview: UILabel!
    @IBOutlet weak var lblLang_drawing_file: UILabel!
    
    
    @IBOutlet weak var lblValRequestNumber: UILabel!
    @IBOutlet weak var lblValProjectTitle: UILabel!
    @IBOutlet weak var lblValServiceName: UILabel!
    @IBOutlet weak var lblValFormCode: UILabel!
    @IBOutlet weak var lblValDivision: UILabel!
    @IBOutlet weak var lblValChapter: UILabel!
    @IBOutlet weak var lblValItemName: UILabel!
    @IBOutlet weak var lblValFormSpecifications: UILabel!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var btnFormVersions: UIButton!
    @IBOutlet weak var btnPreview: UIButton!
    @IBOutlet weak var lblValLang_drawing_file: UILabel!
    
    
    @IBOutlet weak var lblSelectedStep: UILabel!
    @IBOutlet weak var lblValSelectedStep: UILabel!
    @IBOutlet weak var lblLastStepOpened: UILabel!
    @IBOutlet weak var lblLastValStepOpened: UILabel!
    @IBOutlet weak var btnLastValStepOpened: UIButton!
    @IBOutlet weak var btnWaitingFor: UIButton!
    @IBOutlet weak var lblStep: UILabel!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var slider: UIProgressView!
    
    @IBOutlet weak var header: HeaderView!
    
    @IBOutlet weak var btnNotes: UIButton!
    @IBOutlet weak var btnPersonDetails: UIButton!
    @IBOutlet weak var btnAttachments: UIButton!
    @IBOutlet weak var btnHistory: UIButton!
    @IBOutlet weak var btnAllProject: UIButton!
    @IBOutlet weak var btnSupervisionOperations: UIButton!
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPrevious: UIButton!
    
    var StrTitle:String = ""

    var projectId:String = ""
    var CustomerName:String = ""
    
    var SelectedIndex:Int = 1
    
    var Object:Tcore?
    var transactions_request:Tcore?
    var WorkAreaObj:WorkAreaInfoObj?
    var FormWirObj:form_wir_dataObj?
    var arr_transactionsNotes:[transactions_notesObj] = []
    var arr_transactions_persons:[transactions_personsObj] = []
    var arr_transactions_records:[transactions_recordsObj] = []
    var arr_Configurations_Attachments:[Configurations_AttachmentsObj] = []
    var arr_project_supervision_form_unit_level:[project_supervision_form_unit_levelObj] = []
    
    
    
    let arr_step:[String] = [ "Configurations",
                              "Contractor Team Approval",
                              "Contractor Manager Approval",
                              "Recipient Verification",
                              "Techinical Assistant",
                              "Special Approval",
                              "Evaluation Result",
                              "Authorized Positions Approval",
                              "Manager Approval",
                              "Owners Representative",
                              "Final Result"]
    
    let arr_Valstep:[String] = [ "Configurations",
                              "Contractor_Team_Approval",
                              "Contractor_Manager_Approval",
                              "Recipient_Verification",
                              "Techinical_Assistant",
                              "Special_Approval",
                              "Evaluation_Result",
                              "Authorized_Positions Approval",
                              "Manager_Approval",
                              "Owners_Representative",
                              "last"]
    
    var arr_waitingFor:[String] = []
    var parentPageVC: TransactionFormPageaVC!

    private let page_count = 11
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mainView.isHidden = true
        get_Request()
        configNavigation()
        
        update_Config()
    }

    

   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    // MARK: - Config Navigation
    func configNavigation() {
        _ = self.navigationController?.preferredStatusBarStyle
        self.view.backgroundColor = HelperClassSwift.acolor.getUIColor() //F0F4F8
        //navigationController?.navigationBar.barTintColor = .buttonBackgroundColor()
        navigationController?.navigationBar.barTintColor = HelperClassSwift.acolor.getUIColor()
       addNavigationBarTitle(navigationTitle: "Form Details".localized())
        UINavigationBar.appearance().backgroundColor = HelperClassSwift.acolor.getUIColor()
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FormDetailsPager",
           let destinationVC = segue.destination as? TransactionFormPageaVC {
            //  destinationVC.numberToDisplay = counter
            // destinationVC.displayPageForIndex(index: self.SelectedIndex)
            if let controller = self.parentPageVC {
                //    controller.displayPageForIndex(index: self.SelectedIndex)
            }
        }
    }

    
    
    //MARK: - Config GUI
    //------------------------------------------------------
    func configGUI() {
        
        
        
        self.slider.progressTintColor = HelperClassSwift.acolor.getUIColor()
        self.slider.progress = 0.1
       
        self.title = "Form Details".localized()
        
        self.lblStep.font = .kufiRegularFont(ofSize: 15)
        self.lblStep.textColor =  HelperClassSwift.bcolor.getUIColor()
        self.lblStep.text =  "step 1 of \(page_count)"
        
        self.lblRequestNumber.text =  "Request Number".localized() + " :"
        self.lblRequestNumber.font = .kufiRegularFont(ofSize: 15)
        self.lblRequestNumber.textColor =  HelperClassSwift.bcolor.getUIColor()
        
        self.lblProjectTitle.text =  "Project Title".localized() + " :"
        self.lblProjectTitle.font = .kufiRegularFont(ofSize: 15)
        self.lblProjectTitle.textColor =  HelperClassSwift.bcolor.getUIColor()
        
        self.lblServiceName.text =  "Service Name".localized() + " :"
        self.lblServiceName.font = .kufiRegularFont(ofSize: 15)
        self.lblServiceName.textColor =  HelperClassSwift.bcolor.getUIColor()
        
        self.lblFormCode.text =  "Form Code".localized() + " :"
        self.lblFormCode.font = .kufiRegularFont(ofSize: 15)
        self.lblFormCode.textColor =  HelperClassSwift.bcolor.getUIColor()
        
        self.lblDivision.text =  "Division".localized() + " :"
        self.lblDivision.font = .kufiRegularFont(ofSize: 15)
        self.lblDivision.textColor =  HelperClassSwift.bcolor.getUIColor()
        
        self.lblChapter.text =  "Chapter".localized() + " :"
        self.lblChapter.font = .kufiRegularFont(ofSize: 15)
        self.lblChapter.textColor =  HelperClassSwift.bcolor.getUIColor()
        
        self.lblFormSpecifications.text =  "Form Specifications".localized() + " :"
        self.lblFormSpecifications.font = .kufiRegularFont(ofSize: 15)
        self.lblFormSpecifications.textColor =  HelperClassSwift.bcolor.getUIColor()
        
        self.lblItemName.text =  "Item Name".localized() + " :"
        self.lblItemName.font = .kufiRegularFont(ofSize: 15)
        self.lblItemName.textColor =  HelperClassSwift.bcolor.getUIColor()
        
        
        self.lblFormVersions.text =  "Form Versions".localized() + " :"
        self.lblFormVersions.font = .kufiBoldFont(ofSize: 14)
        self.lblFormVersions.textColor =  HelperClassSwift.bcolor.getUIColor()
        
        
        self.lblLocation.text =  "txt_location".localized() + " :"
        self.lblLocation.font = .kufiRegularFont(ofSize: 15)
        self.lblLocation.textColor =  HelperClassSwift.bcolor.getUIColor()
        
        self.lblPreview.text =  "Preview".localized() + " :"
        self.lblPreview.font = .kufiRegularFont(ofSize: 15)
        self.lblPreview.textColor =  HelperClassSwift.bcolor.getUIColor()
        
        self.lblLang_drawing_file.text =  "Lang_drawing_file".localized() + " :"
        self.lblLang_drawing_file.font = .kufiRegularFont(ofSize: 15)
        self.lblLang_drawing_file.textColor =  HelperClassSwift.bcolor.getUIColor()
        
        
        self.lblValRequestNumber.text =  Object?.transaction_request_id
        self.lblValRequestNumber.font = .kufiBoldFont(ofSize: 14)
        
        self.lblValProjectTitle.text =  WorkAreaObj?.projects_profile_name
        self.lblValProjectTitle.font = .kufiBoldFont(ofSize: 14)
        
        self.lblValServiceName.text =  WorkAreaObj?.projects_services_name
        self.lblValServiceName.font = .kufiBoldFont(ofSize: 14)
        
        self.lblValFormCode.text = FormWirObj?.platform_code_system
        self.lblValFormCode.font = .kufiBoldFont(ofSize: 14)
        
        self.lblValDivision.text =  FormWirObj?.group1name
        self.lblValDivision.font = .kufiBoldFont(ofSize: 14)
        
        self.lblValChapter.text =  FormWirObj?.group2name
        self.lblValChapter.font = .kufiBoldFont(ofSize: 14)
        
        self.lblValItemName.text =  FormWirObj?.platformname
        self.lblValItemName.font = .kufiBoldFont(ofSize: 14)
        
        self.lblValFormSpecifications.text =  FormWirObj?.specification ?? "---"
        self.lblValFormSpecifications.font = .kufiBoldFont(ofSize: 14)
        
       self.lblValLang_drawing_file.text =  "----"
        self.lblValLang_drawing_file.font = .kufiBoldFont(ofSize: 14)
        
        
        self.lblSelectedStep.text =  "Selected Step".localized() + " :"
        self.lblSelectedStep.font = .kufiRegularFont(ofSize: 15)
        self.lblSelectedStep.textColor =  HelperClassSwift.bcolor.getUIColor()
        
        self.lblValSelectedStep.text =  "Recipient Verification"
        self.lblValSelectedStep.font = .kufiBoldFont(ofSize: 15)
        self.lblValSelectedStep.textColor =  .gray
        
        self.lblLastStepOpened.text =  "Last Step Opened".localized() + " :"
        self.lblLastStepOpened.font = .kufiRegularFont(ofSize: 15)
        self.lblLastStepOpened.textColor =  HelperClassSwift.bcolor.getUIColor()
        
        let last_step = transactions_request?.transaction_request_last_step
        
        
        if last_step == "last" {
            self.lblLastValStepOpened.text = "Processing"
        }else{
            self.lblLastValStepOpened.text = last_step
        }
        self.lblLastValStepOpened.font = .kufiBoldFont(ofSize: 15)
        self.lblLastValStepOpened.textColor =  "#61b045".getUIColor()
        
        let i1 = arr_Valstep.firstIndex(where: {$0 == last_step})
        print(i1 ?? 10)
        let index = i1 ?? 10
        page_scroll(SelectedIndex: index + 1 )
        
        self.btnLastValStepOpened.setTitleColor(.red, for: .normal)
        self.btnLastValStepOpened.setTitle("(Rejected)".localized(), for: .normal)
        
        self.btnNotes.setTitleColor(HelperClassSwift.acolor.getUIColor(), for: .normal)
        self.btnPersonDetails.setTitleColor(HelperClassSwift.acolor.getUIColor(), for: .normal)
        self.btnAttachments.setTitleColor(HelperClassSwift.acolor.getUIColor(), for: .normal)
        self.btnHistory.setTitleColor(HelperClassSwift.acolor.getUIColor(), for: .normal)
        
        self.btnNotes.setTitle("Notes".localized(), for: .normal)
        self.btnPersonDetails.setTitle("Person Details".localized(), for: .normal)
        self.btnAttachments.setTitle("Attachments".localized(), for: .normal)
        self.btnHistory.setTitle("History".localized(), for: .normal)
        self.btnSupervisionOperations.setTitle("Supervision Operations".localized(), for: .normal)
        self.btnAllProject.setTitle("All Project".localized(), for: .normal)
        
        self.btnSupervisionOperations.backgroundColor =  HelperClassSwift.acolor.getUIColor()
        self.btnAllProject.backgroundColor =  HelperClassSwift.acolor.getUIColor()
        
        self.btnSupervisionOperations.setTitleColor(.white, for: .normal)
        self.btnAllProject.setTitleColor(.white, for: .normal)
        
        
        self.btnNext.backgroundColor =  HelperClassSwift.acolor.getUIColor()
        self.btnPrevious.backgroundColor =  HelperClassSwift.acolor.getUIColor()
       
        
        self.lblValSelectedStep.text = "\(arr_step[SelectedIndex-1])"
        
        

//
//        let status = StatusObject?.to_array[SelectedIndex-1]
//        let title = (status ?? false) ? "Accepted" : "Rejected"
//        self.btnLastValStepOpened.setTitle(title, for: .normal)
    }
    
    func page_scroll(SelectedIndex:Int){
        
        self.SelectedIndex = SelectedIndex
        change_page(SelectedIndex: SelectedIndex)
        self.slider.progress = Float(SelectedIndex)/Float(page_count)
        self.lblStep.text =  "step \(SelectedIndex) of \(page_count)"
        self.lblValSelectedStep.text = "\(arr_step[SelectedIndex-1])"
    }
    
    
    func get_Request(){
        
        self.showLoadingActivity()
        APIManager.sendRequestGetAuth(urlString: "/form/FORM_WIR/vr/\(Object?.transaction_request_id ?? "0")" ) { (response) in
             
             
             let status = response["status"] as? Bool
             if status == true{
                 if  let step_status = response["step_status"] as? [String:Any]{

                     //let view = step_status["view"] as! [String:Any]
                     let edit = step_status["edit"] as! [String:Any]
                     let obj = StepStatusObj(edit)
                     StatusObject = obj
                     self.update_langVC()
                 }
                 
                 if  let view_request = response["view_request"] as? [String:Any]{

                     if let transactions_request = view_request["transactions_request"] as? [String:Any]{
                         let transactions_status = transactions_request["status"] as? Bool
                         if transactions_status == true{
                             let records = transactions_request["records"] as! [String:Any]
                             let recordsObj = Tcore(records)
                             self.transactions_request = recordsObj
                             obj_transaction = recordsObj
                         }
                     }
                    
                     if let work_area_info = view_request["work_area_info"] as? [String:Any]{
                         let transactions_status = work_area_info["status"] as? Bool
                         if transactions_status == true{
                             let records = work_area_info["records"] as! [String:Any]
                             let recordsObj = WorkAreaInfoObj(records)
                             self.WorkAreaObj = recordsObj
                             obj_FormWir = recordsObj
                         }
                     }

                     if let form_wir_data = view_request["form_wir_data"] as? [String:Any]{
                         let form_wir_data_status = form_wir_data["status"] as? Bool
                         if form_wir_data_status == true{
                             let records = form_wir_data["records"] as! NSArray
                             
                             let recordsObj = form_wir_dataObj(records.firstObject as! [String : Any])
                             self.FormWirObj = recordsObj
                         }
                     }
                     
                     if let transactions_notes = view_request["transactions_notes"] as? [String:Any]{
                         let transactions_notes_status = transactions_notes["status"] as? Bool
                         if transactions_notes_status == true{
                            
                             if  let records = transactions_notes["records"] as? NSArray{
                                 for i in records {
                                     let dict = i as? [String:Any]
                                     let obj = transactions_notesObj.init(dict!)
                                     self.arr_transactionsNotes.append(obj)
                                   
                                 }
                             }

                         }
                     }
                     
                     if let transactions_persons = view_request["transactions_persons"] as? [String:Any]{
                         let transactions_persons_status = transactions_persons["status"] as? Bool
                         if transactions_persons_status == true{
                            
                             if  let records = transactions_persons["records"] as? NSArray{
                                 for i in records {
                                     let dict = i as? [String:Any]
                                     let obj = transactions_personsObj.init(dict!)
                                     self.arr_transactions_persons.append(obj)
                                     if obj.transactions_persons_action_status == "0" {
                                         let name = obj.first_name + " " + obj.last_name
                                         self.arr_waitingFor.append(name)
                                     }
                                 }
                             }

                         }
                     }

                     if let transactions_records = view_request["transactions_records"] as? [String:Any]{
                         let transactions_records_status = transactions_records["status"] as? Bool
                         if transactions_records_status == true {
                            
                             if  let records = transactions_records["records"] as? NSArray{
                                 for i in records {
                                     let dict = i as? [String:Any]
                                     let obj = transactions_recordsObj.init(dict!)
                                     self.arr_transactions_records.append(obj)
                                   
                                 }
                             }

                         }
                     }

                     
                     if let Configurations_Attachments = view_request["Configurations_Attachments"] as? [String:Any]{
                         let Configurations_Attachments_status = Configurations_Attachments["status"] as? Bool
                         if Configurations_Attachments_status == true{
                            
                             if  let records = Configurations_Attachments["records"] as? NSArray{
                                 for i in records {
                                     let dict = i as? [String:Any]
                                     let obj = Configurations_AttachmentsObj.init(dict!)
                                     self.arr_Configurations_Attachments.append(obj)
                                   
                                 }
                             }

                         }
                     }
                     
                     
                     if let project_supervision_form_unit_level = view_request["project_supervision_form_unit_level"] as? [String:Any]{
                         let project_status = project_supervision_form_unit_level["status"] as? Bool
                         if project_status == true{
                            
                             if  let records = project_supervision_form_unit_level["records"] as? NSArray{
                                 for i in records {
                                     let dict = i as? [String:Any]
                                     let obj = project_supervision_form_unit_levelObj.init(dict!)
                                     self.arr_project_supervision_form_unit_level.append(obj)
                                   
                                 }
                             }

                         }
                     }

                     
                     if let Technical_Assistants_Evaluation = view_request["Technical_Assistants_Evaluation"] as? [String:Any]{
                         let Technical_Assistants_Evaluation_status = Technical_Assistants_Evaluation["status"] as? Bool
                         if Technical_Assistants_Evaluation_status == true{
                             arr_Technical_Assistants_Evaluation = []
                             if  let records = Technical_Assistants_Evaluation["records"] as? NSArray{
                                 for i in records {
                                     let dict = i as? [String:Any]
                                     let obj = Technical_Assistants_EvaluationObj.init(dict!)
                                    arr_Technical_Assistants_Evaluation.append(obj)
                                   
                                 }
                             }

                         }
                     }
                     
                 }

                 self.mainView.isHidden = false
                 self.hideLoadingActivity()
                 self.configGUI()
             }
             
             
         }
     }
    
    
    
    
    
    @IBAction func btnWaitingFor_Click(_ sender: Any) {
        var name = "Waiting for : "
        for i in arr_waitingFor{
            name = name + i
        } 
            let popTip = PopTip()
        popTip.bubbleColor = HelperClassSwift.acolor.getUIColor()
        popTip.backgroundColor = HelperClassSwift.acolor.getUIColor()
        popTip.show(text: name, direction: .up, maxWidth: 200, in: view, from:  CGRect(x: btnWaitingFor.center.x + 400, y: btnWaitingFor.center.y + 400, width: 150, height: 40))
    
        //self.scrollView.convert(self.lblLastStepOpened.frame, to: nil)
    }
    
    
    @IBAction func btnNotes_Click(_ sender: Any) {
        
        let vc:NotesVC = AppDelegate.TransactionSB.instanceVC()
        vc.arr_data = self.arr_transactionsNotes
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnFormVersions_Click(_ sender: Any) {
        
        let VC:FormVersionVC = AppDelegate.mainSB.instanceVC()
        //vc.arr_data = self.arr_transactionsNotes
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    
    @IBAction func btnPersonDetails_Click(_ sender: Any) {
        
        let vc:PersonDetailsVC = AppDelegate.TransactionSB.instanceVC()
        vc.arr_data = self.arr_transactions_persons
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnAttachments_Click(_ sender: Any) {
       
        let vc:FormsAttachmentsVC = AppDelegate.TransactionSB.instanceVC()
        vc.arr_data = self.arr_Configurations_Attachments
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @IBAction func btnHistory_Click(_ sender: Any) {
        
        let vc:HistoryVC = AppDelegate.TransactionSB.instanceVC()
        vc.arr_data = self.arr_transactions_records
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func btnSupervisionOperations_Click(_ sender: Any) {
        
        
        let vc:SupervisionOperationVC = AppDelegate.mainSB.instanceVC()
        _ =  panel?.center(vc)
        
    }
    
    @IBAction func btnAllProject_Click(_ sender: Any) {
        
        let vc:AllPrpjectsVC = AppDelegate.mainSB.instanceVC()
        _ =  panel?.center(vc)
        
    }
    
    @IBAction func btnNext_Click(_ sender: Any) {
        
        print(SelectedIndex)
        if SelectedIndex < page_count {
            SelectedIndex = SelectedIndex + 1
            print(SelectedIndex)
            change_page(SelectedIndex: SelectedIndex)
            self.slider.progress = Float(SelectedIndex)/Float(page_count)
            self.lblStep.text =  "step \(SelectedIndex) of \(page_count)"
            self.lblValSelectedStep.text = "\(arr_step[SelectedIndex-1])"
            
            
            let status = StatusObject?.to_array[SelectedIndex-1]
            let title = (status ?? false) ? "Accepted" : "Rejected"
            self.btnLastValStepOpened.setTitle(title, for: .normal)
        }
        
        
        
    }
    
    @IBAction func btnPrevious_Click(_ sender: Any) {
        print(SelectedIndex)
        if SelectedIndex > 0 {
            
            SelectedIndex = SelectedIndex - 1
            print(SelectedIndex)
            change_page(SelectedIndex: SelectedIndex)
            self.slider.progress = Float(SelectedIndex)/Float(page_count)
            self.lblStep.text =  "step \(SelectedIndex) of \(page_count)"
            self.lblValSelectedStep.text = "\(arr_step[SelectedIndex-1])"
            
            let status = StatusObject?.to_array[SelectedIndex-1]
            let title = (status ?? false) ? "Accepted" : "Rejected"
            self.btnLastValStepOpened.setTitle(title, for: .normal)
        }
       
    }
    
    
    @IBAction func location_Click(_ sender: Any) {
        
        let vc:SelectesUnits_levelsVC = AppDelegate.TransactionSB.instanceVC()
        vc.arr_data = self.arr_project_supervision_form_unit_level
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    private func change_page(SelectedIndex:Int) {
        NotificationCenter.default.post(name: NSNotification.Name("Change_Form_Step"),
                                        object: SelectedIndex)
    }
    
    private func update_langVC() {
        NotificationCenter.default.post(name: NSNotification.Name("update_langVC"),
                                        object: nil)
    }
    
//    private func update_Config() {
//        NotificationCenter.default.post(name: NSNotification.Name("update_Congig"),
//                                        object: nil)
//    }
    
    private func update_Config(){
        NotificationCenter.default.addObserver(forName: NSNotification.Name("update_Config"), object: nil, queue: .main) { notifi in
            //guard let index = notifi.object as? Int else { return }
            //self.configGUI()
            self.get_Request()
          
        }
    }
    
}
