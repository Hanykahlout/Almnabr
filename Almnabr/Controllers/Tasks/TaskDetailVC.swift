//
//  TaskDetailVC.swift
//  Almnabr
//
//  Created by MacBook on 10/05/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import UIKit

class TaskDetailVC: UIViewController {
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var table_Activity: UITableView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_status: UILabel!
    @IBOutlet weak var lbl_status_done: UITextField!
    @IBOutlet weak var lbl_From: UITextField!
    @IBOutlet weak var lbl_To: UITextField!
    @IBOutlet weak var lbl_desc: UILabel!
    @IBOutlet weak var lbl_percentage: UITextField!
    @IBOutlet var tableHeight: NSLayoutConstraint!
    @IBOutlet var scroll: UIScrollView!
    
    @IBOutlet weak var txt_comment: UITextView!
    @IBOutlet weak var tableChecklist: UITableView!
    @IBOutlet weak var tableChecklistHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnAdd_comment: UIView! {
        didSet {
            btnAdd_comment.isHidden = false
        }
    }
    
    
    var object:TaskObj?
    var delegate : (() -> Void)?
    var task_id:String = ""
    var arr_statusDone :[importantObj] = []
    var arr_comments :[CommentObj] = []
    var arr_data:[PointTaskObj] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddBarButtonItem()
        configNavigation()
        get_data()
        get_Chicklist_data()
        get_add_task()
        get_comment_tasks()
        //        self.scroll.resizeScrollViewContentSize()
        scroll.delegate  = self
        table_Activity.dataSource = self
        table_Activity.delegate = self
        let nib = UINib(nibName: "TaskCommentCell", bundle: nil)
        table_Activity.register(nib, forCellReuseIdentifier: "TaskCommentCell")
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tableHeight?.constant = self.table_Activity.contentSize.height
        self.scroll.contentSize = CGSize(width: self.scroll.contentSize.width, height: self.table_Activity.contentSize.height + 500)
        //        self.scroll.resiz
        //        let contentHeight = scroll.contentSize.height
        //        self.scroll.contentSize = contentHeight
        //        + 400
        //        if arr_comments.count == 0 {
        //            self.tableHeight?.constant = 412
        //        }else{}
        
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
        addNavigationBarTitle(navigationTitle: "Task Details".localized())
        UINavigationBar.appearance().backgroundColor = maincolor
        
    }
    
    private func setUpTableView(){
        tableChecklist.dataSource = self
        tableChecklist.delegate = self
        tableChecklist.estimatedRowHeight = 100
        tableChecklist.rowHeight = UITableView.automaticDimension
        let nib = UINib(nibName: "CheckListCell", bundle: nil)
        tableChecklist.register(nib, forCellReuseIdentifier: "CheckListCell")
    }
    
    //    func setupAddButtonItem() {
    //      let DeleteButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(didTapEditButton(_:)))
    //
    //        let EditButton   = UIBarButtonItem(image: EditImage,  style: .plain, target: self, action: #selector(didTapEditButton(sender:)))
    //        navigationItem.rightBarButtonItems = [EditButton]
    //
    //
    //    }
    
    func setupAddBarButtonItem() {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus")!, for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(self.didTapAddButton(sender:)), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    
    @objc func didTapAddButton(sender: UIButton){
        let vc:AddChecklistVC  = AppDelegate.TicketSB.instanceVC()
        
        vc.isModalInPresentation = true
        vc.modalPresentationStyle = .overFullScreen
        vc.definesPresentationContext = true
        vc.task_id = self.task_id
        vc.delegate = {
            self.get_Chicklist_data()
        }
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    //MARK: - Config GUI
    //------------------------------------------------------
    func configGUI() {
        
        self.lbl_title.font = .kufiRegularFont(ofSize: 14)
        self.lbl_title.text = object?.title ?? "---"
        
        let Status = "Status".localized() + ": \(object?.status_name ?? "---")        "
        
        let Status_atr: NSAttributedString = Status.attributedStringWithColor(["Status".localized()], color: maincolor)
        self.lbl_status.attributedText = Status_atr
        self.lbl_status.font = .kufiRegularFont(ofSize: 14)
        
        let From = "From".localized() + ": \(object?.end_nearly ?? "---")"
        let From_atr: NSAttributedString = From.attributedStringWithColor(["From".localized()], color: maincolor)
        self.lbl_From.attributedText = From_atr
        self.lbl_From.font = .kufiRegularFont(ofSize: 11)
        
        let To = "To".localized() + ": \(object?.start_date ?? "--/--/--")"
        let To_atr: NSAttributedString = To.attributedStringWithColor(["To".localized()], color: maincolor)
        self.lbl_To.attributedText = To_atr
        self.lbl_To.font = .kufiRegularFont(ofSize: 11)
        
        let desc = "Description".localized() + "\n \(object?.task_detailes ?? "---")"
        let desc_atr: NSAttributedString = desc.attributedStringWithColor(["Description".localized()], color: maincolor)
        self.lbl_desc.attributedText = desc_atr
        self.lbl_desc.font = .kufiRegularFont(ofSize: 14)
        
        self.lbl_percentage.text = object?.progres
        
        self.lbl_status_done.text = object?.status_done_name
        self.lbl_status_done.font = .kufiRegularFont(ofSize: 13)
        
        txt_comment.delegate = self
        
        txt_comment.text = "comment".localized()
        txt_comment.font = .kufiRegularFont(ofSize: 14)
        txt_comment.textColor = .lightGray
        
    }
    
    
    func get_Chicklist_data(){
        
        self.showLoadingActivity()
        let param :[String:Any] = ["task_id" : task_id]
        
        APIManager.sendRequestPostAuth(urlString: "tasks/get_points_task_main", parameters: param ) { (response) in
            self.arr_data.removeAll()
            let status = response["status"] as? Bool
            if status == true{
                if  let records = response["data"] as? NSArray{
                    for i in records {
                        let dict = i as? [String:Any]
                        let obj =  PointTaskObj.init(dict!)
                        self.arr_data.append(obj)
                    }
                    self.tableChecklistHeight.constant = CGFloat(records.count) * 70
                    self.tableChecklist.reloadData()
                    self.hideLoadingActivity()
                }
                
            }else{
                self.hideLoadingActivity()
            }
        }
    }
    
    
    func get_data(){
        
        self.showLoadingActivity()
        
        let param:[String:Any] = ["task_id" : self.task_id]
        APIManager.sendRequestPostAuth(urlString: "tasks/get_task_only", parameters: param ) { (response) in
            self.hideLoadingActivity()
            
            let status = response["status"] as? Bool
            
            if status == true{
                
                if  let data = response["data"] as? [String:Any]{
                    
                    let obj =  TaskObj(data)
                    self.object = obj
                }
                self.configGUI()
                self.hideLoadingActivity()
                
            }else{
                self.hideLoadingActivity()
            }
        }
    }
    
    func get_comment_tasks(){
        
        self.showLoadingActivity()
        
        let param:[String:Any] = ["task_id" : self.task_id]
        APIManager.sendRequestPostAuth(urlString: "tasks/get_comment_tasks", parameters: param ) { (response) in
            self.hideLoadingActivity()
            
            let status = response["status"] as? Bool
            self.arr_comments.removeAll()
            if status == true{
                if  let records = response["data"] as? NSArray{
                    for i in records {
                        let dict = i as? [String:Any]
                        let obj =  CommentObj.init(dict!)
                        self.arr_comments.append(obj)
                    }
                    self.table_Activity.reloadData()
                    self.hideLoadingActivity()
                    
                }else{
                    self.hideLoadingActivity()
                }
            }
        }
        
    }
    
    func get_add_task(){
        
        self.showLoadingActivity()
        
        APIManager.sendRequestPostAuth(urlString: "tasks/get_add_task", parameters: [:] ) { (response) in
            self.hideLoadingActivity()
            let status = response["status"] as? Bool
            
            if status == true{
                
                if let data = response["data"] as? [String:Any] {
                    
                    
                    if  let status_done = data["task_status_done"] as? NSArray{
                        for i in status_done {
                            let dict = i as? [String:Any]
                            let obj = importantObj.init(dict!)
                            self.arr_statusDone.append(obj)
                        } }
                    
                }
            }else{
                self.hideLoadingActivity()
            }
            
            
        }
    }
    
    func change_status(task_id:String, status:String){
        
        self.showLoadingActivity()
        let param :[String:Any] = ["task_id" : task_id,"status":status]
        
        APIManager.sendRequestPostAuth(urlString: "tasks/change_status_done", parameters: param ) { (response) in
            self.hideLoadingActivity()
            
            let status = response["status"] as? Bool
            if status == true{
                // self.get_data()
                self.hideLoadingActivity()
            }else{
                self.hideLoadingActivity()
                
            }
        }
    }
    
    
    func delete_task(task_id:String){
        
        self.showLoadingActivity()
        let param :[String:Any] = ["task_id" : task_id]
        
        APIManager.sendRequestPostAuth(urlString: "tasks/delete_task", parameters: param ) { (response) in
            self.hideLoadingActivity()
            
            let status = response["status"] as? Bool
            let message = response["message"] as? String
            if status == true{
                self.hideLoadingActivity()
                self.showAMessage(withTitle: "", message: message ?? "Deletion process has been successful", completion: {
                    self.delegate!()
                    self.navigationController?.popViewController(animated: true)
                })
            }else{
                self.hideLoadingActivity()
                
            }
        }
    }
    
    
    
    func delete_comment(comment_id:String){
        
        self.showLoadingActivity()
        let param :[String:Any] = ["comment_id" : comment_id]
        
        APIManager.sendRequestPostAuth(urlString: "tasks/delete_comment_reply", parameters: param ) { (response) in
            self.hideLoadingActivity()
            
            let status = response["status"] as? Bool
            let message = response["message"] as? String
            if status == true{
                self.hideLoadingActivity()
                self.showAMessage(withTitle: "", message: message ?? "Deletion process has been successful", completion: {
                    self.get_comment_tasks()
                })
            }else{
                self.hideLoadingActivity()
                
            }
        }
    }
    
    func Add_comment(title:String){
        
        self.showLoadingActivity()
        
        let param : [String:Any] = ["task_id" : self.task_id,
                                    "notes" : title]
        APIManager.sendRequestPostAuth(urlString: "tasks/add_comment_task", parameters: param ) { (response) in
            self.hideLoadingActivity()
            
            let status = response["status"] as? Bool
            //            let message = response["message"] as? String
            
            if status == true{
                
                self.get_comment_tasks()
                self.txt_comment.text = "comment".localized()
                //                if let return_row = response["return_row"] as? [String:Any]{
                //                    let obj = CommentObj(return_row)
                //                    self.arr_comments.append(obj)
                //                    self.table_Activity.reloadData()
                //                }
                //                    self.showAMessage(withTitle: "", message: message,  completion: {
                //                        self.delegate!()
                //                        self.dismiss(animated: true)
                //                    })
                
            }else{
                if let message = response["message"] as? String {
                    self.showAMessage(withTitle: "error".localized(), message:  message)
                }else{
                    self.showAMessage(withTitle: "error".localized(), message:  "something went wrong")
                }
            }
            self.hideLoadingActivity()
            
        }
    }
    
    
    @IBAction func deleteAction(_ sender: Any) {
        delete_task(task_id: self.task_id)
    }
    
    
    @IBAction func btnAttachments_Click(_ sender: Any) {
        
        let vc:TaskAttachmentVC = AppDelegate.TicketSB.instanceVC()
        vc.is_from_task = true
        vc.arr_data = object?.files ?? []
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnCheckList_Click(_ sender: Any) {
                let vc:CheckListVC = AppDelegate.TicketSB.instanceVC()
                //        vc.is_from_task = true
                vc.task_id = self.task_id
                self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btnMembers_Click(_ sender: Any) {
        
        let vc:TaskUsersVC  = AppDelegate.TicketSB.instanceVC()
        
        vc.isModalInPresentation = true
        vc.modalPresentationStyle = .overFullScreen
        vc.definesPresentationContext = true
        vc.task_id = self.task_id
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func btnHistory_Click(_ sender: Any) {
        let vc:TaskHistoryVC = AppDelegate.TicketSB.instanceVC()
        vc.is_from_task = true
        vc.task_id = self.task_id
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnStatusDonne_Click(_ sender: Any) {
        let vc :PickerVC = AppDelegate.mainSB.instanceVC()
        vc.arr_data =  arr_statusDone.map({"\($0.name)"})
        vc.isModalInPresentation = true
        vc.modalPresentationStyle = .overFullScreen
        vc.definesPresentationContext = true
        vc.delegate = {name , index in
            self.lbl_status_done.text = name
            let status = self.arr_statusDone[index].id
            self.change_status(task_id: self.task_id, status: status)
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnAddComment_Click(_ sender: Any) {
        
        guard txt_comment.text != "comment" else {
            return self.showAMessage(withTitle: "", message: "Comment Field Required!")
        }
        
        self.Add_comment(title: txt_comment.text!)
    }
    
    
    func delete_item(point_id:String){
        
        self.showLoadingActivity()
        let param :[String:Any] = ["point_id" : point_id]
        
        APIManager.sendRequestPostAuth(urlString: "tasks/delete_task_point_main", parameters: param ) { (response) in
            self.hideLoadingActivity()
           
            let status = response["status"] as? Bool
            if status == true{
                self.get_data()
             
            }else{
                self.hideLoadingActivity()
              
            }
        }
    }

    
    
    func change_task_point(point_id:String){
        
        self.showLoadingActivity()
        let param :[String:Any] = ["point_id" : point_id]
        
        APIManager.sendRequestPostAuth(urlString: "tasks/change_task_point", parameters: param ) { (response) in
            self.hideLoadingActivity()
           
            let status = response["status"] as? Bool
            if status == true{
                self.get_data()
             
            }else{
                self.hideLoadingActivity()
              
            }
        }
    }
    
    func CommentMenu() -> UIMenu {
        
        let Reply = UIAction(title: "Reply") { _ in
            // self.btnChangeStatusAction!(self.task_id, 1)
        }
        let Edit = UIAction(title: "Edit") { _ in
            //  self.btnChangeStatusAction!(self.task_id, 2)
        }
        let Delete = UIAction(title: "Delete") { _ in
            // self.btnChangeStatusAction!(self.task_id, 3)
        }
        return UIMenu(title: "", children: [Reply, Edit, Delete])
    }
    
    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        return topMostViewController
    }
    
}


extension TaskDetailVC: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableChecklist{
            return arr_data.count
        }
        return arr_comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableChecklist{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckListCell", for: indexPath) as! CheckListCell
            
            let obj = arr_data[indexPath.item]
            
            cell.arr_data = obj.sub_checks
            cell.lblTitle.text = obj.title
            cell.lblPercent.text = obj.progres + "%"
            
            let value = Float(obj.progres) ?? 0.0
            cell.setUpTable()
            cell.Progress.progress = value / 100.0
            
            cell.dropView.isHidden = obj.isHidden
            if obj.isHidden {
                
                let img  = UIImage.fontAwesomeIcon(name: .chevronDown , style: .solid, textColor:  .darkGray, size: CGSize(width: 15, height: 15))
                
                cell.dropImg.setImage(img, for: .normal)
            }else{
                
                let img  = UIImage.fontAwesomeIcon(name: .chevronUp , style: .solid, textColor:  .darkGray, size: CGSize(width: 15, height: 15))
                
                cell.dropImg.setImage(img, for: .normal)
            }
            if Auth_User.user_id == obj.user_add_id {
                cell.deleteBtn.isHidden = false
            }else{
                cell.deleteBtn.isHidden = true
            }
            
            cell.btnDeleteAction = {
                self.delete_item(point_id: obj.check_id)
            }
            
            cell.btnAddItemAction = {
                
                let vc:AddPointVC  = AppDelegate.TicketSB.instanceVC()
                vc.point_id = obj.check_id
                vc.delegate = {
                    self.get_data()
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
            cell.btnCheckAction = { point_id in
                self.change_task_point(point_id: point_id)
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCommentCell", for: indexPath) as! TaskCommentCell
            
            let obj = arr_comments[indexPath.item]
            cell.arr_reply = obj.reply
            cell.lblDate.text = obj.insert_date
            cell.lblUserName.text = obj.emp_name
            cell.lblComment.text = obj.notes_history
            cell.setUpTable()
            cell.btnView_reply.titleLabel?.font = .kufiRegularFont(ofSize: 11)
            cell.dropView.isHidden = obj.isHidden
            if obj.isHidden {
                cell.btnView_reply.setUnderLine(stringValue: "view replys", withTextSize: 12)
            }else{
                cell.btnView_reply.setUnderLine(stringValue: "Hide replys", withTextSize: 12)
                
            }
            if obj.reply.count == 0{
                cell.btnView_reply.isHidden = true
            }else{
                cell.btnView_reply.isHidden = false
            }
            cell.btnViewReplyAction = {
                //            let obj = arr_comments[indexPath.item]
                obj.isHidden = !(obj.isHidden )
                self.table_Activity.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                
            }
            //    if obj.can_delete == false{
            //        cell.btnDelete.isHidden = true
            //    }
            
            //    if obj.can_edit == false{
            //        cell.btnEdit.isHidden = true
            //    }
            
            self.viewWillLayoutSubviews()
            cell.btnDeleteReplyAction = { comment_id in
                self.delete_comment(comment_id: comment_id)
            }
            cell.btnEditReplyAction = {  comment_id , comment  in
                
                let vc:AddCommentVC  = AppDelegate.TicketSB.instanceVC()
                
                vc.isModalInPresentation = true
                vc.modalPresentationStyle = .overFullScreen
                vc.definesPresentationContext = true
                vc.comment_id = comment_id
                vc.comment =  comment
                vc.delegate = {
                    self.get_comment_tasks()
                }
                self.present(vc, animated: true, completion: nil)
                
            }
            
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tableChecklist{
            return 100
        }else{
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableChecklist{
            
            
    //        guard let expandableItem = arr_data[indexPath.item] else {return}
            
            
            let obj = arr_data[indexPath.item]
            obj.isHidden = !(obj.isHidden )
            tableChecklist.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    //        let vc:SubTaskListVC = AppDelegate.TicketSB.instanceVC()
    //        vc.str_title = obj.title
    //        vc.task_id = self.task_id
    //        vc.arr_data = obj.sub_checks
    //        self.navigationController?.pushViewController(vc, animated: true)
            
        }else{
            let obj = arr_comments[indexPath.item]
            //        cell.btn_changeStatus.menu = self.DoneMenu()
            //        cell.btn_changeStatus.showsMenuAsPrimaryAction = true
            // create the alert
            //                let alert = UIAlertController(title: "", message: "Choose Action", preferredStyle: UIAlertController.Style.alert)
            //
            //        // add the actions (buttons)
            //        alert.addAction(UIAlertAction(title: "Reply", style: UIAlertAction.Style.default, handler: nil))
            //        alert.addAction(UIAlertAction(title: "Edit", style: UIAlertAction.Style.default, handler: nil))
            //        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: nil))
            //        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            
            
            // Create you actionsheet - preferredStyle: .actionSheet
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            // Create your actions - take a look at different style attributes
            let ReplyAction = UIAlertAction(title: "Reply", style: .default) { (action) in
                
                let vc:AddCommentVC  = AppDelegate.TicketSB.instanceVC()
                
                vc.isModalInPresentation = true
                vc.modalPresentationStyle = .overFullScreen
                vc.definesPresentationContext = true
                vc.comment_id = obj.history_id
                //            vc.comment =  obj.notes_history
                vc.header = "Add Reply".localized()
                vc.title_str = "reply".localized()
                vc.type = "reply"
                vc.task_id = self.task_id
                vc.delegate = {
                    self.get_comment_tasks()
                }
                self.present(vc, animated: true, completion: nil)
                
            }
            let EditAction = UIAlertAction(title: "Edit", style: .default) { (action) in
                
                let vc:AddCommentVC  = AppDelegate.TicketSB.instanceVC()
                
                vc.isModalInPresentation = true
                vc.modalPresentationStyle = .overFullScreen
                vc.definesPresentationContext = true
                vc.comment_id = obj.history_id
                vc.comment =  obj.notes_history
                vc.delegate = {
                    self.get_comment_tasks()
                }
                self.present(vc, animated: true, completion: nil)
                
            }
            
            let DeleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
                self.delete_comment(comment_id: obj.history_id)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                print("didPress cancel")
            }
            
            // Add the actions to your actionSheet
            actionSheet.addAction(ReplyAction)
            
            actionSheet.addAction(cancelAction)
            
            if obj.emp_id == Auth_User.user_id {
                actionSheet.addAction(EditAction)
                actionSheet.addAction(DeleteAction)
            }
            
            
            guard let top_vc = HeaderView.shared.menu_vc() else { return }
            // show the alert
            
            DispatchQueue.main.async(execute: {
                // top_vc.present(alert, animated: true, completion: nil)
                top_vc.present(actionSheet, animated: true, completion: nil)
            })
            
            //        guard didLoadHome else { return }
            //
            //        let vc: NotificationVC = AppDelegate.mainSB.instanceVC()
            
            //top_vc.navigationController?.pushViewController(vc, animated: true)
            
            
            //     let alert = UIAlertController(title: " ", message: " ", preferredStyle: .alert)
            //        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
            //            switch action.style{
            //                case .default:
            //                print("default")
            //
            //                case .cancel:
            //                print("cancel")
            //
            //                case .destructive:
            //                print("destructive")
            //
            //            @unknown default:
            //                print("destructive")
            //            }
            //        }))
            //        DispatchQueue.main.async(execute: {
            //            self.present(alert, animated: true, completion: nil)
            //   })
            
        }
    }
    
}



extension TaskDetailVC: UITextViewDelegate {
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txt_comment.textColor == .lightGray {
            txt_comment.text = ""
            txt_comment.textColor = .darkGray
            txt_comment.font = .kufiRegularFont(ofSize: 15)
            
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if txt_comment.text == "" {
            
            txt_comment.text = "comment".localized()
            txt_comment.font = .kufiRegularFont(ofSize: 15)
            txt_comment.textColor = .lightGray
        }
        
    }
    
    
}


extension UIScrollView {
    
    func resizeScrollViewContentSize() {
        
        var contentRect = CGRect.zero
        
        for view in self.subviews {
            
            contentRect = contentRect.union(view.frame)
            
        }
        
        self.contentSize = contentRect.size
        
    }
    
}
