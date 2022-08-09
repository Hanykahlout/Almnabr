//
//  CheckListCell.swift
//  Almnabr
//
//  Created by MacBook on 14/05/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import UIKit

class CheckListCell: UITableViewCell ,UITableViewDataSource,UITableViewDelegate{
    
    
    @IBOutlet weak var viewItemsButton: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPercent: UILabel!
    @IBOutlet weak var Progress: UIProgressView!
    @IBOutlet weak var viewBack: UIView!
    
    
    @IBOutlet weak var addItemBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    @IBOutlet weak var containerStack: UIStackView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var itemTable: UITableView!
    @IBOutlet weak var dropView: UIView! {
        didSet {
            dropView.isHidden = true
        }
    }
    
    
    var btnDeleteAction : (()->())?
    var btnAddItemAction : (()->())?
    var viewSelectedItemsAction : (()->())?
    //    var delegate : ((_ name: String ,_ index:Int) -> Void)?
    var arr_data:[SubCheckObj] = []
    var hideSelectedItems = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        setUpTable()
        
        containerStack.layer.shadowColor = UIColor.systemGray.cgColor
        containerStack.layer.shadowOpacity = 0.4
        containerStack.layer.shadowOffset = .zero
        containerStack.layer.shadowRadius = 2
        containerStack.layer.cornerRadius = 10
        
        
        
        
        self.deleteBtn.titleLabel?.font = .kufiRegularFont(ofSize: 13)
        self.addItemBtn.titleLabel?.font = .kufiRegularFont(ofSize: 13)
        
        //Progress.progress = 0.0
        // self.Progress.progress = 100.0
    }
    
    
    func setUpTable(){
        itemTable.dataSource = self
        itemTable.delegate = self
        
        let nib = UINib(nibName: "SubTaskTVCell", bundle: nil)
        itemTable.register(nib, forCellReuseIdentifier: "SubTaskTVCell")
        
        tableHeight.constant = CGFloat((hideSelectedItems ? arr_data.filter({$0.is_done == "1"}).count :arr_data.count) * 51 )
        
        self.itemTable.setNeedsLayout()
        
        self.itemTable.reloadData()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    @IBAction func didTapDelete(_ sender: AnyObject) {
        btnDeleteAction!()
    }
    
    
    @IBAction func didTapAddItem(_ sender: AnyObject) {
        btnAddItemAction!()
    }
    
    
    @IBAction func viewSelectedItems(_ sender: Any) {
        self.viewSelectedItemsAction?()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return arr_data[indexPath.item].is_done == "2" && hideSelectedItems ? 0 : 51
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubTaskTVCell", for: indexPath) as! SubTaskTVCell
        
        let obj = arr_data[indexPath.item]
        
        cell.lblTitle.text = obj.notes
        cell.lblDate.text =  "End Date:" + "\(obj.end_date)"
        cell.btnDownloadAction = {
            
            //            let path = obj.files[0].path
            //            if path != "" {
            //                let vc:PDFViewrVC  = AppDelegate.mainSB.instanceVC()
            //                vc.isModalInPresentation = true
            //                vc.definesPresentationContext = true
            //                vc.Strurl = path
            //                self.present(vc, animated: true, completion: nil)
            //            }
        }
        
        cell.arr_user = obj.users
        
        let point_id = obj.point_id
        
        if obj.is_done == "1"{
            print("not Check")
            cell.btnCheck.setImage(UIImage(systemName: "square"), for: .normal)
        }else{
            print("Check")
            cell.btnCheck.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        }
        
        cell.btnCheckAction = {
            self.showLoadingActivity()
            let param :[String:Any] = ["point_id" : obj.check_id]
            
            APIManager.sendRequestPostAuth(urlString: "tasks/change_task_point", parameters: param ) { (response) in
                self.hideLoadingActivity()
                
                let status = response["status"] as? Bool
                if status == true{
                    cell.btnCheck.setImage(obj.is_done == "1" ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square"), for: .normal)
                    
                    self.arr_data[indexPath.row].is_done = obj.is_done == "1" ? "2" : "1"
                }
                self.hideLoadingActivity()
            }
            
            //            self.btnCheckAction!(obj.check_id)
            //            if obj.is_done == "2"{
            //                print("not Check")
            //                self.showLoadingActivity()
            //
            //                APIManager.sendRequestPostAuth(urlString: "tasks/change_task_point", parameters: ["point_id" : point_id]  ) { (response) in
            //                    let status = response["status"] as? Bool
            //                    if status == true{
            //                        cell.btnCheck.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            //                        obj.is_done = "1"
            //                         self.hideLoadingActivity()
            //                    }else{
            //                        cell.btnCheck.setImage(UIImage(systemName: "square"), for: .normal)
            //                        self.hideLoadingActivity()
            //                        obj.is_done = "2"
            //
            //                       } }
            //
            //
            //
            //            }else{
            //                print("Check")
            //                self.showLoadingActivity()
            //                APIManager.sendRequestPostAuth(urlString: "tasks/change_task_point", parameters: ["point_id" : point_id]  ) { (response) in
            //                    let status = response["status"] as? Bool
            //                    if status == true{
            //                        cell.btnCheck.setImage(UIImage(systemName: "square"), for: .normal)
            //                        obj.is_done = "2"
            //                        self.hideLoadingActivity()
            //                    }else{
            //                        cell.btnCheck.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            //                        obj.is_done = "1"
            //                         self.hideLoadingActivity()
            //
            //                       } }}
            
        }
        
        cell.btnDeleteAction = {
            self.showLoadingActivity()
            APIManager.sendRequestPostAuth(urlString: "tasks/delete_task_point", parameters: ["point_id" : point_id]  ) { (response) in
                let status = response["status"] as? Bool
                let message = response["message"] as? String
                if status == true{
                    self.arr_data.remove(at: indexPath.item)
                    self.itemTable.reloadData()
                    self.hideLoadingActivity()
                }else{
                    Auth_User.topVC()!.showAMessage(withTitle: "error", message: message ?? "try again")
                    self.hideLoadingActivity()
                }
            }
        }
        return cell
    }
    
    
}
