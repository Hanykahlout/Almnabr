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
    
    var SelectedIndex:Int = 0
    
    var Object:Tcore?
    
    var cellWidths: [CGFloat] = [900]
    
    let fontStyle: FontAwesomeStyle = .solid
    
    var parentPageVC: TransactionFormPageaVC!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        configNavigation()
        configGUI()
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
        
        self.title = "Form Details".localized()
        
//        self.title.textColor =  HelperClassSwift.acolor.getUIColor()
//        self.title.font = .kufiBoldFont(ofSize: 15)
       // self.lblTitle.text =  "Form Details".localized()
    
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
        
        self.lblValProjectTitle.text =  "First Project in ERP"
        self.lblValProjectTitle.font = .kufiBoldFont(ofSize: 14)
        
        self.lblValServiceName.text =  Object?.transaction_request_description
        self.lblValServiceName.font = .kufiBoldFont(ofSize: 14)
        
        self.lblValFormCode.text =  "2.WIR.1.1"
        self.lblValFormCode.font = .kufiBoldFont(ofSize: 14)
        
        self.lblValDivision.text =  "DIVISION 02 : SITE CONSTRUCTION"
        self.lblValDivision.font = .kufiBoldFont(ofSize: 14)
        
       self.lblValChapter.text =  "Site Work"
        self.lblValChapter.font = .kufiBoldFont(ofSize: 14)
        
        self.lblValItemName.text =  "natural ground Level"
        self.lblValItemName.font = .kufiBoldFont(ofSize: 14)
        
        self.lblValFormSpecifications.text =  "----"
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
        
        self.lblLastValStepOpened.text =  "Configurations"
        self.lblLastValStepOpened.font = .kufiBoldFont(ofSize: 15)
        self.lblLastValStepOpened.textColor =  .green
        
        self.btnLastValStepOpened.setTitleColor(.red, for: .normal)
        self.btnLastValStepOpened.setTitle("(Rejected)".localized(), for: .normal)
       // self.btnLastValStepOpened.font = .kufiBoldFont(ofSize: 15)
        
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
       
    }
    
    
    @IBAction func btnNotes_Click(_ sender: Any) {
        
    }
    @IBAction func btnPersonDetails_Click(_ sender: Any) {
        
    }
    @IBAction func btnAttachments_Click(_ sender: Any) {
        
    }
    @IBAction func btnHistory_Click(_ sender: Any) {
        
    }
    @IBAction func btnSupervisionOperations_Click(_ sender: Any) {
        
    }
    @IBAction func btnAllProject_Click(_ sender: Any) {
        
    }
    
    @IBAction func btnNext_Click(_ sender: Any) {
        change_page()
        SelectedIndex = SelectedIndex + 1
    }
    
    @IBAction func btnPrevious_Click(_ sender: Any) {
        if SelectedIndex > 0 {
            change_page()
            SelectedIndex = SelectedIndex - 1
        }
       
    }
    
    
    private func change_page() {
        NotificationCenter.default.post(name: NSNotification.Name("Change_Form_Step"), object: SelectedIndex)
    }
    
}
