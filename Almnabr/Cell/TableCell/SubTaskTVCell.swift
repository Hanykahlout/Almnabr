//
//  SubTaskTVCell.swift
//  Almnabr
//
//  Created by MacBook on 15/05/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import UIKit

class SubTaskTVCell: UITableViewCell , UICollectionViewDataSource , UICollectionViewDelegate{

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var viewBack: UIView!
    
    var arr_user:[ProfileObj] = []
    
    var btnCheckAction : (()->())?
    var btnDeleteAction : (()->())?
    var btnDownloadAction : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        
//        viewBack.layer.shadowColor = UIColor.systemGray.cgColor
//        viewBack.layer.shadowOpacity = 0.5
//        viewBack.layer.shadowOffset = .zero
//        viewBack.layer.shadowRadius = 4
//        viewBack.layer.cornerRadius = 10
        
        let nib = UINib(nibName: "TaskUsersCVCell", bundle: nil)
        collection.register(nib, forCellWithReuseIdentifier: "TaskUsersCVCell")
        
        self.collection.reloadData()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didDownloadButtonPressd(_ sender: Any) {
        btnDownloadAction!()
    }
    
    @IBAction func didDeleteButtonPressd(_ sender: Any) {
        btnDeleteAction!()
    }
    
    @IBAction func didCheckButtonPressd(_ sender: Any) {
        btnCheckAction!()
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
            return arr_user.count
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaskUsersCVCell", for: indexPath) as! TaskUsersCVCell
        
            //let arr = arr_user.map({"\($0.label)"})
        cell.lblTitle.text = arr_user[indexPath.row].username
          //  cell.viewBack.setBorderWithColor("458FB8".getUIColor())
            cell.lblTitle.font = .kufiRegularFont(ofSize: 10)
       // cell.img_user.image = .
            
            return cell
      
    }
    
    
}


