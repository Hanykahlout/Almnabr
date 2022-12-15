//
//  SubProjectTVCell.swift
//  Almnabr
//
//  Created by MacBook on 04/03/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import UIKit

class SubProjectTVCell: UITableViewCell {

    @IBOutlet weak var lblId: UILabel!
    @IBOutlet weak var lblQ_No: UILabel!
    @IBOutlet weak var lblSubject: UILabel!
    @IBOutlet weak var lblGrandTotal: UILabel!
    @IBOutlet weak var lblTaxAmount: UILabel!
    @IBOutlet weak var lblNetAmount: UILabel!
    @IBOutlet weak var lblValNetAmount: UILabel!
    @IBOutlet weak var lblValGrandTotal: UILabel!
    @IBOutlet weak var lblValTaxAmount: UILabel!
    @IBOutlet weak var lblWriter: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblApprovedDate: UILabel!
    
    @IBOutlet weak var viewBack: UIView!
    
    @IBOutlet weak var StackAmount: UIStackView!
    @IBOutlet weak var StackWriter: UIStackView!
    @IBOutlet weak var StackDate: UIStackView!
    @IBOutlet weak var height: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
