//
//  DocumentsViewController.swift
//  Almnabr
//
//  Created by Hany Alkahlout on 16/08/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import UIKit
import SCLAlertView

class DocumentsViewController: UIViewController {
    
    @IBOutlet weak var header: HeaderView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var addView: UIView!
    
    private var data = [DocumentData]()
    private var currentPage = 1
    private var totalPages:Int?
    private var document_branch = ""
    private var document_number = ""
    private var selectedBranchs = [SearchBranchRecords]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
        // Do any additional setup after loading the view.
    }
    
    private func initlization(){
        addView.isHidden = true
        handleHeaderView()
        setUpTableView()
        setUpViews()
        setUpObserver()
        searchTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDocuments(isFromBottom: false)
    }
    
    private func setUpViews(){
        filterView.addTapGesture {
            let vc = FilterDocumentVC()
            vc.docNumber = self.document_number
            vc.selectedBranchs = self.selectedBranchs
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .overCurrentContext
            self.navigationController?.present(nav, animated: true)
        }
        
        addView.addTapGesture {
            let vc = AddDocumentVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func setUpObserver(){
        NotificationCenter.default.addObserver(forName: .init("DocFilterAction"), object: nil, queue: .main) { notify in
            guard let data = notify.object as? (selectedBranchs:[SearchBranchRecords],docNumber:String) else { return }
            self.selectedBranchs = data.selectedBranchs
            var branchs = ""
            for index in 0..<data.selectedBranchs.count{
                if index == 0{
                    branchs.append(data.selectedBranchs[index].value ?? "-1")
                }else{
                    branchs.append(",\(branchs.append(data.selectedBranchs[index].value ?? "-1"))")
                }
            }
            self.document_branch = branchs
            self.document_number = data.docNumber
            self.getDocuments(isFromBottom: false)
        }
    }
    
    private func handleHeaderView(){
        header.btnAction = {
            let language =  L102Language.currentAppleLanguage()
            if language == "ar"{
                self.panel?.openRight(animated: true)
            }else{
                self.panel?.openLeft(animated: true)
            }
        }
    }
    
    
    @IBAction func searchAction(_ sender: Any) {
        getDocuments(isFromBottom: false)
    }
    
    
}

extension DocumentsViewController:UITableViewDelegate,UITableViewDataSource{
    private func setUpTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(.init(nibName: "DocumentsTableViewCell", bundle: nil), forCellReuseIdentifier: "DocumentsTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentsTableViewCell", for: indexPath) as! DocumentsTableViewCell
        cell.setData(data:data[indexPath.row])
        cell.deleteDocAction = {
            let docId = self.data[indexPath.row].document_id ?? "-1"
            APIController.shard.deleteDocument(documentId: docId) { data in
                if let status = data.status,status{
                    self.data.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                }else{
                    SCLAlertView().showError("error".localized(), subTitle: data.error ?? "Somthing went wrong!!")
                }
            }
        }
        
        cell.viewDocAction = {
            let vc = AddDocumentVC()
            vc.data = self.data[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        cell.downloadDocAction = { [unowned self] filePath in
            self.getDoc(filePath: filePath)
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == data.count - 1{
            if let totalPages = totalPages , currentPage < totalPages{
                currentPage += 1
                getDocuments(isFromBottom: true)
            }
        }
    }
    
}

// MARK: - TextField Delegate
extension DocumentsViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        getDocuments(isFromBottom: false)
        return true
    }
    
}


// MARK: - API handling
extension DocumentsViewController{
    private func getDocuments(isFromBottom:Bool){
        showLoadingActivity()
        APIController.shard.getDocuments(document_branch: document_branch, document_number: document_number, searchText:searchTextField.text! , pageNumber: "\(currentPage)") { data in
            self.hideLoadingActivity()
            if let status = data.status,status{
                if isFromBottom{
                    self.data.append(contentsOf: data.data ?? [])
                }else{
                    self.data = data.data ?? []
                }
                
                self.totalPages = data.page?.total_pages
            }else{
                self.data.removeAll()
                SCLAlertView().showError("error".localized(), subTitle: data.error ?? "There is an unknow error.")
            }
            self.tableView.reloadData()
        }
    }
    
    private func getDoc(filePath:String){
        showLoadingActivity()
        APIController.shard.getImage(url: filePath) { [unowned self] data in
            self.hideLoadingActivity()
            if let status = data.status,status{
                let vc = WebViewViewController()
                vc.data = data
                let nav = UINavigationController(rootViewController: vc)
                self.navigationController?.present(nav, animated: true)
            }
        }
    }
}







