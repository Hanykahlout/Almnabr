//
//  RelatedFormsVC.swift
//  Almnabr
//
//  Created by MacBook on 05/11/2021.
//  Copyright © 2021 Samar Akkila. All rights reserved.
//

import UIKit
import DPLocalization

class RelatedFormsVC: UIViewController {

   
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var imgStep: UIImageView!
    @IBOutlet weak var viewStep: UIView!
    @IBOutlet weak var lblStep: UILabel!
    @IBOutlet weak var lblnodata: UILabel!
    @IBOutlet weak var lblRelatedFormKey: UILabel!
    @IBOutlet weak var lblRelatedFormValue: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var btnPrevious: UIButton!
    
    var arr_data:[RelatedFormObj] = []
    var arr_unit:[uintObj] = []
    
    var pageNumber = 1
    var allItemDownloaded = false
    
    var ProjectObj:templateObj!
    var transaction_separation:String = ""
    var units_and_level :String = ""
    var StrLanguage:String = "en"
    var units :String = ""
    var work_site:String = "ALL"
    var params = [:] as [String : String]
    var level_Unit = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configGUI()
        get_Form(showLoading: true, loadOnly: true)
        
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    //MARK: - Config GUI
    //------------------------------------------------------
    func configGUI() {
 
        self.lblnodata.text =  "txt_NoData".localized()
        self.lblnodata.font = .kufiRegularFont(ofSize: 15)
        self.lblnodata.isHidden = true
      
        self.lblnodata.isHidden = false
       
        
        self.mainView.setBorderGray()
        
        self.viewStep.backgroundColor = HelperClassSwift.acolor.getUIColor()
        self.lblStep.text = "txt_Relatedforms".localized()
        self.lblStep.font = .kufiBoldFont(ofSize: 15)
        self.lblStep.textColor = HelperClassSwift.acolor.getUIColor()
        
        
        self.lblRelatedFormKey.text = "Related Forms : ".localized()
        self.lblRelatedFormKey.font = .kufiRegularFont(ofSize: 15)
        self.lblRelatedFormKey.textColor = .gray
        
        
        self.lblRelatedFormValue.font = .kufiRegularFont(ofSize: 15)
        self.lblRelatedFormValue.textColor = .red
        
        
//        self.btnNext.backgroundColor = HelperClassSwift.acolor.getUIColor()
//        self.btnPrevious.backgroundColor = HelperClassSwift.acolor.getUIColor()
        
        
        self.viewStep.setBorderGrayWidth(3)
        let Stepimage =  UIImage.fontAwesomeIcon(name: .building, style: .solid, textColor: HelperClassSwift.bcolor.getUIColor(), size: CGSize(width: 40, height: 40))
        self.imgStep.image = Stepimage
        
        
        table.dataSource = self
        table.delegate = self
        let nib = UINib(nibName: "FormVersionCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: "FormVersionCell")
       
        self.btnNext.setTitle("Next".localized(), for: .normal)
        self.btnNext.backgroundColor =  HelperClassSwift.acolor.getUIColor()
        self.btnNext.setTitleColor(.white, for: .normal)
        self.btnNext.setRounded(10)
        
        
        self.btnPrevious.setTitle("Previous".localized(), for: .normal)
        self.btnPrevious.backgroundColor =  HelperClassSwift.acolor.getUIColor()
        self.btnPrevious.setTitleColor(.white, for: .normal)
        self.btnPrevious.setRounded(10)
        
        
    }
    
    func get_Form(showLoading: Bool, loadOnly: Bool){
        
        
        if showLoading {
            self.showLoadingActivity()
        }
        
        var language = ""
        
        if let Language = dp_get_current_language() {
            language = Language
        }
        guard ProjectObj != nil else{
            return
        }
        
//        let params = ["projects_work_area_id" : ProjectObj.projects_work_area_id,
//                      "platform_code_system" : ProjectObj.template_platform_code_system,
//                      "lang_key": StrLanguage,
//                      "transaction_separation":transaction_separation,
//                      "page_no":"1",
//                      "page_size":"10",
//                      "work_site":"ALL",
//                      "units_and_level[level_all_building]":units_and_level,
//                      "template_id":ProjectObj.template_id] as [String : Any]
        
        APIManager.sendRequestPostAuth(urlString: "form/FORM_WIR/cr/1/0", parameters: self.params ) { (response) in
            self.hideLoadingActivity()
           
            
            if self.pageNumber == 1 {
                self.arr_data.removeAll()
            }
            
           
            if loadOnly {
                self.table.reloadData()
            }
            
            
            let status = response["status"] as? Bool
            let NextButton = response["NextButton"] as? Bool
            let SkipPage = response["SkipPage"] as? Bool
            let Rule = response["Rule"] as? [String:Any]
            
            
            if status == true{
                
                let page = response["page"] as? [String:Any]
                
                if  let list = response["records"] as? NSArray{
                    for i in list {
                        let dict = i as? [String:Any]
                        let obj = RelatedFormObj.init(dict!)
                        self.arr_data.append(obj)
                        self.table.reloadData()
                        
                    }
                    
                    
                    let RuleObj = RuleObj(Rule!)
                    
                    self.lblRelatedFormValue.text = "all related forms must be approved then you can open again :".localized() + " \(RuleObj.all_platforms_required)"



                    if NextButton == false {
                        self.btnNext.isHidden = true
                    }
                    let pageObj = PageObj(page!)
                  
                    if pageObj.total_pages > self.pageNumber {
                        self.allItemDownloaded = false
                    }else{
                        self.allItemDownloaded = true
                    }
                    if list.count == 0 {
                        self.lblnodata.isHidden = false
                    }else{
                        self.lblnodata.isHidden = true
                    }
                    self.hideLoadingActivity()
                }
            }

            
           
            }
        }

    
    
    @IBAction func btnNext_Click(_ sender: Any) {
        
        let VC:AttachmentsVC = AppDelegate.mainSB.instanceVC()
        VC.ProjectObj = self.ProjectObj
        VC.StrLanguage = self.StrLanguage
        VC.units_and_level = self.units_and_level
        VC.transaction_separation = transaction_separation
        VC.arr_unit = self.arr_unit
        VC.parm = self.params
        VC.work_site = self.work_site
        VC.units = self.units
        VC.level_Unit = self.level_Unit
        self.navigationController?.pushViewController(VC, animated: true)
        
    }
    
    
    @IBAction func btnBack_Click(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }

}



extension RelatedFormsVC: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
      
            return arr_data.count
    
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
            let cell = tableView.dequeueReusableCell(withIdentifier: "FormVersionCell", for: indexPath) as! FormVersionCell
            
            let obj = arr_data[indexPath.item]
         
      
        let Number = "#" + "  \(indexPath.item + 1)"
        let Unit = "Unit".localized() + "   \(obj.unit)"
        let WorkLevel = "Work Level".localized() + "   \(obj.work_level_label)"
        let Result = "Evaluation Result".localized() + "   \(obj.result_code)"
        let RelatedForms = "Related Forms".localized() + "   \(obj.platform_label)"
      
        
        cell.lblNo.text = Number
        cell.lblUnit.text = Unit
        cell.lblWorklevel.text = WorkLevel
        cell.lblEvaluationResult.text = Result
        cell.lblDate.text = RelatedForms
        
        cell.lblBarcode.isHidden = true
        cell.lblTransactionNo.isHidden = true
        
        if obj.file_path != "" {
            cell.btnAction.isHidden = false
        }else{
            cell.btnAction.isHidden = true
        }
       
            let Numberattributed: NSAttributedString = Number.attributedStringWithColor(["#".localized()], color: HelperClassSwift.acolor.getUIColor())
            cell.lblNo.attributedText = Numberattributed
            
         
            
            let Unitattributed: NSAttributedString = Unit.attributedStringWithColor(["Unit".localized()], color: HelperClassSwift.acolor.getUIColor())
            cell.lblUnit.attributedText = Unitattributed
            
            
            
            let WorkLevelattributed: NSAttributedString = WorkLevel.attributedStringWithColor(["Work Level".localized()], color: HelperClassSwift.acolor.getUIColor())
            cell.lblWorklevel.attributedText = WorkLevelattributed
            
            
            let Resultattributed: NSAttributedString = Result.attributedStringWithColor(["Evaluation Result".localized()], color: HelperClassSwift.acolor.getUIColor())
            cell.lblEvaluationResult.attributedText = Resultattributed
            
            
        
        let Dateattributed: NSAttributedString = RelatedForms.attributedStringWithColor(["Related Forms".localized()], color: HelperClassSwift.acolor.getUIColor())
        cell.lblDate.attributedText = Dateattributed
        
        switch obj.color {
        case "RED":
            cell.viewColor.backgroundColor = .red
        case "ORANGE":
            cell.viewColor.backgroundColor = .orange
        default:
            cell.viewColor.backgroundColor = .lightGray
        }
        
        cell.viewBack.setcorner()
        
        
        return cell
        
        
  
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let obj = arr_data[indexPath.item]
        if obj.file_path != "" {
        let vc:PDFViewrVC  = AppDelegate.mainSB.instanceVC()
           
        vc.isModalInPresentation = true
        //vc.modalPresentationStyle = .overFullScreen
        vc.definesPresentationContext = true
        vc.Strurl = obj.file_path
        self.present(vc, animated: true, completion: nil)
    }}
    
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
                get_Form(showLoading: false, loadOnly: true)
            }
       }


}


