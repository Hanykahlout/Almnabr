//
//  NotesCell.swift
//  Almnabr
//
//  Created by MacBook on 16/12/2021.
//  Copyright © 2021 Samar Akkila. All rights reserved.
//

import UIKit

class NotesCell: UITableViewCell {

    @IBOutlet weak var lbl_No: UILabel!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Result: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
