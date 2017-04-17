//
//  PageViewController.swift
//  MakeUp App
//
//  Created by Raquel Rahmey on 4/13/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    let resultsStore = ResultStore.sharedInstance
    var bottomBar = BottomBarView()

      var currentIndex = 0
      var viewControllerList: [UIViewController] = {
        let homeView = HomeViewController()
        let homeNav = UINavigationController(rootViewController: homeView)
        let searchView = SearchViewController()
        let searchNav = UINavigationController(rootViewController: searchView)
        let productView = ProductViewController()
        let productNav = UINavigationController(rootViewController: productView)
        
        let tutorialsView = YouTubeViewController()
        tutorialsView.type = "Tutorials"
        let tutorialsNav = UINavigationController(rootViewController: tutorialsView)
        
        let reviewsView = YouTubeViewController()
        reviewsView.type = "Reviews"
        let reviewsNav = UINavigationController(rootViewController: reviewsView)
  
        return [homeNav, searchNav, productNav, tutorialsNav, reviewsNav]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        addNotificationObservers()
        
        view.backgroundColor = Palette.beige.color
        BottomBarView.constrainBottomBarToEdges(viewController: self, bottomBar: bottomBar)
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
        
        // Don't go to results or tutorials if there's no product
        if nextIndex > 2 { guard resultsStore.product != nil else { return nil } }
        
        return viewControllerList[nextIndex]

    }
   
}

typealias NotificationObservers = PageViewController
extension NotificationObservers {
    
    func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(switchViewController(with:)), name: .productVC, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(switchViewController(with:)), name: .searchVC, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(switchViewController(with:)), name: .homeVC, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(switchViewController(with:)), name: .tutorialsVC, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(switchViewController(with:)), name: .reviewsVC, object: nil)

    }
    
    func switchViewController(with notification: Notification) {
        switch notification.name {
        case Notification.Name.productVC:
            switchToViewController(named: "Product")
        case Notification.Name.searchVC:
            switchToViewController(named: "Search")
        case Notification.Name.homeVC:
            switchToViewController(named: "Home")
        case Notification.Name.tutorialsVC:
            switchToViewController(named: "Tutorials")
        case Notification.Name.reviewsVC:
            switchToViewController(named: "Reviews")
        default:
            fatalError("\(#function) - Unable to match notification name.")
        }
    }
    
    private func switchToViewController(named: String) {
        switch named {
        case "Home":
            setViewControllers([viewControllerList[0]], direction: determineScrollDirection(from: currentIndex, to: 0), animated: true, completion: nil)
            currentIndex = 0
        case "Search":
            setViewControllers([viewControllerList[1]], direction: determineScrollDirection(from: currentIndex, to: 1), animated: true, completion: nil)
            viewControllerList[1].navigationController?.popViewController(animated: true)
            
            // remove anything on top of me, which would be the TVC
            currentIndex = 1
        case "Product":
            setViewControllers([viewControllerList[2]], direction: determineScrollDirection(from: currentIndex, to: 2), animated: true, completion: nil)
            currentIndex = 2
        case "Tutorials":
            setViewControllers([viewControllerList[3]], direction: determineScrollDirection(from: currentIndex, to: 3), animated: true, completion: nil)
            currentIndex = 3
        default :
            setViewControllers([viewControllerList[4]], direction: determineScrollDirection(from: currentIndex, to: 4), animated: true, completion: nil)
            currentIndex = 4

        }
    }
    
    // make sure the animation plays properly depending on where user is in our 'virtual' flow
    private func determineScrollDirection(from currentIndex: Int, to desiredIndex: Int) -> UIPageViewControllerNavigationDirection {
        if currentIndex < desiredIndex {
            return .forward
        } else {
            return .reverse
        }
        
    }
}

extension Notification.Name {
    static let productVC = Notification.Name("switch-to-product-vc")
    static let searchVC = Notification.Name("switch-to-search-vc")
    static let homeVC = Notification.Name("switch-to-home-vc")
    static let tutorialsVC = Notification.Name("switch-to-tutorials-vc")
    static let reviewsVC = Notification.Name("switch-to-reviews-vc")

}



