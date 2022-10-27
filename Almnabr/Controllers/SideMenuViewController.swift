//
//  SideMenuViewController.swift
//  Almnabr
//
//  Created by Hany Alkahlout on 25/10/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var logoutStackView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    private var data = [(title:String,icon:UIImage)]()
    
    var inboxAction: (()->Void)?
    var starredAction: (()->Void)?
    var draftsAction: (()->Void)?
    var sentAction: (()->Void)?
    var spamAction: (()->Void)?
    var trashAction: (()->Void)?
    var logoutAction: (()->Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
        // Do any additional setup after loading the view.
    }
    
    private func initlization(){
        setUpLogoutAction()
        setTableData()
        setUpTableView()
    }
    
    private func setTableData(){
        data.append((title:"Inbox",icon:UIImage(named: "email 1")!))
        data.append((title:"Starred",icon:UIImage(systemName: "star.fill")!))
        data.append((title:"Drafts",icon:UIImage(systemName: "doc")!))
        data.append((title:"Sent",icon:UIImage(named: "sent")!))
        data.append((title:"Spam",icon:UIImage(systemName: "exclamationmark.octagon")!))
        data.append((title:"Trash",icon:UIImage(systemName: "trash")!))
    }
    
    private func setUpLogoutAction(){
        logoutStackView.isUserInteractionEnabled = true
        logoutStackView.addTapGesture {
            self.navigationController?.dismiss(animated: true,completion: {
                self.logoutAction?()
            })
        }
    }
    
    
    
    
    
}
// MARK: - Table View Delegate And DataSource
extension SideMenuViewController: UITableViewDelegate , UITableViewDataSource{
    private func setUpTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell", for: indexPath) as! SideMenuTableViewCell
        let obj = data[indexPath.row]
        cell.titleLabel.text = obj.title
        cell.iconImageView.image = obj.icon
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 0:
            // Inbox
            inboxAction?()
            break
        case 1:
            // Starred
            starredAction?()
            break
        case 2:
            // Drafts
            draftsAction?()
            break
        case 3:
            // Sent
            sentAction?()
            break
        case 4:
            // Spam
            spamAction?()
            break
        case 5:
            // Trash
            trashAction?()
            break
        default:
            break
        }
        dismiss(animated: true)
    }
    
}
