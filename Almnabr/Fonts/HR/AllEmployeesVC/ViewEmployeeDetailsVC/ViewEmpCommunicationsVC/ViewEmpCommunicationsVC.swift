//
//  ViewEmpCommunicationsVC.swift
//  Almnabr
//
//  Created by Hany Alkahlout on 12/06/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import UIKit
import DropDown

class ViewEmpCommunicationsVC: UIViewController {
    
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var filterArrow: UIImageView!
    @IBOutlet weak var seachTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    private var addDropDown = DropDown()
    private var filterDropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
        // Do any additional setup after loading the view.
    }
    
    private func initlization(){
        setUpDropDownLists()
    }
    
    private func setUpDropDownLists(){
        // ADD Drop Down
        addDropDown.anchorView = addButton
        
        addDropDown.bottomOffset = CGPoint(x: 0, y:(addDropDown.anchorView?.plainView.bounds.height)!)
        
        addDropDown.dataSource = ["lang_incoming","lang_outgoing"]
        addDropDown.selectionAction = { (index: Int, item: String) in
            
            let vc = OutgoingVC()
            vc.isIncoming = index == 0
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        // Filter Drop Down
        filterDropDown.anchorView = filterView
        
        filterDropDown.bottomOffset = CGPoint(x: 0, y:(filterDropDown.anchorView?.plainView.bounds.height)!)
        filterDropDown.dataSource = ["Incoming","Outgoing"]
        filterLabel.text = "Outgoing"
        filterDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.filterArrow.transform = .init(rotationAngle: 0)
            self.filterLabel.text = item
            
        }
        
        filterDropDown.cancelAction = { [unowned self] in
            self.filterArrow.transform = .init(rotationAngle: 0)
        }
        filterView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(filterViewAction)))
    }
    
    @objc private func filterViewAction(){
        self.filterArrow.transform = .init(rotationAngle: .pi)
        filterDropDown.show()
    }
    
    
    @IBAction func addAction(_ sender: Any) {
        addDropDown.show()
    }
    
}
