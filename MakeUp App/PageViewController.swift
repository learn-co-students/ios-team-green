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
    var youtubeOpen = false
    
    weak var pageDelegate: PageSelectedDelegate?
    
    var currentIndex = 0
    var viewControllerList: [UIViewController] = {
        
        let homeView = HomeViewController()
        let homeNav = UINavigationController(rootViewController: homeView)
        
        let searchView = SearchViewController()
        let searchNav = UINavigationController(rootViewController: searchView)
        
        let productView = ProductViewController()
        let productNav = UINavigationController(rootViewController: productView)
        
        let tutorialsView = YouTubeViewController()
        tutorialsView.type = YoutubeSearch(rawValue: "Tutorials")
        let tutorialsNav = UINavigationController(rootViewController: tutorialsView)
        
        let reviewsView = YouTubeViewController()
        reviewsView.type = YoutubeSearch(rawValue: "Reviews")
        let reviewsNav = UINavigationController(rootViewController: reviewsView)
        
        return [homeNav, searchNav, productNav, tutorialsNav, reviewsNav]
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageDelegate = bottomBar

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
        
        if previousIndex < 0 || previousIndex > viewControllerList.count {
            return viewControllerList[previousIndex]
        }
        
        return viewControllerList[previousIndex]
    }
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.index(of: viewController) else {return nil}
        
        let nextIndex = vcIndex + 1
        
        guard viewControllerList.count != nextIndex else {return nil}
        
        guard viewControllerList.count > nextIndex else {return nil}
        
        
        // Don't go to results or tutorials if there's no product
        if nextIndex > 2 { guard resultsStore.product != nil else { return nil } }
        
        if nextIndex < 0 || nextIndex > viewControllerList.count {
            return viewControllerList[vcIndex]
        }
        
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(toggleNavigation(with:)), name: .toggleNav, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateIndex(with:)), name: .homeIndex, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateIndex(with:)), name: .searchIndex, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateIndex(with:)), name: .productIndex, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateIndex(with:)), name: .tutorialsIndex, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateIndex(with:)), name: .reviewsIndex, object: nil)
        
    }
    func checkIfYoutubeOpen() {
        if youtubeOpen == false {
            youtubeOpen = true
        } else {
            youtubeOpen = false
        }
        print("youtube open variable is ", youtubeOpen)
    }
    
    
    func toggleNavigation(with: Notification) {
        checkIfYoutubeOpen()
        if youtubeOpen == true {
            bottomBar.isHidden = true
            self.dataSource = nil
        } else if youtubeOpen == false {
            self.dataSource = self
            setView(viewController: currentIndex)
            bottomBar.isHidden = false
        }
        
    }
    
    func updateIndex(with notification: Notification) {
        switch notification.name {
        case Notification.Name.homeIndex:
            currentIndex = 0
            pageDelegate?.changeImage(at: currentIndex)
        case Notification.Name.searchIndex:
            currentIndex = 1
            pageDelegate?.changeImage(at: currentIndex)
        case Notification.Name.productIndex:
            currentIndex = 2
            pageDelegate?.changeImage(at: currentIndex)
        case Notification.Name.tutorialsIndex:
            currentIndex = 3
        case Notification.Name.reviewsIndex:
            currentIndex = 4
        default:
            currentIndex = 0
        }
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
            setView(viewController: 0)
        case "Search":
            setView(viewController: 1)
            pageDelegate?.changeImage(at: currentIndex)
        case "Product":
            setView(viewController: 2)
            pageDelegate?.changeImage(at: currentIndex)
        case "Tutorials":
            setView(viewController: 3)
        case "Reviews":
            setView(viewController: 4)
        default :
            setView(viewController: 0)
        }
    }
    
    func setView(viewController Index: Int) {
        DispatchQueue.main.async {
            self.setViewControllers([self.viewControllerList[Index]], direction: self.determineScrollDirection(from: self.currentIndex, to: Index), animated: true, completion: nil)
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

protocol PageSelectedDelegate: class {
    func changeImage(at index: Int)
}



extension Notification.Name {
    static let productVC = Notification.Name("switch-to-product-vc")
    static let searchVC = Notification.Name("switch-to-search-vc")
    static let homeVC = Notification.Name("switch-to-home-vc")
    static let tutorialsVC = Notification.Name("switch-to-tutorials-vc")
    static let reviewsVC = Notification.Name("switch-to-reviews-vc")
    
    static let homeIndex = Notification.Name("homeIndex")
    static let searchIndex = Notification.Name("searchIndex")
    static let productIndex = Notification.Name("productIndex")
    static let tutorialsIndex = Notification.Name("tutorialsIndex")
    static let reviewsIndex = Notification.Name("reviewsIndex")
    static let toggleNav = Notification.Name("toggleNav")
    
    
}



