//
//  CornTransactionTVCell.swift
//  Almnabr
//
//  Created by MacBook on 05/10/2021.
//  Copyright © 2021 Samar Akkila. All rights reserved.
//

import UIKit

class CornTransactionTVCell: UITableViewCell {

    
    @IBOutlet weak var lblNo: UILabel!
    @IBOutlet weak var lblFormName: UILabel!
    @IBOutlet weak var lblAttempt: UILabel!
    @IBOutlet weak var lblLastUpdate: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
