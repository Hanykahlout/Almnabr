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
    
    private var pageNumber = 1
    private var totalPages = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
        // Do any additional setup after loading the view.
    }
    
    private func initialization(){
        setUpTableView()
        getInbox(isFromBottom: false)
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
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == data.count - 1{
            if pageNumber < totalPages{
                pageNumber += 1
                getInbox(isFromBottom: true)
            }
        }
    }
}


//MARK: - APIHandling
extension InboxMailViewController{
    private func getInbox(isFromBottom:Bool){
        if !isFromBottom {
            pageNumber = 1
        }
        
        showLoadingActivity()
        APIController.shard.startInboxsTimer(pageNumber:String(pageNumber)){ data in
            self.hideLoadingActivity()
            if let status = data.status , status{
                DispatchQueue.main.async {
                    UserDefaults.standard.set(data.data?.first?.date ?? "", forKey: "LastInboxDate")
                    if isFromBottom {
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
                    self.tableView.reloadData()
                }
            }else{
                SCLAlertView().showError("error".localized(), subTitle: data.error ?? "There is an unknown error")
            }
        }
    }
}




