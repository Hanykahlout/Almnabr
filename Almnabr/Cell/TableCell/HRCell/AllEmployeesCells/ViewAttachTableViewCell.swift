//
//  ViewAttachTableViewCell.swift
//  Almnabr
//
//  Created by Hany Alkahlout on 27/06/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import UIKit

class ViewAttachTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    private var fileURL = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setData(data:form_c2_filesRecords){
        titleLabel.text = data.form_c2_file_attach_title ?? ""
        fileURL = data.link ?? ""
    }
    
    @IBAction func viewAttachAction(_ sender: Any) {
        NotificationCenter.default.post(name: .init(rawValue: "ViewAttachmentUrl"), object: fileURL)
    }
    
    
}
