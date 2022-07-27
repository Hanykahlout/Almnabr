//
//  VactionPageViewController.swift
//  Almnabr
//
//  Created by Hany Alkahlout on 24/07/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import UIKit


class VactionPageViewController: UIPageViewController {
    
    
    var containerVCs = [UIViewController]()
    var currentIndex = 0
    
    private var vactionDetailsVC:VactionDetailsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vactionDetailsVC = VactionDetailsViewController()
        
        containerVCs.append(vactionDetailsVC)
    
        if let firstVC = containerVCs.first{
            setViewControllers([firstVC], direction: .forward, animated: true)
        }
        
    }
    
    
    func changeVC(direction:UIPageViewController.NavigationDirection){
        guard currentIndex >= 0 else { return }
        let vc = containerVCs[currentIndex]
        setViewControllers([vc], direction: direction, animated: true)
    }
    
    func setVactionDetailsData(data:FormHrv1VacationData?){
        vactionDetailsVC.setData(data: data)
    }

}
