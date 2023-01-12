//
//  Account MastersViewController.swift
//  Almnabr
//
//  Created by Hany Alkahlout on 12/01/2023.
//  Copyright © 2023 Samar Akkila. All rights reserved.
//

import UIKit

class AccountMastersViewController: UIViewController {
    
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var bracnhSelectorStackView: UIStackView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyDataImageView: UIImageView!
    
    
    @IBOutlet weak var mainStackView: UIStackView!
    private var branchSelector:BranchSelection!
    private var data = [AccountMastersRecord]()
    private var temp = [AccountMastersRecord]()
    private var branch_id = ""
    var isChild = false
    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
        // Do any additional setup after loading the view.
    }
    
    
    private func initialization(){
        setUpTableView()
        handleHeaderView()
        addBrachSelector()
        searchTextField.addTarget(self, action: #selector(searchAction), for: .editingChanged)
    }
    
    
    private func handleHeaderView(){
        headerView.btnAction = {
            let language =  L102Language.currentAppleLanguage()
            if language == "ar"{
                self.panel?.openRight(animated: true)
            }else{
                self.panel?.openLeft(animated: true)
            }
        }
    }
    
    
    private func addBrachSelector(){
        branchSelector = BranchSelection()
        branchSelector.withFinancialYearSelection = true
        branchSelector.branchSelectionAction = { selectedBranch in
            self.branch_id = selectedBranch
        }
        
        branchSelector.financialYearSelectionAction = { [weak self] selectedYear in
            self?.getAccountMasters(branch_id: self?.branch_id ?? "", finance_id: selectedYear)
            self?.mainStackView.isHidden = false
        }
        
        bracnhSelectorStackView.addArrangedSubview(branchSelector)
    }
    

    @objc private func searchAction(){
        if searchTextField.text! == ""{
            data = temp
        }else{
            if data.isEmpty{
                data = temp
            }
            data = data.filter{($0.name ?? "").hasPrefix(searchTextField.text!)}
            
        }
        tableView.reloadData()
    }
    
}
// MARK: - Table View Delegate and DataSource
extension AccountMastersViewController:UITableViewDelegate,UITableViewDataSource{
    private func setUpTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(.init(nibName: "AccountMastersTableViewCell", bundle: nil), forCellReuseIdentifier: "AccountMastersTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountMastersTableViewCell", for: indexPath) as! AccountMastersTableViewCell
        let object = data[indexPath.row]
        cell.setData(data: object)
        cell.addButtonAction = { [weak self] in
            let vc = AddAccountMastersViewController()
            vc.data = object
            let nav = UINavigationController(rootViewController: vc)
            nav.setNavigationBarHidden(true, animated: true)
            nav.modalPresentationStyle = .overCurrentContext
            self?.navigationController?.present(nav, animated: true)
        }
        return cell
    }
    
}


// MARK: - API Handling
extension AccountMastersViewController{
    private func getAccountMasters(branch_id:String,finance_id:String){
        showLoadingActivity()
        APIController.shard.getAccountMasters(branch_id: branch_id, finance_id: finance_id) { [weak self] data in
            DispatchQueue.main.async {
                self?.hideLoadingActivity()
                if let status = data.status,status{
                    self?.data = data.records ?? []
                    self?.temp = data.records ?? []
                }else{
                    self?.data.removeAll()
                }
                self?.emptyDataImageView.isHidden = !(self?.data.isEmpty ?? true)
                self?.tableView.reloadData()
            }
        }
    }
    
}

