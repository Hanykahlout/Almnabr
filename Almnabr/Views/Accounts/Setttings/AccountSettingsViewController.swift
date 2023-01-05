//
//  AccountSettingsViewController.swift
//  Almnabr
//
//  Created by Hany Alkahlout on 03/01/2023.
//  Copyright © 2023 Samar Akkila. All rights reserved.
//

import UIKit
import DropDown
import SCLAlertView
class AccountSettingsViewController: UIViewController {

    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var optionsTextrField: UITextField!
    @IBOutlet weak var optionsArrow: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainStackView: UIStackView!
    
    @IBOutlet weak var financialYearTextField: UITextField!
    
    @IBOutlet weak var financialYearArrow: UIImageView!
    @IBOutlet weak var financialYearView: UIView!
    
    
    private let optionsDropDown = DropDown()
    private var options = [AccountOptionsRecord]()
    private var pageController: AccountSettingsPageViewController!
    private var data = [SectionInfo]()
    private var selectedIndex = 0
    static var branch_id = ""
    static var finance_id = ""
    
    private var financialYearDropDown = DropDown()
    private var financialYears = [AccountFinancialRecord]()
    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getOptions()
    }
    
    
    private func initialization(){
        handleHeaderView()
        setUpDropDown()
        setUpPageCotroller()
        setCollectionData()
        setUpCollectionView()
    }
    
    private func setUpPageCotroller(){
        pageController = AccountSettingsPageViewController()
        
        addChild(pageController)
        pageController.didMove(toParent: self)
        
        pageController.view.translatesAutoresizingMaskIntoConstraints = false
        
        mainView.addSubview(pageController.view)

        mainView.leadingAnchor.constraint(equalTo: pageController.view.leadingAnchor, constant: 0).isActive = true
        mainView.trailingAnchor.constraint(equalTo: pageController.view.trailingAnchor, constant: 0).isActive = true
        mainView.topAnchor.constraint(equalTo: pageController.view.topAnchor, constant: 0).isActive = true
        mainView.bottomAnchor.constraint(equalTo: pageController.view.bottomAnchor, constant: 0).isActive = true
    }
    
    
    private func setCollectionData(){

        data.append(.init(bgColor: UIColor(named: "AppColor")!, icon: UIImage(systemName: "person.3.fill")!, title: "Permission Mentions".localized()))
        data.append(.init(bgColor: UIColor.black, icon: UIImage(systemName: "gear.badge")!, title: "Accounts Settings".localized()))
        
        data.append(.init(bgColor: UIColor.black, icon: UIImage(systemName: "percent")!, title: "Tax".localized()))
        
        data.append(.init(bgColor: UIColor.black, icon: UIImage(systemName: "gearshape.fill")!, title: "Invoice Settings".localized()))
        
        data.append(.init(bgColor: UIColor.black, icon: UIImage(systemName: "dollarsign.circle.fill")!, title: "Financial Years".localized()))
        
        data.append(.init(bgColor: UIColor.black, icon: UIImage(systemName: "shareplay.slash")!, title: "Block Accounts".localized()))
        
    }

    private func setUpDropDown(){
        //        optionsDropDown
        optionsDropDown.anchorView = optionsTextrField
        optionsDropDown.bottomOffset = CGPoint(x: 0, y:(optionsDropDown.anchorView?.plainView.bounds.height)!)
        
        optionsDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            optionsArrow.transform = .init(rotationAngle: 0)
            if index == 0{
                self.optionsTextrField.text = item
                AccountSettingsViewController.branch_id = ""
                mainStackView.isHidden = true
                financialYearView.isHidden = true
            }else{
                let objc = options[index - 1]
                AccountSettingsViewController.branch_id = objc.id ?? ""
                self.optionsTextrField.text = objc.title ?? ""
                mainStackView.isHidden = false
                financialYearView.isHidden = false
                getAccountFinancialOptions()
            }
            NotificationCenter.default.post(name: .init("ReloadPermissionMentions"), object: nil)
            NotificationCenter.default.post(name: .init("ReloadAccountsSettings"), object: nil)
            NotificationCenter.default.post(name: .init("ReloadAccountTax"), object: nil)
            NotificationCenter.default.post(name: .init("ReloadInvoiceSettings"), object: nil)
            NotificationCenter.default.post(name: .init("ReloadFinancialYears"), object: nil)
            NotificationCenter.default.post(name: .init("ReloadBlockAccounts"), object: nil)
            
        }
        
        optionsDropDown.cancelAction = { [unowned self] in
            optionsArrow.transform = .init(rotationAngle: .pi)
        }
        
        optionsTextrField.addTapGesture {
            self.optionsArrow.transform = .init(rotationAngle: .pi)
            self.optionsDropDown.show()
        }
        
        // financialYearDropDown
        financialYearDropDown.anchorView = financialYearTextField
        financialYearDropDown.bottomOffset = CGPoint(x: 0, y:(financialYearDropDown.anchorView?.plainView.bounds.height)!)
        
        financialYearDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            financialYearArrow.transform = .init(rotationAngle: 0)
            
            if index == 0{
                self.financialYearTextField.text = item
                AccountSettingsViewController.finance_id = ""
            }else{
                let objc = financialYears[index - 1]
                AccountSettingsViewController.finance_id = objc.value ?? ""
                self.financialYearTextField.text = objc.label ?? ""
            }
            
//            NotificationCenter.default.post(name: .init("ReloadPermissionMentions"), object: nil)
//            NotificationCenter.default.post(name: .init("ReloadAccountsSettings"), object: nil)
            NotificationCenter.default.post(name: .init("ReloadAccountTax"), object: nil)
            NotificationCenter.default.post(name: .init("ReloadInvoiceSettings"), object: nil)
            NotificationCenter.default.post(name: .init("ReloadFinancialYears"), object: nil)
            NotificationCenter.default.post(name: .init("ReloadBlockAccounts"), object: nil)
            
        }
        
        financialYearDropDown.cancelAction = { [unowned self] in
            financialYearArrow.transform = .init(rotationAngle: .pi)
        }
        
        financialYearTextField.addTapGesture {
            self.financialYearArrow.transform = .init(rotationAngle: .pi)
            self.financialYearDropDown.show()
        }
        
    }

    private func handleHeaderView(){
        headerView.btnAction = {
            let language =  L102Language.currentAppleLanguage()
            if language == "ar"{
                self.panel?.openRight(animated: true)
            }else{
                self.panel?.openLeft(animated: true)
            }
        }
    }

}

extension AccountSettingsViewController:UICollectionViewDelegate , UICollectionViewDataSource{
    private func setUpCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(.init(nibName: "SectionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SectionCollectionViewCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionCollectionViewCell", for: indexPath) as! SectionCollectionViewCell
        cell.setData(data: data[indexPath.row])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        goToSelectedCell(indexPath: indexPath)
        selectedIndex = indexPath.row
        pageController.displayPageForIndex(index: selectedIndex,animated: true)
    }
    
    
    private func goToSelectedCell(indexPath:IndexPath){
        for index in 0..<data.count{
            if index == indexPath.row{
                data[index].bgColor = UIColor(named: "AppColor")!
            }else{
                data[index].bgColor = UIColor.black
            }
        }
        
        collectionView.reloadData()
        collectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally], animated: false)
    }
    
    
}


// MARK: - API Handling
extension AccountSettingsViewController{
    private func getOptions(){
        APIController.shard.getAccountSettingsOptions { data in
            if let status = data.status,status{
                let apiOptions = data.records ?? []
                self.options = apiOptions
                self.optionsDropDown.dataSource.append("Choose Option")
                self.optionsDropDown.dataSource.append(contentsOf: apiOptions.map{$0.title ?? ""})
            }else{
                SCLAlertView().showError("error".localized(), subTitle: data.error ?? "There is an unknow error!!")
            }
        }
    }
    
    
    private func getAccountFinancialOptions(){
        APIController.shard.getAccountFinancialOptions(branch_id: AccountSettingsViewController.branch_id) { data in
            DispatchQueue.main.async{
                if let status = data.status,status{
                    let records = data.records ?? []
                    self.financialYears = records
                    self.financialYearDropDown.dataSource = ["Financial Year"]
                    self.financialYearDropDown.dataSource.append(contentsOf: self.financialYears.map{$0.label ?? ""})
                }
            }
        }
    }
    
    
}
