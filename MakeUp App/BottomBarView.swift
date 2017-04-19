//
//  BottomBar.swift
//  MakeUp App
//
//  Created by Raquel Rahmey on 4/14/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import Foundation
import UIKit

class BottomBarView: UIView, PageSelectedDelegate {
    
    
    var homeView = UIView()
    var searchView = UIView()
    var productView = UIView()
    
    var homeButton = UIButton(type: .custom)
    var searchButton = UIButton(type: .custom)
    var productButton = UIButton(type: .custom)
    var horizontalBar = HorizontalRule()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Palette.white.color.withAlphaComponent(0.2)
        setUpButtonImages()
        setUpConstraints()
    }
    
    
    func setUpButtonImages() {
        homeButton.setImage(#imageLiteral(resourceName: "Face"), for: .normal)
        searchButton.setImage(#imageLiteral(resourceName: "Search"), for: .normal)
        productButton.setImage(#imageLiteral(resourceName: "Home"), for: .normal)

        self.addSubview(horizontalBar)
        
    }
    
    func setUpConstraints() {
        let buttons = [homeButton, searchButton, productButton]
        buttons.forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        let viewContainers = [homeView, searchView, productView]
        viewContainers.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
    
            $0.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            $0.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3333).isActive = true
            $0.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
            
        }
        
        homeView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        let homeTap = UITapGestureRecognizer(target: self, action: #selector(switchToHome))
        homeView.addGestureRecognizer(homeTap)

        searchView.leftAnchor.constraint(equalTo: homeView.rightAnchor).isActive = true
        let searchTap = UITapGestureRecognizer(target: self, action: #selector(switchToSearch))
        searchView.addGestureRecognizer(searchTap)

        productView.leftAnchor.constraint(equalTo: searchView.rightAnchor).isActive = true
        let productTap = UITapGestureRecognizer(target: self, action: #selector(switchToProduct))
        productView.addGestureRecognizer(productTap)

        homeButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 50).isActive = true
        homeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 5).isActive = true
        
        searchButton.centerYAnchor.constraint(equalTo: homeButton.centerYAnchor).isActive = true
        searchButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        productButton.centerYAnchor.constraint(equalTo: homeButton.centerYAnchor).isActive = true
        productButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -50).isActive = true
        
        horizontalBar.translatesAutoresizingMaskIntoConstraints = false
        horizontalBar.bottomAnchor.constraint(equalTo: productButton.topAnchor, constant: -15).isActive = true
        horizontalBar.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9).isActive = true
        horizontalBar.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        
    }
    
    func switchToHome(sender: UITapGestureRecognizer) {
        NotificationCenter.default.post(name: .homeVC, object: nil)
    }
    
    func switchToSearch(sender: UITapGestureRecognizer) {
        NotificationCenter.default.post(name: .searchVC, object: nil)
    }
    
    func switchToProduct(sender: UITapGestureRecognizer) {
        NotificationCenter.default.post(name: .productVC, object: nil)
    }
    
    func changeImage(at index: Int) {
        switch index {
        case 0:
            homeButton.setImage(#imageLiteral(resourceName: "Heart"), for: .normal)
            searchButton.setImage(#imageLiteral(resourceName: "Search"), for: .normal)
            productButton.setImage(#imageLiteral(resourceName: "Home"), for: .normal)
        case 1:
            homeButton.setImage(#imageLiteral(resourceName: "Face"), for: .normal)
            searchButton.setImage(#imageLiteral(resourceName: "Heart"), for: .normal)
            productButton.setImage(#imageLiteral(resourceName: "Home"), for: .normal)
        default:
            homeButton.setImage(#imageLiteral(resourceName: "Face"), for: .normal)
            searchButton.setImage(#imageLiteral(resourceName: "Search"), for: .normal)
            productButton.setImage(#imageLiteral(resourceName: "Heart"), for: .normal)
        }
        
      
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

extension BottomBarView {
    class func constrainBottomBarToEdges(viewController: UIViewController, bottomBar: UIView) {
        
        viewController.view.addSubview(bottomBar)
        
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor).isActive = true
        bottomBar.leftAnchor.constraint(equalTo: viewController.view.leftAnchor).isActive = true
        bottomBar.widthAnchor.constraint(equalTo: viewController.view.widthAnchor).isActive = true
        bottomBar.heightAnchor.constraint(equalTo: viewController.view.heightAnchor, multiplier: 0.1).isActive = true
    }
}
