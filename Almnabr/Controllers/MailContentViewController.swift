//
//  MailContentViewController.swift
//  Almnabr
//
//  Created by Hany Alkahlout on 31/10/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import UIKit
import WebKit


class MailContentViewController: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var webView: WKWebView!
    
    var data: MailData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        if let data = data{
            UserDefaults.standard.set(data.date ?? "", forKey: "LastInboxDate")
            setData(data: data)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setData(data:MailData){
        subjectLabel.text = data.subject ?? ""
        fromLabel.text = data.from?.name ?? ""
        headerLabel.text = String(data.from?.name?.prefix(1) ?? "-").uppercased()
        dateLabel.text = APIController.shard.getDateString(with: data.date ?? "")
        webView.loadHTMLString(data.message ?? "", baseURL: nil)
    }
    
    
    
    
    @IBAction func replyAction(_ sender: Any) {
    }
    
    @IBAction func moreAction(_ sender: Any) {
    }
    
    
    @IBAction func starAction(_ sender: Any) {
    }
}
