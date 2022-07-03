//
//  UsersCollectionViewCell.swift
//  Almnabr
//
//  Created by Hany Alkahlout on 04/06/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import UIKit

protocol UsersCollectionViewCellDelegate{
    func removeAction(indexPath:IndexPath)
}

typealias UsersDelegate = UIViewController & UsersCollectionViewCellDelegate

class UsersCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    weak var delegate:UsersDelegate?
    private var indexPath:IndexPath!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(data:SearchBranchRecords,indexPath:IndexPath){
        self.indexPath = indexPath
        titleLabel.text = data.label
    }

    @IBAction func deleteAction(_ sender: Any) {
        self.delegate?.removeAction(indexPath: self.indexPath)
    }
}
