//
//  TaskAttachmentVC.swift
//  Almnabr
//
//  Created by MacBook on 25/04/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import UIKit

class TaskAttachmentVC: UIViewController {

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var img_nodata: UIImageView!
  
  
    var arr_data:[DocumentObj] = []
    var ticket_id:String = ""
    var is_from_task :Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configNavigation()
        configGUI()
        
        if is_from_task == true {
            self.table.reloadData()
            setupAddButtonItem()
            if arr_data.count == 0 {
                self.img_nodata.isHidden = false
            }else{
                self.img_nodata.isHidden = true
            }
        }else{
            get_data()
        }
        
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
       addNavigationBarTitle(navigationTitle: "Attachments".localized())
        UINavigationBar.appearance().backgroundColor = maincolor
    }
    func setupAddButtonItem() {
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped(_:)))
        navigationItem.rightBarButtonItem = addButtonItem
    }
    

    
    //MARK: - Config GUI
    //------------------------------------------------------
    func configGUI() {
        table.dataSource = self
        table.delegate = self
        let nib = UINib(nibName: "TaskAttachmentCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: "TaskAttachmentCell")
        
    }



    
    @objc func addTapped(_ sender: Any) {
      
    }
    
    func get_data(){
        
        self.showLoadingActivity()
        let param :[String:Any] = ["ticket_id" : ticket_id]
        APIManager.sendRequestPostAuth(urlString: "tasks/get_files_in_ticket", parameters: param ) { (response) in
            self.arr_data.removeAll()
            let status = response["status"] as? Bool
            if status == true{
                if  let records = response["files"] as? NSArray{
                    for i in records {
                        let dict = i as? [String:Any]
                        let obj =  DocumentObj.init(dict!)
                        self.arr_data.append(obj)
                    }
                    if records.count == 0 {
                        self.img_nodata.isHidden = false
                    }else{
                        self.img_nodata.isHidden = true
                    }
                    self.table.reloadData()
                    self.hideLoadingActivity()
                }
                
            }else{
                self.hideLoadingActivity()
                self.img_nodata.isHidden = false
            }
            
          
            
        }
    }
    
    func Delete_attachment(id:String){
        
        self.showLoadingActivity()
        let param :[String:Any] = ["file_id" : id]
        APIManager.sendRequestPostAuth(urlString: "tasks/delete_file_ticket", parameters: param ) { (response) in
            let status = response["status"] as? Bool
            if status == true{
                self.get_data()
                //self.showAMessage(withTitle: "success", message: "The notification was deleted successfully")
            }else{
                self.showAMessage(withTitle: "error", message: "The attachment wasn't  deleted ")
            }
            
            
            self.hideLoadingActivity()
            // self.lblnodata.isHidden = false
        }
    }
    
        
    
   
    
}


extension TaskAttachmentVC: UITableViewDelegate , UITableViewDataSource{

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arr_data.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "TaskAttachmentCell", for: indexPath) as! TaskAttachmentCell
    
    let obj = arr_data[indexPath.item]
    
 
    cell.lblname.text = obj.file_name_en
    cell.lblType.text = obj.file_extension
    cell.lblDate.text = obj.insert_date
    
    cell.btnDeleteAction = {
        self.Delete_attachment(id: obj.file_records_id)
    }
    
  
    return cell
    
}

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let obj = arr_data[indexPath.item]
        if obj.file_path != "" {
            let vc:PDFViewrVC  = AppDelegate.mainSB.instanceVC()
            vc.isModalInPresentation = true
            vc.definesPresentationContext = true
            vc.Strurl = obj.file_path
            self.present(vc, animated: true, completion: nil)
        }
        
    }

}


