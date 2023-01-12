//
//  AddAccountMastersViewController.swift
//  Almnabr
//
//  Created by Hany Alkahlout on 12/01/2023.
//  Copyright © 2023 Samar Akkila. All rights reserved.
//

import UIKit
import DropDown
class AddAccountMastersViewController: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var titleEnTextField: UITextField!
    @IBOutlet weak var titleArTextField: UITextField!
    
    @IBOutlet weak var currenciesTextField: UITextField!
    @IBOutlet weak var currenciesArrow: UIImageView!
    
    @IBOutlet weak var accountTypeTextField: UITextField!
    @IBOutlet weak var accountTypeArrow: UIImageView!
    
    @IBOutlet weak var balanceSheetGroupTextField: UITextField!
    
    @IBOutlet weak var supportSubAccountTextField: UITextField!
    @IBOutlet weak var supportSubAccountArrow: UIImageView!
    
    @IBOutlet weak var VATNumberTextField: UITextField!
    
    
    @IBOutlet weak var costCenterSupportTextField: UITextField!
    @IBOutlet weak var costCenterSupportArrow: UIImageView!
    
    @IBOutlet weak var holdAccountSelectionStackView: UIStackView!
    @IBOutlet weak var holdAccountSelectionButton: UIButton!
    
    @IBOutlet weak var profitLossAccountSelectionStackView: UIStackView!
    @IBOutlet weak var profitLossAccountSelectionButton: UIButton!
    
    private let currenciesDropDown = DropDown()
    private let accountTypeDropDown = DropDown()
    private let balanceSheetGroupDropDown = DropDown()
    private let supportSubAccountDropDown = DropDown()
    private let costCenterSupportDropDown = DropDown()
    
    private var currencies = [SearchBranchRecords]()
    private var accountTypes = [AccountTypesRecord]()
    
    var data: AccountMastersRecord?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
        // Do any additional setup after loading the view.
    }
    
    
    private func initialization(){
        setUpDropDownLists()
        setUpCheckBoxs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCurrencies()
        getAccountType()
    }
    
    
    private func setUpCheckBoxs(){
        holdAccountSelectionStackView.isUserInteractionEnabled = true
        profitLossAccountSelectionStackView.isUserInteractionEnabled = true
        holdAccountSelectionStackView.addTapGesture { [weak self] in
            self?.holdAccountSelectionButton.isSelected = !(self?.holdAccountSelectionButton.isSelected ?? true)
        }
        
        profitLossAccountSelectionStackView.addTapGesture { [weak self] in
            self?.profitLossAccountSelectionButton.isSelected = !(self?.profitLossAccountSelectionButton.isSelected ?? true)
        }
    }
    
    
    private func setUpDropDownLists(){
        
        //  currenciesDropDown
        
        currenciesDropDown.anchorView = currenciesTextField
        currenciesDropDown.bottomOffset = CGPoint(x: 0, y:(currenciesDropDown.anchorView?.plainView.bounds.height)!)
        currenciesDropDown.dataSource = ["Yes","No"]
        currenciesDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            currenciesArrow.transform = .init(rotationAngle: 0)
            self.currenciesTextField.text = item
        }
        
        currenciesDropDown.cancelAction = { [unowned self] in
            currenciesArrow.transform = .init(rotationAngle: .pi)
        }
        
        currenciesTextField.addTapGesture {
            self.currenciesArrow.transform = .init(rotationAngle: .pi)
            self.currenciesDropDown.show()
        }
        
        //  accountTypeDropDown
        
        accountTypeDropDown.anchorView = accountTypeTextField
        accountTypeDropDown.bottomOffset = CGPoint(x: 0, y:(accountTypeDropDown.anchorView?.plainView.bounds.height)!)
        accountTypeDropDown.dataSource = ["Yes","No"]
        accountTypeDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            accountTypeArrow.transform = .init(rotationAngle: 0)
            self.accountTypeTextField.text = item
        }
        
        accountTypeDropDown.cancelAction = { [unowned self] in
            accountTypeArrow.transform = .init(rotationAngle: .pi)
        }
        
        accountTypeTextField.addTapGesture {
            self.accountTypeArrow.transform = .init(rotationAngle: .pi)
            self.accountTypeDropDown.show()
        }
        
        //  balanceSheetGroupDropDown
        
        balanceSheetGroupDropDown.anchorView = balanceSheetGroupTextField
        balanceSheetGroupDropDown.bottomOffset = CGPoint(x: 0, y:(balanceSheetGroupDropDown.anchorView?.plainView.bounds.height)!)
        balanceSheetGroupDropDown.dataSource = ["Yes","No"]
        balanceSheetGroupDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            accountTypeArrow.transform = .init(rotationAngle: 0)
            self.balanceSheetGroupTextField.text = item
        }
        
        balanceSheetGroupDropDown.cancelAction = { [unowned self] in
            accountTypeArrow.transform = .init(rotationAngle: .pi)
        }
        
        balanceSheetGroupTextField.addTapGesture {
            self.accountTypeArrow.transform = .init(rotationAngle: .pi)
            self.balanceSheetGroupDropDown.show()
        }
        
        
        //  supportSubAccountDropDown
        
        supportSubAccountDropDown.anchorView = supportSubAccountTextField
        supportSubAccountDropDown.bottomOffset = CGPoint(x: 0, y:(supportSubAccountDropDown.anchorView?.plainView.bounds.height)!)
        supportSubAccountDropDown.dataSource = ["Yes","No"]
        supportSubAccountDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            supportSubAccountArrow.transform = .init(rotationAngle: 0)
            self.supportSubAccountTextField.text = item
        }
        
        supportSubAccountDropDown.cancelAction = { [unowned self] in
            supportSubAccountArrow.transform = .init(rotationAngle: .pi)
        }
        
        supportSubAccountTextField.addTapGesture {
            self.supportSubAccountArrow.transform = .init(rotationAngle: .pi)
            self.supportSubAccountDropDown.show()
        }
        
        
        //  costCenterSupportDropDown
        
        costCenterSupportDropDown.anchorView = costCenterSupportTextField
        costCenterSupportDropDown.bottomOffset = CGPoint(x: 0, y:(costCenterSupportDropDown.anchorView?.plainView.bounds.height)!)
        costCenterSupportDropDown.dataSource = ["Yes","No"]
        costCenterSupportDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            costCenterSupportArrow.transform = .init(rotationAngle: 0)
            self.costCenterSupportTextField.text = item
        }
        
        costCenterSupportDropDown.cancelAction = { [unowned self] in
            costCenterSupportArrow.transform = .init(rotationAngle: .pi)
        }
        
        costCenterSupportTextField.addTapGesture {
            self.costCenterSupportArrow.transform = .init(rotationAngle: .pi)
            self.costCenterSupportDropDown.show()
        }
        
    }
    
    @IBAction func submitAction(_ sender: Any) {
    }
    
    
    
    @IBAction func closeAction(_ sender: Any) {
        navigationController?.dismiss(animated: true)
    }
    
    
}

// MARK: - API Handling
extension AddAccountMastersViewController{
    private func getCurrencies(){
        APIController.shard.getCurrencies(branch_id: data?.branch_id ?? "") { [weak self] data in
            DispatchQueue.main.async { [weak self] in
                if let status = data.status,status{
                    self?.currencies = data.records ?? []
                    self?.currenciesDropDown.dataSource = ["Choose Options"]
                    self?.currenciesDropDown.dataSource.append(contentsOf: (data.records ?? []).map{$0.label ?? ""})
                }
            }
        }
    }
    
    private func getAccountType(){
        APIController.shard.getAccountTypes(branch_id: data?.branch_id ?? "") { data in
            DispatchQueue.main.async { [weak self] in
                if let status = data.status,status{
                    self?.accountTypes = data.records ?? []
                    self?.accountTypeDropDown.dataSource = ["Choose Options"]
                    self?.accountTypeDropDown.dataSource.append(contentsOf: (data.records ?? []).map{$0.label ?? ""})
                }
            }
        }
    }
    
}
