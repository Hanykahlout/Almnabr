//
//  ViewEmployeePageVC.swift
//  Almnabr
//
//  Created by Hany Alkahlout on 13/06/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import UIKit

class ViewEmployeePageVC: UIPageViewController {
    
    private var containerVCs = [UIViewController]()
    var empID = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        let idDetailsVC = ViewEmpIDDetailsVC()
        let contractDetailsVC = ViewEmpContractDetailsVC()
        contractDetailsVC.id = empID
        let joiningDetailsVC = ViewEmpJoiningDetailsVC()
        let jobDetailsVC = ViewEmpJobDetailsVC()
        let communicationsVC = ViewEmpCommunicationsVC()
        let contactDetailsVC = ViewEmpContactDetailsVC()
        let bankDetailsVC = ViewEmpBankDetailsVC()
        let educationDetailsVC = ViewEmpEducationDetailsVC()
        let passportDetailsVC = ViewEmpPassportDetailsVC()
        let insuranceDetailsVC = ViewEmpInsuranceDetailsVC()
        let langVacationsVC = ViewEmpLangVacationsVC()
        let notesVC = ViewEmpNotesVC()
        let attachmentsVC = ViewEmpAttachmentsVC()
        let modulesVC = ViewEmpModulesVC()
        let langFinanialDetailsVC = ViewEmpLangFinanialDetailsVC()
        let langCalenderVC = ViewLangCalenderVC()
        containerVCs.append(idDetailsVC)
        containerVCs.append(contractDetailsVC)
        containerVCs.append(joiningDetailsVC)
        containerVCs.append(jobDetailsVC)
        containerVCs.append(communicationsVC)
        containerVCs.append(contactDetailsVC)
        containerVCs.append(bankDetailsVC)
        containerVCs.append(educationDetailsVC)
        containerVCs.append(passportDetailsVC)
        containerVCs.append(insuranceDetailsVC)
        containerVCs.append(langVacationsVC)
        containerVCs.append(notesVC)
        containerVCs.append(attachmentsVC)
        containerVCs.append(modulesVC)
        containerVCs.append(langFinanialDetailsVC)
        containerVCs.append(langCalenderVC)

        if let firstVC = containerVCs.first{
            setViewControllers([firstVC], direction: .forward, animated: true)
        }
    }

    
    func changeVC(index:Int,direction:UIPageViewController.NavigationDirection){
        setViewControllers([containerVCs[index]], direction: direction, animated: true)
    }

}
