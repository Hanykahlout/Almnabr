//
//  ViewEmployeeDetailsVC.swift
//  Almnabr
//
//  Created by Hany Alkahlout on 12/06/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import UIKit
import MOLH
class ViewEmployeeDetailsVC: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mainView: UIView!

    public var empImageString = ""
    private var pageController:ViewEmployeePageVC!
    private var data = [SectionInfo]()
    
    @IBOutlet weak var forwordImageView: UIImageView!
    @IBOutlet weak var reverseImageView: UIImageView!
    var empId = ""
    private var selectedIndex = 0
    public static var empData = EmpViewResponse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        intilization()
    }

    
    private func intilization(){
        setUpCollectionView()
        setCollectionData()
        if MOLHLanguage.currentAppleLanguage() == "ar"{
            backButton.transform = .init(rotationAngle: .pi)
            forwordImageView.transform = .init(rotationAngle: .pi)
            reverseImageView.transform = .init(rotationAngle: .pi)
            data = data.reversed()
            collectionView.reloadData()
        }
        getEmployeeViewData()
    }
    
  
    
    
    private func setUpPageViewController(){
        pageController = storyboard?.instantiateViewController(withIdentifier: "ViewEmployeePageVC") as? ViewEmployeePageVC
        addChild(pageController)
        pageController.didMove(toParent: self)
        
        pageController.view.translatesAutoresizingMaskIntoConstraints = false
        
        mainView.addSubview(pageController.view)

        mainView.leadingAnchor.constraint(equalTo: pageController.view.leadingAnchor, constant: 0).isActive = true
        mainView.trailingAnchor.constraint(equalTo: pageController.view.trailingAnchor, constant: 0).isActive = true
        mainView.topAnchor.constraint(equalTo: pageController.view.topAnchor, constant: 0).isActive = true
        mainView.bottomAnchor.constraint(equalTo: pageController.view.bottomAnchor, constant: 0).isActive = true
    }
    
    
    
    private func setCollectionData(){
        data.append(.init(bgColor: UIColor(named: "AppColor")!, icon: UIImage(systemName: "person.fill")!, title: "ID Details"))
        data.append(.init(bgColor: UIColor.black, icon: UIImage(systemName: "doc.on.doc")!, title: "Contract Details"))
        data.append(.init(bgColor: UIColor.black, icon: UIImage(systemName: "doc.on.doc")!, title: "Joining Details"))
        data.append(.init(bgColor: UIColor.black, icon: UIImage(systemName: "bag.fill")!, title: "Jop Details"))
        data.append(.init(bgColor: UIColor.black, icon: UIImage(systemName: "link.circle.fill")!, title: "Communications"))
        data.append(.init(bgColor: UIColor.black, icon: UIImage(systemName: "person.2.fill")!, title: "Contact Details"))
        data.append(.init(bgColor: UIColor.black, icon: UIImage(systemName: "building.columns.fill")!, title: "Bank Details"))
        data.append(.init(bgColor: UIColor.black, icon: UIImage(systemName: "book.closed.fill")!, title: "Education Details"))
        data.append(.init(bgColor: UIColor.black, icon: UIImage(systemName: "airplane")!, title: "Passport Details"))
        data.append(.init(bgColor: UIColor.black, icon: UIImage(systemName: "building.2")!, title: "Insurance Details"))
        data.append(.init(bgColor: UIColor.black, icon: UIImage(systemName: "person.text.rectangle.fill")!, title: "lang_vacations"))
        
        data.append(.init(bgColor: UIColor.black, icon: UIImage(systemName: "note.text")!, title: "Notes"))
        
        data.append(.init(bgColor: UIColor.black, icon: UIImage(named: "attach-icon")!, title: "Attachments"))
        
        data.append(.init(bgColor: UIColor.black, icon: UIImage(systemName: "person.text.rectangle.fill")!, title: "Modules"))
        
        data.append(.init(bgColor: UIColor.black, icon: UIImage(systemName: "dollarsign.circle.fill")!, title: "lang_finanial_details"))
        
        data.append(.init(bgColor: UIColor.black, icon: UIImage(systemName: "calendar")!, title: "lang_calender_view"))

    }
    
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func forwordAction(_ sender: Any) {
        if selectedIndex < data.count - 1{
            selectedIndex += 1
        }
        let lang = MOLHLanguage.currentAppleLanguage()
        pageController.changeVC(index: selectedIndex, direction: lang == "en" ? .forward : .reverse)
        let index = lang == "en" ? selectedIndex : (data.count - 1) - selectedIndex
        goToSelectedCell(indexPath: IndexPath(row: index, section: 0))
        
    }
    
    
    @IBAction func reverseAction(_ sender: Any) {
        if selectedIndex > 0{
            selectedIndex -= 1
        }
        let lang = MOLHLanguage.currentAppleLanguage()
        pageController.changeVC(index: selectedIndex, direction: lang == "en" ? .reverse : .forward)
        let index = lang == "en" ? selectedIndex : (data.count - 1) - selectedIndex
        goToSelectedCell(indexPath: IndexPath(row: index , section: 0))
    }
    
}


extension ViewEmployeeDetailsVC: UICollectionViewDelegate , UICollectionViewDataSource {
    private func setUpCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(.init(nibName: "SectionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SectionCollectionViewCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionCollectionViewCell", for: indexPath) as! SectionCollectionViewCell
        cell.setData(data: data[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        goToSelectedCell(indexPath: indexPath)
        let oldIndex = selectedIndex
        selectedIndex = indexPath.row
        pageController.changeVC(index: MOLHLanguage.currentAppleLanguage() == "en" ? selectedIndex : (data.count - 1) - selectedIndex , direction: oldIndex < selectedIndex ? .forward : .reverse)
        
    }
    
    
    private func goToSelectedCell(indexPath:IndexPath){
        for index in 0..<data.count{
            if index == indexPath.row{
                data[index].bgColor = UIColor(named: "AppColor")!
            }else{
                data[index].bgColor = UIColor.black
            }
        }
        
        collectionView.reloadData()
        collectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally], animated: false)
    }
    

}

// MARK: - API Handling

extension ViewEmployeeDetailsVC{
    
    private func getEmployeeViewData(){
        showLoadingActivity()
        APIController.shard.getEmployeeViewData(empId: empId) { data in
            self.hideLoadingActivity()
            if let status = data.status,status{
                ViewEmployeeDetailsVC.empData = data
                DispatchQueue.main.async {
                    self.setUpPageViewController()
                }
            }
        }
    }
}
