//
//  PageViewController.swift
//  MakeUp App
//
//  Created by Raquel Rahmey on 4/13/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
     var viewControllerList: [UIViewController] = {
        let homeView = HomeViewController()
        let homeNav = UINavigationController(rootViewController: homeView)
        let searchView = SearchViewController()
        let searchNav = UINavigationController(rootViewController: searchView)
        let productView = ProductViewController()
        let productNav = UINavigationController(rootViewController: productView)
    
        
        return [homeNav, searchNav, productNav]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Palette.white.color
        
        dataSource = self
        
        if let firstVC = viewControllerList.first{
        setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
    }
    

    
     func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList.index(of: viewController) else {return nil}
        
        let previousIndex = vcIndex - 1
        
        guard previousIndex >= 0 else {return nil}
        
        guard viewControllerList.count > previousIndex else {return nil}
        
        return viewControllerList[previousIndex]
    }

    
     func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.index(of: viewController) else {return nil}

        let nextIndex = vcIndex + 1
        
        guard viewControllerList.count != nextIndex else {return nil}
        
        guard viewControllerList.count > nextIndex else {return nil}
        
        return viewControllerList[nextIndex]

    }
    
    
}
    

