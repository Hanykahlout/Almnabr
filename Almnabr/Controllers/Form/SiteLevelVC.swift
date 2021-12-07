//
//  SiteLevelVC.swift
//  Almnabr
//
//  Created by MacBook on 05/11/2021.
//  Copyright © 2021 Samar Akkila. All rights reserved.
//

import UIKit
import DropDown



protocol GeneralDelegate {
    func pass(data: [GeneralObj],unit_arr: [uintObj])
}

protocol ByPhasesDelegate {
  func passByPhasesArr(data: [ByPhaseObj])
}

class SiteLevelVC: UIViewController , ByPhasesDelegate ,GeneralDelegate{
  
    
    func pass(data: [GeneralObj],unit_arr: [uintObj]) { //conforms to protocol
     // implement your own implementation
        self.arr_unit = self.arr_unit + unit_arr
        self.arr_General = self.arr_General + data
        self.tableByGeneral.reloadData()
      }
    
    func passByPhasesArr(data: [ByPhaseObj]) { //conforms to protocol
     // implement your own implementation
        self.arr_ByPhase = self.arr_ByPhase + data
        self.tableByPhase.reloadData()
      }
    
    
    @IBOutlet weak var lblSeparateUnits: UILabel!
    @IBOutlet weak var lblUnitsYes: UILabel!
    @IBOutlet weak var lblUnitsNo: UILabel!
    
    @IBOutlet weak var lblWorkSite: UILabel!
    @IBOutlet weak var lblAllUnits: UILabel!
    @IBOutlet weak var lblGeneralNo: UILabel!
    @IBOutlet weak var lblPhases: UILabel!
    
    @IBOutlet weak var btnUnitsYes: UIImageView!
    @IBOutlet weak var btnUnitsNo: UIImageView!
    
    @IBOutlet weak var btnAllUnits: UIImageView!
    @IBOutlet weak var btnGeneralNo: UIImageView!
    @IBOutlet weak var btnPhases: UIImageView!
    
    @IBOutlet weak var ViewBtnAllUnits: UIView!
    
    @IBOutlet weak var ViewAllUnits: UIView!
    @IBOutlet weak var ViewGeneralNo: UIView!
    @IBOutlet weak var ViewPhases: UIView!
    
    @IBOutlet weak var imgStep: UIImageView!
    @IBOutlet weak var viewStep: UIView!
    @IBOutlet weak var lblStep: UILabel!
    
    
    @IBOutlet weak var tableByPhase: UITableView!
    @IBOutlet weak var tableByGeneral: UITableView!
    
    @IBOutlet weak var lblWorkLevel: UILabel!
    @IBOutlet weak var lblSelectWorkLevel: UILabel!
    @IBOutlet weak var viewsWorkLevel: UIView!
    
    @IBOutlet weak var btnWorkLevel: UIButton!
    
    @IBOutlet weak var imgDropWorkLevel: UIImageView!
    
    @IBOutlet weak var ViewAllUnitsSelect: UIView!
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPrevious: UIButton!
    
    let checked =  UIImage.fontAwesomeIcon(name: .checkCircle, style: .solid, textColor: HelperClassSwift.bcolor.getUIColor(), size: CGSize(width: 40, height: 40))
    
    let Unchecked =  UIImage.fontAwesomeIcon(name: .circle, style: .solid, textColor: HelperClassSwift.bcolor.getUIColor(), size: CGSize(width: 40, height: 40))
    
    let dropUpmage =  UIImage.fontAwesomeIcon(name: .chevronUp , style: .solid, textColor:  .gray, size: CGSize(width: 40, height: 40))
    
    let dropDownmage =  UIImage.fontAwesomeIcon(name: .chevronDown , style: .solid, textColor:  .gray, size: CGSize(width: 40, height: 40))
    
    
    
    var arr_Work:[ModuleObj] = []
    var arr_workLevelLabel:[String] = []
    var arr_NoData:[String] = ["No items found".localized()]
    
    var arr_General:[GeneralObj] = []
    var arr_ByPhase:[ByPhaseObj] = []
    var arr_unit:[uintObj] = []
    
    var StrWorkLevel:String = ""
    var level_Unit = ""
    var units :String = ""
    var StrLanguage:String = "en"
    var work_site:String = "ALL"
    var transaction_separation :String = "0"
    var GeneralTable:Bool = true
    var ProjectObj:templateObj!
    
    var params = [:] as [String : String]
    
    
    var isGeneral:Bool = false
    var isAllUnits:Bool = true
    var isByPhases:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configGUI()
        
        setupTable()
        get_WorkLevel()
        
    }
    

    
    
    
    //MARK: - Config GUI
    //------------------------------------------------------
    func configGUI() {
        
        
        lblSeparateUnits.textColor =  HelperClassSwift.bcolor.getUIColor()
        lblSeparateUnits.font = .kufiRegularFont(ofSize: 15)
        lblSeparateUnits.text = "txt_SeparateUnits".localized()
        
        
        
        lblUnitsYes.textColor =  HelperClassSwift.bcolor.getUIColor()
        lblUnitsYes.font = .kufiRegularFont(ofSize: 15)
        lblUnitsYes.text = "txt_Yes".localized()
        
        lblUnitsNo.textColor =  HelperClassSwift.bcolor.getUIColor()
        lblUnitsNo.font = .kufiRegularFont(ofSize: 15)
        lblUnitsNo.text = "txt_No".localized()
        
        
        lblWorkSite.textColor =  HelperClassSwift.bcolor.getUIColor()
        lblWorkSite.font = .kufiRegularFont(ofSize: 15)
        lblWorkSite.text = "txt_WorkSite".localized()
        
        
        lblAllUnits.textColor =  HelperClassSwift.bcolor.getUIColor()
        lblAllUnits.font = .kufiRegularFont(ofSize: 13)
        lblAllUnits.text = "txt_AllUnits".localized()
        
        lblGeneralNo.textColor =  HelperClassSwift.bcolor.getUIColor()
        lblGeneralNo.font = .kufiRegularFont(ofSize: 13)
        lblGeneralNo.text = "txt_GeneralNo".localized()
        
        lblPhases.textColor =  HelperClassSwift.bcolor.getUIColor()
        lblPhases.font = .kufiRegularFont(ofSize: 13)
        lblPhases.text = "txt_Phases".localized()
        
        
        self.viewsWorkLevel.setBorderGray()
        
        lblWorkLevel.textColor = HelperClassSwift.bcolor.getUIColor()
        lblWorkLevel.font = .kufiRegularFont(ofSize: 15)
        lblWorkLevel.text = "txt_FillWorkLevel".localized()
        
        
        lblSelectWorkLevel.textColor = .gray
        lblSelectWorkLevel.font = .kufiRegularFont(ofSize: 15)
        lblSelectWorkLevel.text = "txt_FillWorkLevel".localized()
       
        self.btnPhases.image = UIImage(named: "uncheck")
        self.btnGeneralNo.image = UIImage(named: "uncheck")
        self.btnAllUnits.image = UIImage(named: "check")
        self.btnUnitsNo.image = UIImage(named: "check")
        self.btnUnitsYes.image = UIImage(named: "uncheck")
        
        self.ViewBtnAllUnits.isHidden = false
        
        self.viewStep.backgroundColor = HelperClassSwift.acolor.getUIColor()
        self.lblStep.text = "txt_SiteLevel".localized()
        self.lblStep.font = .kufiBoldFont(ofSize: 15)
        self.lblStep.textColor = HelperClassSwift.acolor.getUIColor()
        
        self.btnNext.backgroundColor = HelperClassSwift.acolor.getUIColor()
        self.btnPrevious.backgroundColor = HelperClassSwift.acolor.getUIColor()
        
        self.viewStep.setBorderGrayWidth(3)
        let Stepimage =  UIImage.fontAwesomeIcon(name: .building, style: .solid, textColor: HelperClassSwift.bcolor.getUIColor(), size: CGSize(width: 40, height: 40))
        self.imgStep.image = Stepimage
        
       
        
        //self.mainView.setBorderGray()
        
    }
    
    
    
    func setupTable(){
        
        self.tableByPhase.dataSource = self
        self.tableByPhase.delegate = self
        
        self.tableByGeneral.dataSource = self
        self.tableByGeneral.delegate = self
        
        let nib = UINib(nibName: "FormVersionCell", bundle: nil)
        tableByPhase.register(nib, forCellReuseIdentifier: "FormVersionCell")
        
        let nib2 = UINib(nibName: "GeneralNoCell", bundle: nil)
        tableByGeneral.register(nib2, forCellReuseIdentifier: "GeneralNoCell")
        
        self.tableByPhase.reloadData()
        self.tableByGeneral.reloadData()
    }
    
    
    func get_WorkLevel(){
        guard ProjectObj != nil else{
            return
        }
       // self.showLoadingActivity()
        APIManager.sendRequestGetAuth(urlString: "form/FORM_WIR/get_work_levels_for_transaction?projects_work_area_id=\(ProjectObj.projects_work_area_id)&platform_code_system=\(ProjectObj.template_platform_code_system)&transaction_separation=0&template_id=\(ProjectObj.template_id)&lang_key=en&work_site=ALL" ) { (response) in
            
            
            let status = response["status"] as? Bool
            if status == true{
                if  let list = response["records"] as? NSArray{
                    for i in list {
                        let dict = i as? [String:Any]
                        let obj = ModuleObj.init(dict!)
                        self.arr_Work.append(obj)
                        // for echitem in obj{
                        self.level_Unit = obj.value
                        self.arr_workLevelLabel.append(obj.label)
                        // }
                        
                    }
                    self.hideLoadingActivity()
                }
            }
            
            
        }
    }
    
    
    
    func Configuration_step1(){
        
        self.showLoadingActivity()
        
        guard ProjectObj != nil else{
            return
        }
       
        //var params = [:] as [String : String]
        
        self.params["projects_work_area_id"] = ProjectObj.projects_work_area_id
        
        self.params["platform_code_system"] = ProjectObj.template_platform_code_system
        self.params["template_id"] = ProjectObj.template_id
        self.params["lang_key"] = StrLanguage
        self.params["transaction_separation"] = transaction_separation
        self.params["page_no"] = "1"
        self.params["page_size"] = "10"
        self.params["work_site"] = self.work_site
        
        
        if arr_unit.count == 0 {
            self.params["units_and_level[\(self.level_Unit)]"] = self.units
        }else{
           
            var unit_str :String = ""
            var value_str :String = ""
            
            for i in arr_unit {
             
                if value_str == i.value! {
                    unit_str = unit_str + i.unit! + ","
                    self.params["units_and_level[\(i.value ?? "level_all_building")]"] = i.unit
                    value_str = i.value!
                }else{
                    self.params["units_and_level[\(i.value ?? "level_all_building")]"] = i.unit
                    value_str = i.value!
                }
               
            }
            
        }
        
     
        
        APIManager.sendRequestPostAuth(urlString: "form/FORM_WIR/cr/1/0", parameters: params ) { (response) in
            self.hideLoadingActivity()
           
            
            let status = response["status"] as? Bool
            let error = response["error"] as? String
            let SkipPage = response["SkipPage"] as? Bool
            
            if status == true{
                
               
                if SkipPage == true{
                    self.next(SkipPage: true)
//                    let VC:RelatedFormsVC = AppDelegate.mainSB.instanceVC()
//                    VC.ProjectObj = self.ProjectObj
//                    VC.StrLanguage = self.StrLanguage
//                    VC.units_and_level = self.ProjectObj.phase_zone_block_cluster_g_nos
//                    VC.transaction_separation = self.transaction_separation
//                    VC.arr_unit = self.arr_unit
//                    VC.params = self.params
//                    VC.work_site = self.work_site
//                    VC.units = self.units
//                    VC.level_Unit = self.level_Unit
//                    self.navigationController?.pushViewController(VC, animated: true)
                    
                }else{
                    self.next(SkipPage: false)
                }
            }else{
                self.showAMessage(withTitle: "Error", message: error ?? "Some thing went wrong")
                
            }

            
           
            }

        
    }
    
    
    func next(SkipPage:Bool){
        
        
        let VC:FormVersionVC = AppDelegate.mainSB.instanceVC()
        VC.Skipnext = SkipPage
        if isGeneral == true {
            self.units = ""
            for i in arr_General {
                arr_unit.append(uintObj(unit: i.units, value: i.Worklevels))
                self.units = self.units + i.units! + ","
            }
            if arr_General.count == 1 {
                VC.IsOneChar = true
            }
            VC.units_and_level = units
        }else if isAllUnits == true {
            VC.units_and_level = ProjectObj.phase_zone_block_cluster_g_nos
        }else if isByPhases == true{
            self.units = ""
            for i in arr_ByPhase {
                units = units + i.units! + ","
            }
            if arr_ByPhase.count == 1 {
                VC.IsOneChar = true
            }
            VC.units_and_level = units
        }
       
        VC.arr_unit = arr_unit
        VC.ProjectObj = self.ProjectObj
        VC.StrLanguage = self.StrLanguage
        VC.transaction_separation = transaction_separation
        VC.work_site = self.work_site
        VC.units = self.units
        VC.level_Unit = self.level_Unit
       // if arr_unit.count != 0  {
            
            VC.params = self.params
            self.navigationController?.pushViewController(VC, animated: true)
            
//        }else{
//            self.showAMessage(withTitle: "error".localized(),message: "all_fields_are_required")
//            
//        }
        
    }
    
    @IBAction func btnWorkLevel_Click(_ sender: Any) {
        
        self.imgDropWorkLevel.image = dropUpmage
        let dropDown = DropDown()
        dropDown.anchorView = view
        dropDown.backgroundColor = .white
        dropDown.cornerRadius = 2.0
        
        if self.arr_workLevelLabel.count == 0 {
            dropDown.dataSource = self.arr_NoData
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                self.imgDropWorkLevel.image = dropDownmage
            }
            dropDown.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }else{
            dropDown.dataSource = self.arr_workLevelLabel
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                
                if item == self.arr_workLevelLabel[index] {
                    self.lblSelectWorkLevel.text =  item
                    let i =  self.arr_Work[index]
                    self.StrWorkLevel = i.value
                    self.units = ProjectObj.phase_zone_block_cluster_g_nos
                    self.imgDropWorkLevel.image = dropDownmage
                    self.btnWorkLevel.isHidden = false
                    
                }
                
            }
            
        }
        dropDown.direction = .bottom
        dropDown.anchorView = viewsWorkLevel
        dropDown.bottomOffset = CGPoint(x: 0, y: viewsWorkLevel.bounds.height)
        dropDown.width = viewsWorkLevel.bounds.width
        dropDown.show()

    }
    
    
    
    @IBAction func btnWorkLevelDelete_Click(_ sender: Any) {
        self.lblSelectWorkLevel.text = "txt_Groupe2".localized()
        self.btnWorkLevel.isHidden = true
    }
    
    
    
    
    @IBAction func btnNext_Click(_ sender: Any) {
 
        self.Configuration_step1()
        
    }
    
    @IBAction func btnBack_Click(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnGeneralNo_Click(_ sender: Any) {
        
        
        GeneralTable = true
        
        isAllUnits = false
        isGeneral = true
        isByPhases = false
        
          self.btnPhases.image = UIImage(named: "uncheck")
          self.btnGeneralNo.image = UIImage(named: "check")
          self.btnAllUnits.image = UIImage(named: "uncheck")
          
          self.ViewAllUnits.isHidden = true
          self.ViewPhases.isHidden = true
          self.ViewGeneralNo.isHidden = false
        
        self.work_site = "GN"
        

        
    }
    
  
    
    
    @IBAction func btnPhases_Click(_ sender: Any) {
        
        GeneralTable = false
        
        isAllUnits = false
        isGeneral = false
        isByPhases = true
        
        self.btnPhases.image = UIImage(named: "check")
        self.btnGeneralNo.image = UIImage(named: "uncheck")
        self.btnAllUnits.image = UIImage(named: "uncheck")
        
        self.ViewAllUnits.isHidden = true
        self.ViewPhases.isHidden = false
        self.ViewGeneralNo.isHidden = true
        
        self.work_site = "PH"
        
    }
    
    
    @IBAction func btnUnits_Click(_ sender: Any) {
        
        
        isAllUnits = true
        isGeneral = false
        isByPhases = false
        
        self.btnPhases.image = UIImage(named: "uncheck")
        self.btnGeneralNo.image = UIImage(named: "uncheck")
        self.btnAllUnits.image = UIImage(named: "check")
        
        
        self.ViewAllUnits.isHidden = false
        self.ViewPhases.isHidden = true
        self.ViewGeneralNo.isHidden = true
        
        self.work_site = "ALL"
        
    }
    
    @IBAction func btnUnitslNo_Click(_ sender: Any) {
        
        self.transaction_separation = "0"
        
        self.ViewAllUnits.isHidden = false
        self.ViewBtnAllUnits.isHidden = false
        
        self.btnUnitsNo.image = UIImage(named: "check")
        self.btnUnitsYes.image = UIImage(named: "uncheck")
        self.ViewAllUnitsSelect.isHidden = false
    }
    
    @IBAction func btnUnitsYes_Click(_ sender: Any) {
        
        self.transaction_separation = "1"
        self.ViewAllUnits.isHidden = true
        self.ViewBtnAllUnits.isHidden = true
        
        self.btnUnitsNo.image = UIImage(named: "uncheck")
        self.btnUnitsYes.image = UIImage(named: "check")
        self.ViewAllUnitsSelect.isHidden = true
    
    }
    
    
    @IBAction func btnAddGeneral_Click(_ sender: Any) {
    let vc:AddGeneralNoVC  = AppDelegate.mainSB.instanceVC()
        
        vc.isModalInPresentation = true
        vc.modalPresentationStyle = .overFullScreen
        vc.definesPresentationContext = true
        vc.delegate = self
        vc.ProjectObj = self.ProjectObj
        vc.StrLanguage = self.StrLanguage
        vc.transaction_separation = transaction_separation
        vc.arr_unit = self.arr_unit
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnAddPhases_Click(_ sender: Any) {
        let vc:AddByPhasesVC  = AppDelegate.mainSB.instanceVC()
        
        vc.isModalInPresentation = true
        vc.modalPresentationStyle = .overFullScreen
        vc.definesPresentationContext = true
        vc.Phasesdelegate = self
        vc.ProjectObj = self.ProjectObj
        vc.StrLanguage = self.StrLanguage
        vc.transaction_separation = transaction_separation
        self.present(vc, animated: true, completion: nil)
    }

    
}



extension SiteLevelVC: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        if GeneralTable == true{
            return arr_General.count
        }else{
            return arr_ByPhase.count
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if GeneralTable == true{
           
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "GeneralNoCell", for: indexPath) as! GeneralNoCell
            
            let obj = arr_General[indexPath.item]
            
    
            cell.lblNo.text = "\(indexPath.item + 1)"
            cell.lblUnit.text = obj.units!
            cell.lblWorklevels.text = obj.Worklevels!
            cell.lblNo.font = .kufiRegularFont(ofSize: 17)
            cell.lblUnit.font = .kufiRegularFont(ofSize: 17)
            cell.lblWorklevels.font = .kufiRegularFont(ofSize: 17)
 
            
            cell.btnDeleteAction = {
                
                self.arr_General.remove(at: indexPath.item)
                self.tableByGeneral.reloadData()
          
            }
   
            return cell

        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "FormVersionCell", for: indexPath) as! FormVersionCell
            
            let obj = arr_ByPhase[indexPath.item]
         
            let Number = "#" + "  \(obj.number ?? 0)"
            let zones = "zones".localized() +  "   \(obj.zones!)"
            let Blocks = "Blocks".localized() + "   \(obj.Blocks!)"
            let Clusters = "Clusters".localized() + "   \(obj.Clusters!)"
            let Units = "Units".localized() + "   \(obj.units!)"
            let WorkLevel = "Work Level".localized() + "   \(obj.Worklevels!)"
            
            
            cell.lblNo.text = Number
            
            cell.lblTransactionNo.text = zones
            cell.lblUnit.text = Blocks
            cell.lblBarcode.text = Clusters
            cell.lblWorklevel.text = WorkLevel
            cell.lblDate.text = Units
            cell.lblEvaluationResult.isHidden = true
            
            cell.btnAction.tintColor = .red
            cell.btnAction.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
            cell.btn_Action = {
                self.arr_ByPhase.remove(at: indexPath.item)
                self.tableByPhase.reloadData()
                
            }
                
         
            let Numberattributed: NSAttributedString = Number.attributedStringWithColor(["#".localized()], color: HelperClassSwift.acolor.getUIColor())
            cell.lblNo.attributedText = Numberattributed
            
            let zonesattributed: NSAttributedString = zones.attributedStringWithColor(["zones".localized()], color: HelperClassSwift.acolor.getUIColor())
            cell.lblTransactionNo.attributedText = zonesattributed
            
            let Blocksattributed: NSAttributedString = Blocks.attributedStringWithColor(["Blocks".localized()], color: HelperClassSwift.acolor.getUIColor())
            cell.lblUnit.attributedText = Blocksattributed
            
            
            
            let Clustersattributed: NSAttributedString = Clusters.attributedStringWithColor(["Clusters".localized()], color: HelperClassSwift.acolor.getUIColor())
            cell.lblBarcode.attributedText = Clustersattributed
            
            
            let WorkLevelattributed: NSAttributedString = WorkLevel.attributedStringWithColor(["Work Level".localized()], color: HelperClassSwift.acolor.getUIColor())
            cell.lblWorklevel.attributedText = WorkLevelattributed

            
            let Unitsattributed: NSAttributedString = Units.attributedStringWithColor(["Units".localized()], color: HelperClassSwift.acolor.getUIColor())
            cell.lblDate.attributedText = Unitsattributed

            
            cell.viewBack.setcorner()
         
                     return cell
            
        }
  
    }
    

}


