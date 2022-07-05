//
//  OutgoingAttachmentTableViewCell.swift
//  Almnabr
//
//  Created by Hany Alkahlout on 22/06/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import UIKit

protocol OutgoingAttachmentCellDelegate{
    func deleteAction()
    func selectFileAction(indexPath:IndexPath)
}


class OutgoingAttachmentTableViewCell: UITableViewCell {

    @IBOutlet weak var attachwithPdfButton: UIButton!
    @IBOutlet weak var officialPaperButton: UIButton!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var selectFileButton: UIButton!
    
    @IBOutlet weak var attachwithPdfStackView: UIStackView!
    @IBOutlet weak var officialPaperStackView: UIStackView!
    
    
    var delegate: (OutgoingAttachmentCellDelegate & UIViewController)?
    var indexPath:IndexPath!
    var fileUrl:URL?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func selectFileAction(_ sender: Any) {
        delegate?.selectFileAction(indexPath: indexPath)
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        delegate?.deleteAction()
    }
    
    
    @IBAction func attachwithPdfAction(_ sender: Any) {
        attachwithPdfButton.isSelected = !attachwithPdfButton.isSelected
    }
    
    @IBAction func officialPaperAction(_ sender: Any) {
        officialPaperButton.isSelected = !officialPaperButton.isSelected
    }
    
}

