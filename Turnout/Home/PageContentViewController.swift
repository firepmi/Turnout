//
//  PageContentViewController.swift
//  Turnout
//
//  Created by Mobile World on 10/27/17.
//  Copyright © 2017 Coca Denisa. All rights reserved.
//

import UIKit

class PageContentViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate
    {
        let pages = ["Notification", "Main","MyProfile"]
        override func viewDidLoad() {
            super.viewDidLoad()
            self.delegate = self
            self.dataSource = self            
            let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "Notification")
            let vc2 = self.storyboard?.instantiateViewController(withIdentifier: "Main")
            let vc3 = self.storyboard?.instantiateViewController(withIdentifier: "MyProfile")
            setViewControllers([vc2!], direction: .forward, animated: true, completion: nil)
        }
        
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        print("ID: " + viewController.restorationIdentifier!)
        if let identifier = viewController.restorationIdentifier {
            if let index = pages.index(of: identifier) {
                if index > 0 {
                    return self.storyboard?.instantiateViewController(withIdentifier: pages[index-1])
                }
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let identifier = viewController.restorationIdentifier {
            if let index = pages.index(of: identifier) {
                if index < pages.count - 1 {
                    return self.storyboard?.instantiateViewController(withIdentifier: pages[index+1])
                }
            }
        }
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        if let identifier = viewControllers?.first?.restorationIdentifier {
            if let index = pages.index(of: identifier) {
                return index
            }
        }
        return 0
    }
        
        // MARK:- Other Methods
//        func getViewControllerAtIndex(index: NSInteger) -> PageContentViewController
//        {
//            // Create a new view controller and pass suitable data.
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PagesContentController1")
////            setViewControllers([vc!], // Has to be a single item array, unless you're doing double sided stuff I believe
////                direction: .forward,
////                animated: true,
////                completion: nil)
//            return pageContentViewController
//        }
}

