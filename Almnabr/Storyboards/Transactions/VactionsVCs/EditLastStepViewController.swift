//
//  EditLastStepViewController.swift
//  Almnabr
//
//  Created by Hany Alkahlout on 25/07/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import UIKit
import DropDown
import SCLAlertView
class EditLastStepViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var arrowImageVeiw: UIImageView!
    private var dropDown = DropDown()
    private var resultData = [SearchBranchRecords]()
    private var selectedUser:SearchBranchRecords?
    var transactionRequestId:String?
    var isVaction = false
    override func viewDidLoad() {
        super.viewDidLoad()

        initlization()
    }
    
    private func initlization(){
        setUpDropDwonlist()
    }
    
    private func setUpDropDwonlist(){
        
        dropDown.anchorView = nameTextField
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            arrowImageVeiw.transform = .init(rotationAngle: 0)
            if !resultData.isEmpty{
                self.nameTextField.text = ""
                self.nameTextField.placeholder = item
                selectedUser = resultData[index]
            }
        }
        
        dropDown.cancelAction = { [unowned self] in
            arrowImageVeiw.transform = .init(rotationAngle: 0)
        }
            
        nameTextField.addTarget(self, action: #selector(editTextFieldAction), for: .editingChanged)
    }
    
    
    
    @objc private func editTextFieldAction(){
        searchForUser()
        
    }
    


    @IBAction func submitAction(_ sender: Any) {
        if let _ = selectedUser{
            submitUser()
        }else{
            SCLAlertView().showError("error".localized(), subTitle: "You have to choose user")
        }
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        navigationController?.dismiss(animated: true)
    }
    
}

// MARK: - API Handling

extension EditLastStepViewController{

    private func searchForUser(){
        APIController.shard.searchForUser(searchText: nameTextField.text!, lang: L102Language.currentAppleLanguage(), id: "1") { data in
            if let status = data.status, status{
                let list = data.list ?? []
                self.resultData = list
                self.dropDown.dataSource = list.map{$0.label ?? ""}
            }else{
                self.resultData.removeAll()
                self.dropDown.dataSource.removeAll()
                self.dropDown.dataSource.append(data.error ?? "")
            }
            self.dropDown.show()
        }
    }
    
    private func submitUser(){
        
        if let selectedUser = selectedUser, let transactionRequestId = transactionRequestId{
            showLoadingActivity()
            APIController.shard.editUserStep(formType: isVaction ? "FORM_HRV1" : "FORM_CT1" ,user_id: selectedUser.value ?? "", transaction_request_id: transactionRequestId) {
                data in
                DispatchQueue.main.async {
                    self.hideLoadingActivity()
                    if let status = data.status,status{
                        SCLAlertView().showSuccess("Success".localized(), subTitle: data.msg ?? "")
                        if self.isVaction { NotificationCenter.default.post(name: .init("ReloadVactionData"), object: nil) }
                        self.navigationController?.dismiss(animated: true)
                    }else{
                        SCLAlertView().showError("error".localized(), subTitle: data.error ?? "There is an unknow error...")
                    }
                }
                
            }
        }
    }
    
    
}


