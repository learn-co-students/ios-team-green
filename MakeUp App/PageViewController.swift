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
        addNotificationObservers()
        
        
        view.backgroundColor = Palette.white.color
        
        dataSource = self
        
        if let firstVC = viewControllerList.first {
        setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
    }
    
     func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList.index(of: viewController) else {return nil}
        
        let previousIndex = vcIndex - 1
        
        guard previousIndex >= 0 else {return nil}
        
        guard viewControllerList.count > previousIndex else { return nil}
        
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

typealias NotificationObservers = PageViewController
extension NotificationObservers {
    
    func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(switchViewController(with:)), name: .productVC, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(switchViewController(with:)), name: .searchVC, object: nil)
    }
    
    func switchViewController(with notification: Notification) {
        switch notification.name {
        case Notification.Name.productVC:
            switchToViewController(named: "Product")
        case Notification.Name.searchVC:
            switchToViewController(named: "Search")
        default:
            fatalError("\(#function) - Unable to match notification name.")
        }
    }
    
    private func switchToViewController(named: String) {
        switch named {
        case "Product":
            setViewControllers([viewControllerList[2]], direction: .forward, animated: true, completion: nil)

        default:
            setViewControllers([viewControllerList[1]], direction: .forward, animated: true, completion: nil)

        }
    }
}

extension Notification.Name {
    static let productVC = Notification.Name("switch-to-product-vc")
    static let searchVC = Notification.Name("switch-to-search-vc")

}



