//
//  ContractTVCell.swift
//  Almnabr
//
//  Created by MacBook on 01/04/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import UIKit

class ContractTVCell: UITableViewCell {

    @IBOutlet weak var lblSubject: UILabel!
    @IBOutlet weak var lblContractDate: UILabel!
    @IBOutlet weak var lblWorkDomain: UILabel!
    @IBOutlet weak var lblWorkLocation: UILabel!
    @IBOutlet weak var lblApprovedDate: UILabel!
    @IBOutlet weak var lblWriter: UILabel!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var viewStatus: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        viewBack.layer.shadowColor = UIColor.systemGray.cgColor
        viewBack.layer.shadowOpacity = 0.8
        viewBack.layer.shadowOffset = .zero
        viewBack.layer.shadowRadius = 4
        viewBack.layer.cornerRadius = 20
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
