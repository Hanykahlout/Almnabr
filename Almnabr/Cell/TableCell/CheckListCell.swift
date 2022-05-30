//
//  CheckListCell.swift
//  Almnabr
//
//  Created by MacBook on 14/05/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import UIKit

class CheckListCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPercent: UILabel!
    @IBOutlet weak var Progress: UIProgressView!
    @IBOutlet weak var viewBack: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        
        viewBack.layer.shadowColor = UIColor.systemGray.cgColor
        viewBack.layer.shadowOpacity = 0.5
        viewBack.layer.shadowOffset = .zero
        viewBack.layer.shadowRadius = 4
        viewBack.layer.cornerRadius = 10
        
        //Progress.progress = 0.0
       // self.Progress.progress = 100.0
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
