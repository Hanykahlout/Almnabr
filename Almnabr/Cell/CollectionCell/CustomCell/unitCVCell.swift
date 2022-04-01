//
//  unitCVCell.swift
//  Almnabr
//
//  Created by MacBook on 03/03/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import UIKit

class unitCVCell: UICollectionViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewBack: UIView!
    
    
    var btnDeleteAction : (()->())?
    
    
    @IBAction func didReCancelButtonPressd(_ sender: Any) {
        btnDeleteAction!()
    }
    
    
}
