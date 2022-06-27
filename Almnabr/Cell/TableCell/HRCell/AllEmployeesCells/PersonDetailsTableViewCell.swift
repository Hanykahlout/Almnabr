//
//  PersonDetailsTableViewCell.swift
//  Almnabr
//
//  Created by Hany Alkahlout on 26/06/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import UIKit

class PersonDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLAbel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var viewCheckButton: UIButton!
    @IBOutlet weak var viewTimeLabel: UILabel!
    @IBOutlet weak var lastViewTimeLable: UILabel!
    @IBOutlet weak var actionCheckButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data:transactions_personsRecords){
        nameLAbel.text = data.person_name ?? ""
        typeLabel.text = data.transaction_persons_type ?? ""
//        viewCheckButton.tintColor =
        viewTimeLabel.text = data.transactions_persons_view_datetime ?? ""
//        lastViewTimeLable.text  =
//        actionCheckButton.tintColor =
        
    }
}
