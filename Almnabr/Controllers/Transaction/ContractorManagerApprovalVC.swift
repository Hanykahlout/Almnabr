//
//  ContractorManagerApprovalVC.swift
//  Almnabr
//
//  Created by MacBook on 07/12/2021.
//  Copyright © 2021 Samar Akkila. All rights reserved.
//

import UIKit

class ContractorManagerApprovalVC: UIViewController {

    @IBOutlet weak var icon_noPermission: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        icon_noPermission.loadGif(name: "no-permission")
        
        
    }
    


}
