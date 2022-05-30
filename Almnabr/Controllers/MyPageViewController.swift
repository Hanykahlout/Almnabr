//
//  MyPageViewController.swift
//  Almnabr
//
//  Created by MacBook on 06/11/2021.
//  Copyright © 2021 Samar Akkila. All rights reserved.
//

import UIKit

class MyPageViewController: UIPageViewController {
    
    var pages = [UIViewController]()
    var newIndex = 1
    
    private var currentPageIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
       
        self.isPagingEnabled = false
        
        let page1: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "FromTransactionVC")
        let page2: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "TeamUserVC")
        
        let page3: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "ContactsVC")
        let page4: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "DocumentsVC")
        
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        pages.append(page4)
        
        setViewControllers([page1], direction: .forward, animated: false, completion: nil)
        
        pager_observer()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //  displayPageForIndex(index: newIndex, animated: true)
    }
    
    
    private func pager_observer(){
        NotificationCenter.default.addObserver(forName: NSNotification.Name("Change_Page"), object: nil, queue: .main) { notifi in
            guard let index = notifi.object as? Int else { return }
            self.displayPageForIndex(index: index)
        }
    }
    
    func displayPageForIndex(index: Int, animated: Bool = true) {
        assert(index >= 0 && index < self.pages.count, "Error: Attempting to display a page for an out of bounds index")
        
        
        // nop if index == self.currentPageIndex
        if self.currentPageIndex == index { return }
        
        if index < self.currentPageIndex {
            self.setViewControllers([self.pages[index]], direction: .reverse, animated: true, completion: nil)
        } else if index > self.currentPageIndex {
            self.setViewControllers([self.pages[index]], direction: .forward, animated: true, completion: nil)
        }
        
        self.currentPageIndex = index
    }
}

extension MyPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let currentIndex = pages.index(of: viewController)!
        
        // This version will not allow pages to wrap around
        guard currentIndex > 0 else {
            return nil
        }
        
        return pages[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let currentIndex = pages.index(of: viewController)!
        
        // This version will not allow pages to wrap around
        guard currentIndex < pages.count - 1 else {
            return nil
        }
        
        return pages[currentIndex + 1]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 4
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

