//
//  HistoryVC.swift
//  Almnabr
//
//  Created by MacBook on 09/12/2021.
//  Copyright © 2021 Samar Akkila. All rights reserved.
//

import UIKit

class HistoryVC: UIViewController {

    
    @IBOutlet weak var table: UITableView!
    
    var arr_data:[transactions_recordsObj] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configNavigation()
        SetupTable()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    // MARK: - Config Navigation
    func configNavigation() {
        _ = self.navigationController?.preferredStatusBarStyle
        self.view.backgroundColor = maincolor //F0F4F8
        //navigationController?.navigationBar.barTintColor = .buttonBackgroundColor()
        navigationController?.navigationBar.barTintColor = maincolor
       addNavigationBarTitle(navigationTitle: "History".localized())
        UINavigationBar.appearance().backgroundColor = maincolor
    }
    
    
    
    // MARK: - Setup Table
    
    func SetupTable(){
        
        table.dataSource = self
        table.delegate = self
        let nib = UINib(nibName: "TransactionTVCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: "TransactionTVCell")
        self.table.reloadData()
    }
}




extension HistoryVC: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTVCell", for: indexPath) as! TransactionTVCell
        
        let obj = arr_data[indexPath.item]
       
        
        
        let no =  "#".localized() + "  \(indexPath.item + 1)"
        let Name = "Name".localized() + "  \(obj.transactions_records_user_name )"
        let Notes = "Notes".localized() + "  \(obj.transactions_records_note)"
        let OnDate = "On Date".localized() + "  \(obj.transactions_records_datetime)"
    
        cell.lbKeylNo.text = no
        cell.lblKeyDesc.text = Name
        cell.lblKeyFrom.text = Notes
        cell.lblKeyLastUpdate.text = OnDate
        
        cell.lblKeyBarCode.isHidden = true
        cell.lblKeyType.isHidden = true
        cell.lblKeyModule.isHidden = true
        cell.lblKeyWriter.isHidden = true
        cell.lblKeySubmitter.isHidden = true
        cell.lblKeyStatus.isHidden = true
        cell.lblKeyTo.isHidden = true
        
        
        let attributedWithTextColor: NSAttributedString = no.attributedStringWithColor(["#".localized()], color: HelperClassSwift.acolor.getUIColor())
        cell.lbKeylNo.attributedText = attributedWithTextColor
        
        let Nameattributed: NSAttributedString = Name.attributedStringWithColor(["Name".localized()], color: HelperClassSwift.acolor.getUIColor())
        cell.lblKeyDesc.attributedText = Nameattributed
        
       
        let Notesattributed: NSAttributedString = Notes.attributedStringWithColor(["Notes".localized()], color: HelperClassSwift.acolor.getUIColor())
        cell.lblKeyFrom.attributedText = Notesattributed
        
        
        let Lastattributed: NSAttributedString = OnDate.attributedStringWithColor(["On Date".localized()], color: HelperClassSwift.acolor.getUIColor())
        cell.lblKeyLastUpdate.attributedText = Lastattributed
        
        
        cell.viewBack.setcorner()
        
       
        return cell
        
    }
    
    
}

