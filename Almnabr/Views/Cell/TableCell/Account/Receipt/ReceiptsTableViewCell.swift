//
//  ReceiptsTableViewCell.swift
//  Almnabr
//
//  Created by Hany Alkahlout on 01/02/2023.
//  Copyright © 2023 Samar Akkila. All rights reserved.
//

import UIKit
import DropDown
class ReceiptsTableViewCell: UITableViewCell {

    @IBOutlet weak var receiptNoLabel: UILabel!
    @IBOutlet weak var requestNumberLabel: UILabel!
    @IBOutlet weak var actionModeLabel: UILabel!
    @IBOutlet weak var receiptFromLabel: UILabel!
    @IBOutlet weak var receiptDateLabel: UILabel!
    @IBOutlet weak var receiptAmountLabel: UILabel!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var onDateLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    private var moreDropDown = DropDown()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpDropDownList()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setUpDropDownList(){
//        moreDropDown
        moreDropDown.anchorView = moreButton
        moreDropDown.bottomOffset = CGPoint(x: -bounds.width, y:(moreDropDown.anchorView?.plainView.bounds.height)!)
        moreDropDown.dataSource = ["View","Edit","Delete","Export PDF","Export Excel","Export PDF to Email","Export Excel to Email"]
        moreDropDown.selectionAction = { [weak self] (index: Int, item: String) in
            
        }
    
    }
    
    
    func setData(data: ReceiptRecord){
        receiptNoLabel.text = data.payreceipt_system_code ?? "----"
        requestNumberLabel.text = data.transaction_id  ?? "----"
        actionModeLabel.text = "----"
        receiptFromLabel.text = data.payment_receipt_to_from ?? "----"
        receiptDateLabel.text = data.payment_receipt_date ?? "----"
        receiptAmountLabel.text = data.payment_receipt_amount ?? "----"
        writerLabel.text = data.writer_name ?? "----"
        onDateLabel.text = data.payment_receipt_created_date ?? "----"
        
    }
    
    
    @IBAction func moreAction(_ sender: Any) {
        moreDropDown.show()
    }
    
}
