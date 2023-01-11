//
//  AddCostCenterViewController.swift
//  Almnabr
//
//  Created by Hany Alkahlout on 08/01/2023.
//  Copyright © 2023 Samar Akkila. All rights reserved.
//

import UIKit
import DropDown
import SCLAlertView
class AddCostCenterViewController: UIViewController {

    
    @IBOutlet weak var addRootTextField: UITextField!
    @IBOutlet weak var addRootArrow: UIImageView!
    @IBOutlet weak var costCenterIDTextField: UITextField!
    @IBOutlet weak var costCenterCodeTextField: UITextField!
    @IBOutlet weak var titleEnTextField: UITextField!
    @IBOutlet weak var titleArTextField: UITextField!
    @IBOutlet weak var supportAccountTextField: UITextField!
    @IBOutlet weak var supportAccountArrow: UIImageView!
    
    private let addRootDropDown = DropDown()
    private let supportAccountDropDown = DropDown()
    var branch_id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
    }

    
    private func initialization(){
        setUpDropDown()
    }
    
    
    private func setUpDropDown(){
        //  addRootDropDown

        addRootDropDown.anchorView = addRootTextField
        addRootDropDown.bottomOffset = CGPoint(x: 0, y:(addRootDropDown.anchorView?.plainView.bounds.height)!)
        addRootDropDown.dataSource = ["Yes","No"]
        addRootDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            addRootArrow.transform = .init(rotationAngle: 0)
            self.addRootTextField.text = item
        }
        
        addRootDropDown.cancelAction = { [unowned self] in
            addRootArrow.transform = .init(rotationAngle: .pi)
        }
        
        addRootTextField.addTapGesture {
            self.addRootArrow.transform = .init(rotationAngle: .pi)
            self.addRootDropDown.show()
        }
        
        
        //  supportAccountDropDown

        supportAccountDropDown.anchorView = supportAccountTextField
        supportAccountDropDown.bottomOffset = CGPoint(x: 0, y:(supportAccountDropDown.anchorView?.plainView.bounds.height)!)
        supportAccountDropDown.dataSource = ["Yes","No"]
        supportAccountDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            supportAccountArrow.transform = .init(rotationAngle: 0)
            self.supportAccountTextField.text = item
        }
        
        supportAccountDropDown.cancelAction = { [unowned self] in
            supportAccountArrow.transform = .init(rotationAngle: .pi)
        }
        
        supportAccountTextField.addTapGesture {
            self.supportAccountArrow.transform = .init(rotationAngle: .pi)
            self.supportAccountDropDown.show()
        }

    }
    

    @IBAction func closeAction(_ sender: Any) {
        navigationController?.dismiss(animated: true)
    }
    
    @IBAction func submitAction(_ sender: Any) {
        addCostCenter()
    }
    
    

}
// MARK: - API Handling
extension AddCostCenterViewController{
    private func addCostCenter(){
    let body = ["branch_id": branch_id,
                "cost_center_root": addRootTextField.text! == "Yes" ? "1" : "0",
                "cost_center_id": costCenterIDTextField.text!,
                "cost_center_code": costCenterCodeTextField.text!,
                "cost_center_name_en": titleEnTextField.text!,
                "cost_center_name_ar": titleArTextField.text!,
                "cost_center_sub": supportAccountTextField.text! == "Yes" ? "1" : "0"
        ]
        APIController.shard.addCostCenters(body: body) { data in
            if let status = data.status,status{
                SCLAlertView().showSuccess("Success".localized(), subTitle: data.msg ?? "")
                self.navigationController?.dismiss(animated: true)
                NotificationCenter.default.post(name: .init("ReloadCostCenters"), object: nil)
            }else{
                SCLAlertView().showError("error".localized(), subTitle: data.error ?? "")
            }
        }
    }
}
