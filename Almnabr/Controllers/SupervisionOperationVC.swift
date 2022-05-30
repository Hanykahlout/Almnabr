//
//  SupervisionOperationVC.swift
//  Almnabr
//
//  Created by MacBook on 18/10/2021.
//  Copyright © 2021 Samar Akkila. All rights reserved.
//

import UIKit
import DPLocalization
import FontAwesome_swift
import MOLH

var ProjectName:String?
class SupervisionOperationVC: UIViewController {
    
    
    @IBOutlet weak var lblsupervision: UILabel!
    @IBOutlet weak var lblRequest: UILabel!
    
    @IBOutlet weak var viewsupervision: UIView!
    @IBOutlet weak var viewRequest: UIView!
    
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var header: HeaderView!
    
    var parentPageViewController: MyPageViewController!
    
    var StrTitle:String = "Projects".localized()
    var StrSubMenue:String = "All Projects".localized()
    var StrMenue:String = ""
    var SelectedIndex:Int = 0
    var MenuObj:MenuObj?
    
   // let maincolor = "458FB8".getUIColor()
    
    var index = 0
    var identifiers: NSArray = ["ProjectRequestVC", "SupervisionOperationDetailsVC"]
    
    
    var Object:projectObj?
   
    var arr_view :[UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configGUI()
        header.btnAction = menu_select
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Config Navigation
    func configNavigation() {
        _ = self.navigationController?.preferredStatusBarStyle
        self.view.backgroundColor = "FFFFFF".getUIColor() //F0F4F8
        navigationController?.navigationBar.barTintColor = .red
        
        addNavigationBarTitle(navigationTitle: StrTitle)
    }
    
    
    //MARK: - Config GUI
    //------------------------------------------------------
    func configGUI() {
       
        self.lblsupervision.text = "Supervision Operation".localized()
        self.lblRequest.text = "Project Request".localized()
       
        self.lblsupervision.font = .kufiRegularFont(ofSize: 13)
        self.lblRequest.font = .kufiRegularFont(ofSize: 13)
        
        ProjectName = Object?.projects_profile_name_en
        
        self.viewsupervision.backgroundColor = maincolor
        self.lblsupervision.textColor = .white
        
        
        self.viewRequest.backgroundColor = .clear
        self.lblRequest.textColor = maincolor
        self.viewRequest.setBorderWithColor(maincolor)
        
       
    }
    
    
    
   
    
    
    func menu_select(){
        let language =  MOLHLanguage.currentAppleLanguage()
        if language == "ar"{
            panel?.openRight(animated: true)
        }else{
            panel?.openLeft(animated: true)
        }
        
    }
    

    
    
    
//    @IBAction func btnProjectRequest_Click(_ sender: Any) {
//        let shared = NotifiRoute()
//        guard let top_vc = shared.menu_vc() else { return }
//        let vc: ProjectRequestVC = AppDelegate.mainSB.instanceVC()
//        top_vc.navigationController?.pushViewController(vc, animated: true)
//    }
    
    @IBAction func btnProjectRequest_Click(_ sender: Any) {
        
        self.viewRequest.backgroundColor = maincolor
        self.lblRequest.textColor = .white
        
        
        self.viewsupervision.backgroundColor = .clear
        self.lblsupervision.textColor = maincolor
        self.viewsupervision.setBorderWithColor(maincolor)
        
        
        self.SelectedIndex = 1
        self.change_page()
        
    }
    
    @IBAction func btnsupervision_Click(_ sender: Any) {
        
        self.viewsupervision.backgroundColor = maincolor
        self.lblsupervision.textColor = .white
        
        
        self.viewRequest.backgroundColor = .clear
        self.lblRequest.textColor = maincolor
        self.viewRequest.setBorderWithColor(maincolor)
        
        self.SelectedIndex = 0
        self.change_page()
    }
    
    
  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Change_Supervision",
           let destinationVC = segue.destination as? MyPageViewController {
           // parentPageViewController.isPagingEnabled = false
            //  destinationVC.numberToDisplay = counter
            // destinationVC.displayPageForIndex(index: self.SelectedIndex)
            if let controller = self.parentPageViewController {
                //    controller.displayPageForIndex(index: self.SelectedIndex)
            }
        }
    }
    
    private func change_page() {
        NotificationCenter.default.post(name: NSNotification.Name("Change_Supervision"), object: SelectedIndex)
    }
    
}


    


