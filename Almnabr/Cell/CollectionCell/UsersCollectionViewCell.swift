//
//  UsersCollectionViewCell.swift
//  Almnabr
//
//  Created by Hany Alkahlout on 04/06/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import UIKit
import MOLH

protocol UsersCollectionViewCellDelegate{
    func removeAction(indexPath:IndexPath)
    func removeAction(type:CollectionType,indexPath:IndexPath)
}

typealias UsersDelegate = UIViewController & UsersCollectionViewCellDelegate

class UsersCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    weak var delegate:UsersDelegate?
    private var indexPath:IndexPath!
    var type:CollectionType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(data:SearchBranchRecords,indexPath:IndexPath){
        self.indexPath = indexPath
        titleLabel.text = data.label
    }
    
    func setData(data:AttachmentTypeRecords,indexPath:IndexPath){
        self.indexPath = indexPath
        titleLabel.text = data.title ?? ""
    }
    
    
    func setData(type:CollectionType,data:SelectionInfo,indexPath:IndexPath){
        self.indexPath = indexPath
        self.type = type
        titleLabel.text = MOLHLanguage.currentAppleLanguage() == "en" ? data.name_english ?? "" : data.name_arabic ?? ""
    }
    
    
    func setData(type:CollectionType,data:SearchBranchRecords,indexPath:IndexPath){
        self.indexPath = indexPath
        self.type = type
        titleLabel.text = data.label ?? ""
    }
    
    func setData(type:CollectionType,data:FilterGetRecords2,indexPath:IndexPath){
        self.indexPath = indexPath
        self.type = type
        titleLabel.text = data.quotation_subject ?? ""
    }
    
    
    
    @IBAction func deleteAction(_ sender: Any) {
        if let type = type {
            delegate?.removeAction(type: type, indexPath: indexPath)
        }else{
            delegate?.removeAction(indexPath: indexPath)
        }
    }
}
