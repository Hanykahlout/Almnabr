//
//  InsuranceDetailsTableViewCell.swift
//  Almnabr
//
//  Created by Hany Alkahlout on 19/06/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import UIKit

protocol InsuranceDetailsCellDelegate{
    func deleteAction(id:String,indexPath:IndexPath)
}

typealias InsuranceDetailsDelegate = InsuranceDetailsCellDelegate & UIViewController

class InsuranceDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var dependentNameLabel: UILabel!
    @IBOutlet weak var dependentIDLabel: UILabel!
    @IBOutlet weak var insuranceNumberLabel: UILabel!
    @IBOutlet weak var insuranceRelationshipLabel: UILabel!
    @IBOutlet weak var writerLabel: UILabel!
    
    var delegate:InsuranceDetailsDelegate?
    private var data:InsuranceRecords!
    private var indexPath:IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data:InsuranceRecords,indexPath:IndexPath){
        self.data = data
        self.indexPath = indexPath
        dependentNameLabel.text = data.insurance_dependent_name ?? ""
        dependentIDLabel.text = data.insurance_dependent_id ?? ""
        insuranceNumberLabel.text = data.insurance_dependent_number ?? ""
        insuranceRelationshipLabel.text = data.insurance_dependent_reaplationship ?? ""
        writerLabel.text = data.insurance_dependent_writer ?? ""
        
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        delegate?.deleteAction(id: data.insurance_dependent_id ?? "", indexPath: indexPath)
    }
    
    
    @IBAction func viewAction(_ sender: Any) {
    }
    
    @IBAction func editAction(_ sender: Any) {
    }
}
