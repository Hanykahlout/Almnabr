//
//  AddAttachmentViewController.swift
//  Almnabr
//
//  Created by Hany Alkahlout on 16/06/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import UIKit
import MOLH
import DropDown
import MobileCoreServices
import UniformTypeIdentifiers

class AddAttachmentViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    
    
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var visiblityView: UIView!
    @IBOutlet weak var visiblityArrow: UIImageView!
    @IBOutlet weak var visiblityLabel: UILabel!
    
    @IBOutlet weak var selectFileButton: UIButton!
    
    private var documentPickerController: UIDocumentPickerViewController!
    private var visibiltyData = [SearchBranchRecords]()
    private var selectedItems = [SearchBranchRecords]()
    private var dropDown = DropDown()
    private var fileUrl:URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
        // Do any additional setup after loading the view.
    }
    
    private func initlization(){
        if MOLHLanguage.currentAppleLanguage() == "ar"{
            backButton.transform = .init(rotationAngle: .pi)
        }
        setUpCollectionView()
        getVisibiltyData()
        setUpDropDownList()
    }
    
    
    private func setUpDropDownList(){
        dropDown.anchorView = visiblityView
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            visiblityArrow.transform = .init(rotationAngle: 0)
            let selectedItem = visibiltyData[index]
            if !self.selectedItems.contains(where: {$0.value == selectedItem.value}){
                self.selectedItems.append(selectedItem)
                self.collectionView.reloadData()
                self.visiblityLabel.isHidden = true
            }
        }
        
        dropDown.cancelAction = { [unowned self] in
            visiblityArrow.transform = .init(rotationAngle: 0)
        }
        visiblityView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(visiblityViewAction)))
        
    }
    
    
    private func selectAttachment(){
        documentPickerController = UIDocumentPickerViewController(
            forOpeningContentTypes: [.pdf])
        documentPickerController.delegate = self
          self.present(documentPickerController, animated: true, completion: nil)
    }
    
    
    @objc private func visiblityViewAction(){
        dropDown.show()
    }
    

    @IBAction func selectFileAction(_ sender: Any) {
        let alertVC = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alertVC.addAction(.init(title: "Choose Photo", style: .default, handler: { action in
            self.setImageBy(source: .photoLibrary)
        }))
        alertVC.addAction(.init(title: "Choose Pdf", style: .default, handler: { action in
            self.selectAttachment()
        }))
        present(alertVC, animated: true, completion: nil)
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func submitAction(_ sender: Any) {
        var param:[String:Any] = [:]
        
        param["employee_number"] = ViewEmployeeDetailsVC.empData.data?.employee_number ?? ""
        param["attachment_type"] = "EN0001"
        param["attachment_descriptions"] = descriptionTextField.text!

        for index in 0..<selectedItems.count {
            param["level_keys[\(index)]"] = selectedItems[index].value ?? ""
        }
        
        uploadAttachmentData(body: param)
    }
    
}

// MARK: - UIDocumentPickerViewControllerDelegate
extension AddAttachmentViewController:UIDocumentPickerDelegate{
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        self.fileUrl = myURL
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
}


// MARK: - UIImagePickerControllerDelegate
extension AddAttachmentViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    private func setImageBy(source:UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL
        fileUrl = imgUrl
        dismiss(animated: true, completion: nil)
    }
    
}


// MARK: - Set Up Collection View

extension AddAttachmentViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    private func setUpCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(.init(nibName: "UsersCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UsersCollectionViewCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UsersCollectionViewCell", for: indexPath) as! UsersCollectionViewCell
        cell.delegate = self
        cell.setData(data: selectedItems[indexPath.row], indexPath: indexPath)
        return cell
    }

}

// MARK: - Collection View Cell Delegate
extension AddAttachmentViewController: UsersCollectionViewCellDelegate{
    func removeAction(indexPath: IndexPath) {
        selectedItems.remove(at: indexPath.row)
        collectionView.reloadData()
        if selectedItems.isEmpty{
            visiblityLabel.isHidden = false
        }
    }
    
    func removeAction(type: CollectionType, indexPath: IndexPath) {
        // no action here
    }
    
}


// MARK: - API Handling

extension AddAttachmentViewController{
    private func getVisibiltyData(){
        APIController.shard.getVisibiltyData { data in
            if let status = data.status, status{
                self.visibiltyData = data.records ?? []
                self.dropDown.dataSource = (data.records ?? []).map{$0.label ?? ""}
            }
        }
    }
    
    private func uploadAttachmentData(body:[String:Any]){
        showLoadingActivity()
        APIController.shard.uploadAttachmentData(fileUrl: fileUrl, body: body) { data in
            DispatchQueue.main.async{
                self.hideLoadingActivity()
                var alertVC:UIAlertController!
                if let status = data.status,status{
                    alertVC = UIAlertController(title: "Success", message: data.msg, preferredStyle: .alert)
                    alertVC.addAction(.init(title: "Cancel", style: .cancel, handler: { action in
                        self.navigationController?.popViewController(animated: true)
                    }))
                }else{
                    alertVC = UIAlertController(title: "Error", message: data.error, preferredStyle: .alert)
                    alertVC.addAction(.init(title: "Cancel", style: .cancel, handler:nil))
                }
                self.present(alertVC, animated: true)
            }
        }
    }
}


extension URL {
    public func mimeType() -> String {
        if let mimeType = UTType(filenameExtension: self.pathExtension)?.preferredMIMEType {
            return mimeType
        }
        else {
            return "application/octet-stream"
        }
    }
}
