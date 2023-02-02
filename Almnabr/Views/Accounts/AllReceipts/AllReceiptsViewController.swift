//
//  AllReceiptsViewController.swift
//  Almnabr
//
//  Created by Hany Alkahlout on 01/02/2023.
//  Copyright © 2023 Samar Akkila. All rights reserved.
//

import UIKit
import FAPanels
class AllReceiptsViewController: UIViewController {

    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var branchSelectorStackView: UIStackView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyDataImageView: UIImageView!
    
    private var data = [ReceiptRecord]()
    private var branchSelector:BranchSelection?
    private var branch_id = ""
    private var finance_id = ""
    private var totalPages = 1
    private var pageNumber = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllReceipts(isFromBottom: false)
    }

    private func initialization(){
        setUpBranchSelector()
        setUpTableView()
        handleHeaderView()
        addView.isUserInteractionEnabled = true
        addView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addAction)))
        searchTextField.addTarget(self, action: #selector(searchAction), for: .editingChanged)
    }
    
    
    private func setUpBranchSelector(){
        branchSelector = BranchSelection()
        branchSelector!.withFinancialYearSelection = true
        branchSelector!.branchSelectionAction = { [weak self] branch_id in
            self?.branch_id = branch_id
            self?.getAllReceipts(isFromBottom: false)
        }
        branchSelector?.financialYearSelectionAction = { [weak self] finance_id in
            self?.finance_id = finance_id
            self?.getAllReceipts(isFromBottom: false)
        }
        branchSelectorStackView.addArrangedSubview(branchSelector!)
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

    
    @objc private func searchAction(){
        getAllReceipts(isFromBottom: false)
    }
    
    
    @objc private func addAction(){
        let vc = CreateReceiptViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.isNavigationBarHidden = true
        panel?.center(nav)
    }
    
}


extension AllReceiptsViewController:UITableViewDelegate,UITableViewDataSource{
    private func setUpTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(.init(nibName: "ReceiptsTableViewCell", bundle: nil), forCellReuseIdentifier: "ReceiptsTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiptsTableViewCell", for: indexPath) as! ReceiptsTableViewCell
        cell.setData(data: data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == data.count - 1 {
            if pageNumber < totalPages{
                pageNumber += 1
                getAllReceipts(isFromBottom: true)
            }
        }
    }
}

extension AllReceiptsViewController{
    private func getAllReceipts(isFromBottom:Bool){
        if !isFromBottom{
            pageNumber = 1
        }
        showLoadingActivity()
        APIController.shard.getReceipts(branch_id: branch_id, finance_id: finance_id, search_key: searchTextField.text!, pageNumber: String(pageNumber)) { data in
            DispatchQueue.main.async { [weak self] in
                self?.hideLoadingActivity()
                if data.status ?? false{
                    if isFromBottom{
                        self?.data.append(contentsOf: data.records ?? [])
                    }else{
                        self?.data = data.records ?? []
                    }
                }else{
                    if !isFromBottom{
                        self?.data.removeAll()
                    }
                }
                self?.totalPages = data.paging?.total_pages ?? 1
                self?.emptyDataImageView.isHidden = !(self?.data.isEmpty ?? true)
                self?.tableView.reloadData()
            }
        }
    }
    
    
}
