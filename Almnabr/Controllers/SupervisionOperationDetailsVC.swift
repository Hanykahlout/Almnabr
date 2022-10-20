//
//  SupervisionOperationDetailsVC.swift
//  Almnabr
//
//  Created by MacBook on 04/03/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import UIKit


class SupervisionOperationDetailsVC: UIViewController {

    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var collection: UICollectionView!
     
    
    @IBOutlet weak var header: HeaderView!
    
    var parentPageViewController: MyPageViewController!
    
    var SelectedIndex:Int = 0
    var MenuObj:MenuObj?
    
    
    
    var index = 0
    var identifiers: NSArray = ["FromTransactionVC", "TeamUserVC","ContactsVC","DocumentsVC"]
    
    var Object:projectObj?
    var arrFormStep:[String] = ["Form Transaction".localized(),"Team Users".localized(),"Contacts".localized(),"Documents".localized()]
    var arrIcons:[String] = ["fa-id-card","fa-users","fa-mobile","fa-copy"]
    
    var arr_view :[UIViewController] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configGUI()
      //  header.btnAction = menu_select
       
        
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
        
//        addNavigationBarTitle(navigationTitle: StrTitle)
    }
    
    
    //MARK: - Config GUI
    //------------------------------------------------------
    func configGUI() {
       
//        self.lblTitle.text = "txt_SupervisionOperationDetails".localized()
//        self.lblTitle.font = .kufiRegularFont(ofSize: 14)
        
        
        collection.delegate = self
        collection.dataSource = self
        
        collection.reloadData()
        
        ProjectName = Object?.projects_profile_name_en
        
         
    }
    
    
    
    
    func menu_select(){
        let language =  L102Language.currentAppleLanguage()
        if language == "ar"{
            panel?.openRight(animated: true)
        }else{
            panel?.openLeft(animated: true)
        }
        
    }
    

    
    
    
    @IBAction func btnProjectRequest_Click(_ sender: Any) {
        let shared = NotifiRoute()
        guard let top_vc = shared.menu_vc() else { return }
        let vc: ProjectRequestVC = AppDelegate.mainSB.instanceVC()
        top_vc.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ChangePager",
//           let destinationVC = segue.destination as? MyPageViewController {
//            if let controller = self.parentPageViewController {
//
//            }
//        }
    }
    
    
}

extension SupervisionOperationDetailsVC: UICollectionViewDataSource ,UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrFormStep.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestCell", for: indexPath) as! TestCell
        
        let item = arrFormStep[indexPath.item]
        cell.lbl_Title.text = item
        cell.lbl_Title.font = .kufiRegularFont(ofSize: 13)
        cell.lbl_Title.textColor = maincolor
        cell.view_img.setBorderGrayWidth(3)
        
        if indexPath.item == SelectedIndex {
            cell.view_img.backgroundColor = maincolor
        }else{
            cell.view_img.backgroundColor = HelperClassSwift.bcolor.getUIColor()
        }
        
        cell.view_img.setRounded()
        cell.img.image = UIImage.fontAwesomeIcon(code: arrIcons[indexPath.item], style: .solid, textColor: .white, size: CGSize(width: 40, height: 40))
        
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
