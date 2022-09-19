//
//  GmailViewController.swift
//  Almnabr
//
//  Created by Hany Alkahlout on 14/09/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import UIKit
import GoogleSignInSwift
import GoogleSignIn
class GmailViewController: UIViewController {


    @IBOutlet weak var header: HeaderView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        header.btnAction = menu_select
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func menu_select(){
        let language =  L102Language.currentAppleLanguage()
        if language == "ar"{
            panel?.openRight(animated: true)
        }else{
            panel?.openLeft(animated: true)
        }
        
    }
    
    
    
}
