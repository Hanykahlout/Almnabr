//
//  FormsAttachmentsVC.swift
//  Almnabr
//
//  Created by MacBook on 09/12/2021.
//  Copyright © 2021 Samar Akkila. All rights reserved.
//

import UIKit

class FormsAttachmentsVC: UIViewController {

    
    @IBOutlet weak var table: UITableView!
    
    var arr_data:[Configurations_AttachmentsObj] = []
    
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
        self.view.backgroundColor = maincolor//F0F4F8
        //navigationController?.navigationBar.barTintColor = .buttonBackgroundColor()
        navigationController?.navigationBar.barTintColor = maincolor
       addNavigationBarTitle(navigationTitle: "Attachments".localized())
        UINavigationBar.appearance().backgroundColor = maincolor
    }
    
    
    
    // MARK: - Setup Table
    
    func SetupTable(){
        
        table.dataSource = self
        table.delegate = self
        let nib = UINib(nibName: "FormVersionCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: "FormVersionCell")
        self.table.reloadData()
    }
}




extension FormsAttachmentsVC: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
      
            return arr_data.count
    
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
            let cell = tableView.dequeueReusableCell(withIdentifier: "FormVersionCell", for: indexPath) as! FormVersionCell
            
            let obj = arr_data[indexPath.item]
         
      
        let Number = "#" + "  \(indexPath.item + 1)"
        let AttachmentsTitle = "Attachments Title".localized() + "   \(obj.project_supervision_form_file_attach_title)"
        let Writer = "Writer".localized() + "   \(obj.writer_name)"
        let Date = "Date".localized() + "   \(obj.created_datetime)"
        let FileSize = "File Size".localized() + "   \(obj.project_supervision_form_file_size)"
        let AttachmentType = "Attachment Type".localized() + "   \(obj.project_supervision_form_file_attach_type_label)"
        
        
        cell.lblNo.text = Number
        cell.lblUnit.text = AttachmentsTitle
        cell.lblWorklevel.text = Writer
        cell.lblEvaluationResult.text = Date
        cell.lblDate.text = FileSize
        cell.lblBarcode.text = AttachmentType
        
        
        
        cell.lblTransactionNo.isHidden = true
        
        if obj.project_supervision_form_file_path != "" {
            cell.btnAction.isHidden = false
        }else{
            cell.btnAction.isHidden = true
        }
       
            let Numberattributed: NSAttributedString = Number.attributedStringWithColor(["#".localized()], color: maincolor)
            cell.lblNo.attributedText = Numberattributed
        
        
        let AttachmentsTitleattributed: NSAttributedString = AttachmentsTitle.attributedStringWithColor(["Attachments Title".localized()], color: maincolor)
        cell.lblUnit.attributedText = AttachmentsTitleattributed
       
            
        let Writerattributed: NSAttributedString = Writer.attributedStringWithColor(["Writer".localized()], color: maincolor)
            cell.lblWorklevel.attributedText = Writerattributed
            
            
            let Dateattributed: NSAttributedString = Date.attributedStringWithColor(["Date".localized()], color: maincolor)
            cell.lblEvaluationResult.attributedText = Dateattributed
            
        
        let FileSizeattributed: NSAttributedString = FileSize.attributedStringWithColor(["File Size".localized()], color: maincolor)
        cell.lblDate.attributedText = FileSizeattributed
        
        let AttachmentTypeattributed: NSAttributedString = AttachmentType.attributedStringWithColor(["Attachment Type".localized()], color: maincolor)
        cell.lblBarcode.attributedText = AttachmentTypeattributed
        
        
        
        cell.viewBack.setcorner()
        
        
        return cell
        
        
  
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let obj = arr_data[indexPath.item]
        if obj.project_supervision_form_file_path != "" {
        let vc:PDFViewrVC  = AppDelegate.mainSB.instanceVC()
           
        vc.isModalInPresentation = true
        //vc.modalPresentationStyle = .overFullScreen
        vc.definesPresentationContext = true
        vc.Strurl = obj.project_supervision_form_file_path
        self.present(vc, animated: true, completion: nil)
    }}
}
