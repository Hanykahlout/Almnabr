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
    
    
    private var data = [MailData]()
    
    private var pageNumber = 1
    private var totalPages = 1
    private var isFromBottom = false
    private var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
        // Do any additional setup after loading the view.
    }
    
    private func initialization(){
        setUpTableView()
        startTimer()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        APIController.shard.inboxsTimer?.invalidate()
    }
    
    @objc private func refresh(){
        pageNumber = 1
        isFromBottom = false
        self.getInboxsData()
    }
    
}


extension InboxMailViewController: UITableViewDelegate,UITableViewDataSource{
    private func setUpTableView(){
        tableView.refreshControl = refreshControl
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
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == data.count - 1{
            if pageNumber < totalPages{
                pageNumber += 1
                isFromBottom = true
                getInboxsData()
            }
        }
    }
    
}

//MARK: - APIHandling
extension InboxMailViewController{
    private func startTimer(){
        isFromBottom = false
        pageNumber = 1
        showLoadingActivity()
        APIController.shard.startInboxsTimer(pageNumber: String(pageNumber), callback: handleInboxResponse)
    }
    
    private func getInboxsData(){
        APIController.shard.getMailsInbox(pageNumber:String(pageNumber),callback: handleInboxResponse)
    }
    
    private func handleInboxResponse(_ data:MailInboxResponse){
        DispatchQueue.main.async {
            self.hideLoadingActivity()
            if let status = data.status , status{
                
                if self.isFromBottom {
                    self.data.append(contentsOf: data.data ?? [])
                }else{
                    self.data = data.data ?? []
                }
                let total = Double(data.count_all ?? 1) / 10
                if total.truncatingRemainder(dividingBy: 1) == 0 {
                    self.totalPages = Int(total)
                }else{
                    self.totalPages = Int(total) + 1
                }

            }else{
                if !self.isFromBottom{
                    self.data.removeAll()
                    SCLAlertView().showError("error".localized(), subTitle: data.error ?? "There is an unknown error")
                }
            }
            self.tableView.reloadData()
            if self.refreshControl.isRefreshing{
                self.refreshControl.endRefreshing()
            }
        }
    }
   
    
}


