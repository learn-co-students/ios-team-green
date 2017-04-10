//
//  TabBarController.swift
//  MakeUp App
//
//  Created by Benjamin Bernstein on 4/4/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Palette.white.color
        setupLayout()
        setupViewControllers()
      }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //Fetch user records from Firebase and put in Datastore probably goes here
    }
    
}


// MARK: - Layout

extension TabBarController {
    func setupLayout() {
        view.backgroundColor = Palette.white.color
        tabBar.barTintColor = Palette.pink.color
        tabBar.itemPositioning = UITabBarItemPositioning.centered
        
        UITabBarItem.appearance()
            .setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: Fonts.Playfair(withStyle: .regular, sizeLiteral: 10)], for: .normal)
    }
}

typealias ViewControllersInitializer = TabBarController
extension ViewControllersInitializer {
    
    func setupViewControllers() {
        
        let homeVC = UINavigationController(rootViewController: homeView())
        
        let searchVC = UINavigationController(rootViewController: searchView())
        
        self.viewControllers = [homeVC, searchVC]
    }
    
    func homeView() -> HomeViewController {
        let VC = HomeViewController()
        
        let homeBarItem = UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "Home").withRenderingMode(.alwaysOriginal), selectedImage: nil)
        
        VC.tabBarItem = homeBarItem
        return VC
    }
    
    func searchView() -> SearchViewController {
        let VC = SearchViewController()
        let searchBarItem = UITabBarItem(title: "Search", image: #imageLiteral(resourceName: "Search").withRenderingMode(.alwaysOriginal), selectedImage: nil)
        VC.tabBarItem = searchBarItem
        return VC
    }
    
    
}
