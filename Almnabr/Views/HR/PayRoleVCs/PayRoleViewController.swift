//
//  PayRoleViewController.swift
//  Almnabr
//
//  Created by Hany Alkahlout on 22/11/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import UIKit

class PayRoleViewController: UIViewController {

    @IBOutlet weak var headerView: HeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.btnAction = menu_select
        // Do any additional setup after loading the view.
    }

    
    private func menu_select(){
        let language =  L102Language.currentAppleLanguage()
        if language == "ar"{
            panel?.openRight(animated: true)
        }else{
            panel?.openLeft(animated: true)
        }
    }
    
    
    
}
