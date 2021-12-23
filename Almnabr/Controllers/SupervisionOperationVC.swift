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

var ProjectName:String?
class SupervisionOperationVC: UIViewController {
    
    
    @IBOutlet weak var imgNext1: UIImageView!
    @IBOutlet weak var imgNext2: UIImageView!
    
    @IBOutlet weak var lblHome: UIButton!
    @IBOutlet weak var lblMenuName: UILabel!
    @IBOutlet weak var lblSubMenuName: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblAllProject: UILabel!
    @IBOutlet weak var lblMainProjectView: UILabel!
    @IBOutlet weak var lblSupervision: UILabel!
    
    @IBOutlet weak var View_AllProject: UIView!
    @IBOutlet weak var View_MainProjectView: UIView!
    @IBOutlet weak var View_Supervision: UIView!
    @IBOutlet weak var View_FormTransaction: UIView!
    @IBOutlet weak var View_TeamUser: UIView!
    @IBOutlet weak var View_Contacts: UIView!
    @IBOutlet weak var View_Documents: UIView!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var Viewcollection: UICollectionView!
    
    
    
    @IBOutlet weak var header: HeaderView!
    
    var parentPageViewController: MyPageViewController!
    
    var StrTitle:String = "Projects".localized()
    var StrSubMenue:String = "All Projects".localized()
    var StrMenue:String = ""
    var SelectedIndex:Int = 0
    var MenuObj:MenuObj?
    
    
    
    var index = 0
    var identifiers: NSArray = ["FromTransactionVC", "TeamUserVC","ContactsVC","DocumentsVC"]
    
    var Object:projectObj?
    var arrFormStep:[String] = ["Form Transaction".localized(),"Team Users".localized(),"Contacts".localized(),"Documents".localized()]
    var arrIcons:[String] = ["fa-id-card","fa-users","fa-mobile","fa-copy"]
    
    var arr_view :[UIViewController] = []
    let fontStyle: FontAwesomeStyle = .solid
    
    
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
        self.navigationController?.setNavigationBarHidden(false, animated: false)
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
        
        
        lblHome.titleLabel?.textColor =  HelperClassSwift.bcolor.getUIColor()
        lblHome.titleLabel?.font = .kufiRegularFont(ofSize: 15)
        
        lblMenuName.textColor =  HelperClassSwift.acolor.getUIColor()
        lblMenuName.font = .kufiRegularFont(ofSize: 15)
        
        lblSubMenuName.textColor =  HelperClassSwift.acolor.getUIColor()
        lblSubMenuName.font = .kufiRegularFont(ofSize: 15)
        
        
        self.lblHome.titleLabel?.text =  "txt_Home".localized()
        self.lblHome.titleLabel?.font = .kufiRegularFont(ofSize: 15)
        
        
        self.lblAllProject.text =  "All Projects".localized()
        self.lblAllProject.font = .kufiRegularFont(ofSize: 14)
        self.lblAllProject.textColor =  .white
        
        self.lblMainProjectView.text =  "txt_MainProjectView".localized()
        self.lblMainProjectView.font = .kufiRegularFont(ofSize: 13)
        self.lblMainProjectView.textColor = .white
        
        self.lblSupervision.text =  "txt_SupervisionDashboard".localized()
        self.lblSupervision.font = .kufiRegularFont(ofSize: 13)
        self.lblSupervision.textColor =  .white
        
        self.lblTitle.text = "txt_SupervisionOperationDetails".localized()
        self.lblTitle.font = .kufiRegularFont(ofSize: 14)
        
        self.mainView.setBorderGray()
        
        self.View_AllProject.setRounded(5)
        self.View_MainProjectView.setRounded(5)
        self.View_Supervision.setRounded(5)
        
        self.View_AllProject.backgroundColor = HelperClassSwift.acolor.getUIColor()
        self.View_MainProjectView.backgroundColor = HelperClassSwift.acolor.getUIColor()
        self.View_Supervision.backgroundColor = HelperClassSwift.acolor.getUIColor()
        
        self.lblMenuName.text =  self.StrMenue
        self.lblSubMenuName.text =  StrSubMenue
        let nextimage =  UIImage.fontAwesomeIcon(name: .angleRight, style: .solid, textColor: HelperClassSwift.bcolor.getUIColor(), size: CGSize(width: 40, height: 40))
        
        self.imgNext1.image = nextimage
        self.imgNext2.image = nextimage
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(GoToAllProject))
        
        lblSubMenuName.isUserInteractionEnabled = true
        lblSubMenuName.addGestureRecognizer(tapGesture)
        
        collection.delegate = self
        collection.dataSource = self
        
        collection.reloadData()
        
        ProjectName = Object?.projects_profile_name_en
        
    }
    
    
    
    
    func menu_select(){
        let language = dp_get_current_language()
        if language == "ar"{
            panel?.openRight(animated: true)
        }else{
            panel?.openLeft(animated: true)
        }
        
    }
    
    
    @objc func GoToAllProject() {
        let vc:AllPrpjectsVC = AppDelegate.mainSB.instanceVC()
        vc.MenuObj = MenuObj
        vc.StrSubMenue =  "All Projects".localized()
        vc.StrMenue = "Projects".localized()
        _ =  panel?.center(vc)
    }
    
    @objc func GoToMainProject() {
        let vc:ProjectDetailsVC = AppDelegate.mainSB.instanceVC()
        vc.MenuObj = MenuObj
        vc.StrSubMenue =  "All Projects".localized()
        vc.StrMenue = "Projects".localized()
        _ =  panel?.center(vc)
    }
    
    
    
    @IBAction func btnAllProject_Click(_ sender: Any) {
        
        let vc:AllPrpjectsVC = AppDelegate.mainSB.instanceVC()
        vc.MenuObj = MenuObj
        vc.StrSubMenue =  "All Projects".localized()
        vc.StrMenue = "Projects".localized()
        vc.MenuObj = self.MenuObj
        _ =  panel?.center(vc)
        
    }
    
    @IBAction func btnMainProject_Click(_ sender: Any) {
        
        let vc:ProjectDetailsVC = AppDelegate.mainSB.instanceVC()
        vc.MenuObj = MenuObj
        vc.StrSubMenue =  "All Projects".localized()
        vc.StrMenue = "Projects".localized()
        vc.Object = self.Object
        
        _ =  panel?.center(vc)
    }
    
    @IBAction func btnSupervision_Click(_ sender: Any) {
        
        let vc:SubProjectDetailsVC = AppDelegate.mainSB.instanceVC()
        vc.MenuObj = MenuObj
        vc.StrSubMenue =  "All Projects".localized()
        vc.StrMenue = "Projects".localized()
        vc.Object = self.Object
        
        _ =  panel?.center(vc)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChangePager",
           let destinationVC = segue.destination as? MyPageViewController {
            //  destinationVC.numberToDisplay = counter
            // destinationVC.displayPageForIndex(index: self.SelectedIndex)
            if let controller = self.parentPageViewController {
                //    controller.displayPageForIndex(index: self.SelectedIndex)
            }
        }
    }
    
}


extension SupervisionOperationVC: UICollectionViewDataSource ,UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrFormStep.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestCell", for: indexPath) as! TestCell
        
        let item = arrFormStep[indexPath.item]
        cell.lbl_Title.text = item
        cell.lbl_Title.font = .kufiRegularFont(ofSize: 13)
        cell.lbl_Title.textColor = HelperClassSwift.bcolor.getUIColor()
        cell.view_img.setBorderGrayWidth(3)
        
        if indexPath.item == SelectedIndex {
            cell.view_img.backgroundColor = HelperClassSwift.acolor.getUIColor()
        }else{
            cell.view_img.backgroundColor = HelperClassSwift.bcolor.getUIColor()
        }
        
        cell.view_img.setRounded()
        cell.img.image = UIImage.fontAwesomeIcon(code: arrIcons[indexPath.item], style: self.fontStyle, textColor: .white, size: CGSize(width: 40, height: 40))
        
        if SelectedIndex == 0{
            let indexPath = IndexPath(item: SelectedIndex, section: 0)
            self.collection.scrollToItem(at: indexPath, at: [  .left], animated: true)
        }else if SelectedIndex == 3{
            let indexPath = IndexPath(item: SelectedIndex, section: 0)
            self.collection.scrollToItem(at: indexPath, at: [  .right], animated: true)
        }
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        var newIndex = -1
        
        switch indexPath.item {
        case 0:
            newIndex = 0
        case 1:
            newIndex = 1
        case 2:
            newIndex = 2
        case 3:
            newIndex = 3
        default: break
        }
        
        

        
        self.SelectedIndex = indexPath.item
        
        self.collection.reloadData()
        self.change_page()
    }
    
    private func change_page() {
        NotificationCenter.default.post(name: NSNotification.Name("Change_Page"), object: SelectedIndex)
    }
}
