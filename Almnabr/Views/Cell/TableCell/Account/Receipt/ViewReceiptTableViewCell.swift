//
//  ViewReceiptTableViewCell.swift
//  Almnabr
//
//  Created by Hany Alkahlout on 05/02/2023.
//  Copyright © 2023 Samar Akkila. All rights reserved.
//

import UIKit

class ViewReceiptTableViewCell: UITableViewCell {

    @IBOutlet weak var accountCodeLabel: UILabel!
    @IBOutlet weak var costCenterCodeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var debitAmountLabel: UILabel!
    @IBOutlet weak var creditAmountLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data:ReceiptTransaction){
        accountCodeLabel.text = data.account_name ?? "----"
        costCenterCodeLabel.text = data.cost_center_name ?? "----"
        descriptionLabel.text = data.transaction_history_description ?? "----"
        debitAmountLabel.text = data.debit_amount ?? "----"
        creditAmountLabel.text = data.credit_amount ?? "----"
    }
    
    
    
    @IBAction func transactionAction(_ sender: Any) {
    }
    
    
    @IBAction func costCenterAction(_ sender: Any) {
    }
}
