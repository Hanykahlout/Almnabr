//
//  CostCenterTableViewCell.swift
//  Almnabr
//
//  Created by Hany Alkahlout on 08/01/2023.
//  Copyright © 2023 Samar Akkila. All rights reserved.
//

import UIKit

class CostCenterTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var branchLabel: UILabel!
    @IBOutlet weak var costCenterCodeLabel: UILabel!
    @IBOutlet weak var titleEnglishLabel: UILabel!
    @IBOutlet weak var titleArabicLabel: UILabel!
    @IBOutlet weak var supportSubAccountLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var writerLabel: UILabel!
    
    func setData(data:CostCentersRecord){
        nameLabel.text = data.name ?? "----"
        branchLabel.text = data.branch_name ?? "----"
        costCenterCodeLabel.text = data.cost_center_code ?? "----"
        titleEnglishLabel.text = data.cost_center_name_en ?? "----"
        titleArabicLabel.text = data.cost_center_name_ar ?? "----"
        supportSubAccountLabel.text = data.cost_center_sub ?? "" == "1" ? "Yes" : "No"
        createdDateLabel.text = data.cost_center_created_datetime ?? "----"
        writerLabel.text = data.writer_name ?? "----"
    }
    
    
}
