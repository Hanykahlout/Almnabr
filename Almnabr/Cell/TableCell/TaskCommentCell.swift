//
//  TaskCommentCell.swift
//  Almnabr
//
//  Created by MacBook on 11/05/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import UIKit

class TaskCommentCell: UITableViewCell ,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var viewBack: UIView!
    
    @IBOutlet weak var btnView_reply: UIButton!
    
    @IBOutlet weak var containerStack: UIStackView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var replysTable: UITableView!
    @IBOutlet weak var dropView: UIView! {
        didSet {
            dropView.isHidden = true
        }
    }
    
    
    var btnViewReplyAction : (()->())?
    var btnDeleteReplyAction : ((_ comment_id: String)-> Void)?
    var btnEditReplyAction : ((_ comment_id: String, _ comment: String)-> Void)?
    
    
    
    var arr_reply :[ReplyObj] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpTable(){
        replysTable.dataSource = self
        replysTable.delegate = self
        
        let nib = UINib(nibName: "CommentRepltTableViewCell", bundle: nil)
        replysTable.register(nib, forCellReuseIdentifier: "CommentRepltTableViewCell")

        tableHeight.constant = CGFloat(arr_reply.count * 100 )

        self.replysTable.setNeedsLayout()
        
        self.replysTable.reloadData()
     }
    
    
    
    @IBAction func didviewReplyButtonPressd(_ sender: Any) {
        btnViewReplyAction!()
    }
    

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arr_reply.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "CommentRepltTableViewCell", for: indexPath) as! CommentRepltTableViewCell
    
    let obj = arr_reply[indexPath.item]
    cell.lblDate.text = obj.comment_date
    cell.lblUserName.text = obj.userName
    cell.lblComment.text = obj.comment_content
  
    cell.btnEditAction = {
        self.btnEditReplyAction!(obj.history_id , obj.comment_content)
    }
    
    cell.btnDeleteAction = {
        self.btnDeleteReplyAction!(obj.history_id)
        
    }
    return cell
    
}


}
