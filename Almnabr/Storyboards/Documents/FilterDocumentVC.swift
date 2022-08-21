//
//  FilterDocumentVC.swift
//  Almnabr
//
//  Created by Hany Alkahlout on 16/08/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import UIKit
import DropDown

class FilterDocumentVC: UIViewController {
    
    @IBOutlet weak var branchTypeLabel: UILabel!

    @IBOutlet weak var branchTypeView: UIView!
    @IBOutlet weak var branchCollectionView: UICollectionView!

    @IBOutlet weak var docNumberTextField: UITextField!
    @IBOutlet weak var branchArrow: UIImageView!
    
    private var branchs = [SearchBranchRecords]()
    var selectedBranchs = [SearchBranchRecords]()
    private var docTypesDropDown = DropDown()
    private var branchTypesDropDown = DropDown()
    var docNumber = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()

    }
    
    
    private func initlization(){
        setUpDropDownLists()
        setUpCollection()
        getAllBranchs()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        self.docNumberTextField.text = docNumber
        branchTypeLabel.isHidden = !selectedBranchs.isEmpty
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setUpDropDownLists(){
        
        branchTypesDropDown.anchorView = branchTypeView

        branchTypesDropDown.bottomOffset = CGPoint(x: 0, y:(branchTypesDropDown.anchorView?.plainView.bounds.height)!)

        branchTypesDropDown.selectionAction = { [weak self] index , item in
            self?.branchArrow.transform = .init(rotationAngle: .pi)
            if self?.selectedBranchs.contains(where: {$0.value == self?.branchs[index].value}) != true{
                self?.selectedBranchs.insert(self!.branchs[index], at: 0)
                self?.branchTypeLabel.isHidden = true
                let indexPath = IndexPath(row: 0, section: 0)
                self?.branchCollectionView.insertItems(at: [indexPath])
                self?.branchCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }
        
        branchTypesDropDown.cancelAction = {
            self.branchArrow.transform = .init(rotationAngle: 0)
        }
        
        branchTypeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(branchTypeTextFieldAction)))
        
    }
    
    
    
    @objc private func docTypeTextFieldAction(){
        docTypesDropDown.show()
    }
    
    @objc private func branchTypeTextFieldAction(){
        branchTypesDropDown.show()
    }
    

    @IBAction func saveAciton(_ sender: Any) {
        saveFilterAction()
    }
    
    
    @IBAction func resetAction(_ sender: Any) {
        NotificationCenter.default.post(name: .init("DocFilterAction"), object: ([],""))
        navigationController?.dismiss(animated: true)
    }
    
    
    @IBAction func closeAction(_ sender: Any) {
        navigationController?.dismiss(animated: true)
    }
    
}

// MARK: - Set Up Collection View

extension FilterDocumentVC: UICollectionViewDelegate,UICollectionViewDataSource{
    private func setUpCollection(){
        
        branchCollectionView.delegate = self
        branchCollectionView.dataSource = self
        branchCollectionView.register(.init(nibName: "UsersCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UsersCollectionViewCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedBranchs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UsersCollectionViewCell", for: indexPath) as! UsersCollectionViewCell
        cell.setData(data: selectedBranchs[indexPath.row], indexPath: indexPath)
        cell.delegate = self
        return cell
    }
    
}
// MARK: - Set Up Collection View Cell Delegate
extension FilterDocumentVC:UsersCollectionViewCellDelegate{
    func removeAction(indexPath:IndexPath){
        selectedBranchs.remove(at: indexPath.row)
        if selectedBranchs.isEmpty{
            branchTypeLabel.isHidden = false
        }
        branchCollectionView.reloadData()
    }
}


// MARK: - API Handling

extension FilterDocumentVC{
    private func getAllBranchs(){
        APIController.shard.getFilterData2 { data in
            if let status = data.status,status{
                self.branchs = data.branches ?? []
                self.branchTypesDropDown.dataSource = data.branches?.map({$0.label ?? ""}) ?? []
            }
        }
    }
    
    private func saveFilterAction(){
       
        NotificationCenter.default.post(name: .init("DocFilterAction"), object: (selectedBranchs,docNumberTextField.text!))
        navigationController?.dismiss(animated: true)
    }
    
}



