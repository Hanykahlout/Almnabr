//
//  MailPageViewController.swift
//  Almnabr
//
//  Created by Hany Alkahlout on 25/10/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import UIKit

class MailPageViewController: UIPageViewController {
    
    private var containerVCs = [UIViewController]()
    override func viewDidLoad() {
        super.viewDidLoad()

        let inbox = storyboard?.instantiateViewController(withIdentifier: "InboxMailViewController") as! InboxMailViewController
        let starred = storyboard?.instantiateViewController(withIdentifier: "StarredMailViewController") as! StarredMailViewController
        let drafts = storyboard?.instantiateViewController(withIdentifier: "DraftsMailViewController") as! DraftsMailViewController
        let sent = storyboard?.instantiateViewController(withIdentifier: "SentMailViewController") as! SentMailViewController
        let spam = storyboard?.instantiateViewController(withIdentifier: "SpamMailViewController") as! SpamMailViewController
        
        let trash = storyboard?.instantiateViewController(withIdentifier: "TrashMailViewController") as! TrashMailViewController
        containerVCs.append(inbox)
        containerVCs.append(starred)
        containerVCs.append(drafts)
        containerVCs.append(sent)
        containerVCs.append(spam)
        containerVCs.append(trash)
        
        if let firstVC = containerVCs.first{
            setViewControllers([firstVC], direction: .forward, animated: true)
        }
    }

    
    func changeVC(index:Int,direction:UIPageViewController.NavigationDirection){
        setViewControllers([containerVCs[index]], direction: direction, animated: false)
    }

}
