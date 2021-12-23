//
//  SelectesUnits&levelsVC.swift
//  Almnabr
//
//  Created by MacBook on 09/12/2021.
//  Copyright © 2021 Samar Akkila. All rights reserved.
//

import UIKit

class SelectesUnits_levelsVC: UIViewController {

    @IBOutlet weak var table: UITableView!
    
    var arr_data:[project_supervision_form_unit_levelObj] = []
    
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
        self.view.backgroundColor = HelperClassSwift.acolor.getUIColor() //F0F4F8
        //navigationController?.navigationBar.barTintColor = .buttonBackgroundColor()
        navigationController?.navigationBar.barTintColor = HelperClassSwift.acolor.getUIColor()
       addNavigationBarTitle(navigationTitle: "Selected unites and levels".localized())
        UINavigationBar.appearance().backgroundColor = HelperClassSwift.acolor.getUIColor()
    }
    
    
    
    // MARK: - Setup Table
    
    func SetupTable(){
        
        table.dataSource = self
        table.delegate = self
        let nib = UINib(nibName: "GeneralNoCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: "GeneralNoCell")
        self.table.reloadData()
    }
}




extension SelectesUnits_levelsVC: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GeneralNoCell", for: indexPath) as! GeneralNoCell
        
        let obj = arr_data[indexPath.item]
        

        cell.lblNo.text = "\(indexPath.item + 1)"
        cell.lblUnit.text = obj.unit_id
        cell.lblWorklevels.text = obj.work_level_label
        cell.lblNo.font = .kufiRegularFont(ofSize: 17)
        cell.lblUnit.font = .kufiRegularFont(ofSize: 17)
        cell.lblWorklevels.font = .kufiRegularFont(ofSize: 17)

        cell.btnDelete.isHidden =  true
        
     

        return cell
        
    }
    
    
    
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
       
    }
    
    
}

