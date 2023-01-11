//
//  CostCenterViewController.swift
//  Almnabr
//
//  Created by Hany Alkahlout on 08/01/2023.
//  Copyright © 2023 Samar Akkila. All rights reserved.
//

import UIKit

class CostCenterViewController: UIViewController {

    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyDataImageView: UIImageView!
    
    private var branchSelectionView: BranchSelection!
    private var selectedBranchId = ""
    private var data = [CostCentersRecord]()
    private var temp = [CostCentersRecord]()
    private let refreshControl = UIRefreshControl()
    private var observer:NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
        // Do any additional setup after loading the view.
    }
    
    private func initialization(){
        handleHeaderView()
        setUpTableView()
        branchSelectionView = BranchSelection(frame: .init())
        branchSelectionView.withFinancialYearSelection = false
        branchSelectionView.branchSelectionAction = { value in
            self.selectedBranchId = value
            self.getCostCentersData()
        }
        mainStackView.insertArrangedSubview(branchSelectionView, at: 0)
        searchTextField.addTarget(self, action: #selector(searchAction), for: .editingChanged)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCostCentersData()
        observer = NotificationCenter.default.addObserver(forName: .init("ReloadCostCenters"), object: nil, queue: .main) { notify in
            self.getCostCentersData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(observer!)
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
    
    @objc private func refresh(){
        getCostCentersData()
    }
    
    @IBAction func addAction(_ sender: Any) {
        let vc = AddCostCenterViewController()
        vc.branch_id = selectedBranchId
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overCurrentContext
        nav.isNavigationBarHidden = true
        navigationController?.present(nav, animated: true)
    }
    
    
}

extension CostCenterViewController:UITableViewDelegate,UITableViewDataSource{
    private func setUpTableView(){
        tableView.refreshControl = refreshControl
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(.init(nibName: "CostCenterTableViewCell", bundle: nil), forCellReuseIdentifier: "CostCenterTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CostCenterTableViewCell", for: indexPath) as! CostCenterTableViewCell
        cell.setData(data: data[indexPath.row])
        return cell
    }
    
}
// MARK: - API Handling
extension CostCenterViewController{
    private func getCostCentersData(){
        showLoadingActivity()
        APIController.shard.getCostCentersData(branch_id: selectedBranchId) { data in
            DispatchQueue.main.async {
                self.hideLoadingActivity()
                if let status = data.status,status{
                    self.data = data.records ?? []
                    self.temp = data.records ?? []
                }else{
                    self.data.removeAll()
                }
                self.emptyDataImageView.isHidden = !self.data.isEmpty
                self.tableView.reloadData()
                if self.refreshControl.isRefreshing{
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
}





