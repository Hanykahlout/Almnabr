//
//  TransactionFormPageaVC.swift
//  Almnabr
//
//  Created by MacBook on 07/12/2021.
//  Copyright © 2021 Samar Akkila. All rights reserved.
//

import UIKit

class TransactionFormPageaVC: UIPageViewController {
    
    
    var pages = [UIViewController]()
    var newIndex = 1
    
    private var currentPageIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
//    Authorized_Positions_Approval: false
//    Configurations: true
//    Contractor_Manager_Approval: false
//    Contractor_Team_Approval: false
//    Evaluation_Result: false
//    Final_Result: false
//    Manager_Approval: false
//    Owners_Representative: false
//    Recipient_Verification: false
//    Special_Approval: false
//    Techinical_Assistant: false
        
        let page1: LanguageVC = AppDelegate.mainSB.instanceVC()
        let page2: ContractorManagerApprovalVC = AppDelegate.TransactionSB.instanceVC()
        let page3: ContractorTeamApprovalVC = AppDelegate.TransactionSB.instanceVC()
        let page4: EvaluationResultVC = AppDelegate.TransactionSB.instanceVC()
        let page5: FinalResultVC = AppDelegate.TransactionSB.instanceVC()
        let page6: ManagerApprovalVC = AppDelegate.TransactionSB.instanceVC()
        let page7: OwnersRepresentativeVC = AppDelegate.TransactionSB.instanceVC()
        let page8: RecipientVerificationVC = AppDelegate.TransactionSB.instanceVC()
        let page9: SpecialApprovalVC = AppDelegate.TransactionSB.instanceVC()
        let page10: TechinicalAssistantVC = AppDelegate.TransactionSB.instanceVC()
       // let page11: TransactionFormDetailsVC = AppDelegate.TransactionSB.instanceVC()
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        pages.append(page4)
        pages.append(page5)
        pages.append(page6)
        pages.append(page7)
        pages.append(page8)
        pages.append(page9)
        pages.append(page10)
        
        setViewControllers([page1], direction: .forward, animated: false, completion: nil)
        
        pager_observer()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // self.displayPageForIndex(index: index)
         displayPageForIndex(index: newIndex, animated: true)
    }
    
    
    private func pager_observer(){
        NotificationCenter.default.addObserver(forName: NSNotification.Name("Change_Form_Step"), object: nil, queue: .main) { notifi in
            guard let index = notifi.object as? Int else { return }
            self.displayPageForIndex(index: index)
        }
    }
    
    func displayPageForIndex(index: Int, animated: Bool = true) {
        assert(index >= 0 && index < self.pages.count, "Error: Attempting to display a page for an out of bounds index")
        
        
        // nop if index == self.currentPageIndex
        if self.currentPageIndex == index { return }
        
        if index < self.currentPageIndex {
            self.setViewControllers([self.pages[index]], direction: .reverse, animated: true, completion: nil)
        } else if index > self.currentPageIndex {
            self.setViewControllers([self.pages[index]], direction: .forward, animated: true, completion: nil)
        }
        
        self.currentPageIndex = index
    }
}


extension TransactionFormPageaVC: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let currentIndex = pages.index(of: viewController)!
        
        // This version will not allow pages to wrap around
        guard currentIndex > 0 else {
            return nil
        }
        
        return pages[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let currentIndex = pages.index(of: viewController)!
        
        // This version will not allow pages to wrap around
        guard currentIndex < pages.count - 1 else {
            return nil
        }
        
        return pages[currentIndex + 1]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 10
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
