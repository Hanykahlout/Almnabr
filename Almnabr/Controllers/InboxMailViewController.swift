//
//  InboxMailViewController.swift
//  Almnabr
//
//  Created by Hany Alkahlout on 25/10/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import UIKit
import SCLAlertView
class InboxMailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var inboxsTimer: Timer?
    
    private var data = [MailData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
        // Do any additional setup after loading the view.
    }
    
    private func initialization(){
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getInbox()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        APIController.shard.inboxsTimer?.invalidate()
    }
    
}


extension InboxMailViewController: UITableViewDelegate,UITableViewDataSource{
    private func setUpTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(.init(nibName: "InboxMailCellTableViewCell", bundle: nil), forCellReuseIdentifier: "InboxMailCellTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InboxMailCellTableViewCell", for: indexPath) as! InboxMailCellTableViewCell
        cell.setData(data:data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc:MailContentViewController = AppDelegate.mainSB.instanceVC()
        vc.data = data[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


//MARK: - APIHandling
extension InboxMailViewController{
    private func getInbox(){
        showLoadingActivity()
        APIController.shard.startInboxsTimer { data in
            self.hideLoadingActivity()
            if let status = data.status , status{
                DispatchQueue.main.async {
                    UserDefaults.standard.set(data.data?.first?.date ?? "", forKey: "LastInboxDate")
                    self.data = data.data ?? []
                    self.tableView.reloadData()
                }
            }else{
                SCLAlertView().showError("error".localized(), subTitle: data.error ?? "There is an unknown error")
            }
        }
    }
}



