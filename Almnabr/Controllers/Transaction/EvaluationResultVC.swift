//
//  EvaluationResultVC.swift
//  Almnabr
//
//  Created by MacBook on 07/12/2021.
//  Copyright © 2021 Samar Akkila. All rights reserved.
//

import UIKit

class EvaluationResultVC: UIViewController {
    @IBOutlet weak var icon_noPermission: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        icon_noPermission.loadGif(name: "no-permission")
        
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
