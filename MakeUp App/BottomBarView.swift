//
//  BottomBar.swift
//  MakeUp App
//
//  Created by Raquel Rahmey on 4/14/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import Foundation
import UIKit

class BottomBarView: UIView {
    
    var homeButton = UIButton(type: .custom)
    var searchButton = UIButton(type: .custom)
    var productButton = UIButton(type: .custom)
    var horizontalBar = HorizontalRule()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Palette.white.color.withAlphaComponent(0.2)
        setUpButtons()
        setUpButtonConstraints()
    }
    
    
    func setUpButtons() {
        homeButton.setImage(#imageLiteral(resourceName: "BeautyGirl"), for: .normal)
        searchButton.setImage(#imageLiteral(resourceName: "Search"), for: .normal)
        productButton.setImage(#imageLiteral(resourceName: "Home"), for: .normal)
        
        self.addSubview(homeButton)
        self.addSubview(searchButton)
        self.addSubview(productButton)
        
    }
    
    func setUpButtonConstraints() {
        let buttons = [homeButton, searchButton, productButton]
        buttons.forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.addTarget(self, action: #selector(switchView), for: .touchUpInside)
        }
        
        homeButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 50).isActive = true
        homeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        homeButton.tag = 0
        
        searchButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        searchButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        searchButton.tag = 1
        
        productButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        productButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -50).isActive = true
        productButton.tag = 2
        
        
    }
    
    func switchView(sender: UIButton) {
        switch sender.tag {
        case 0:
            NotificationCenter.default.post(name: .homeVC, object: nil)
        case 1:
            NotificationCenter.default.post(name: .searchVC, object: nil)
        default:
            NotificationCenter.default.post(name: .productVC, object: nil)
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
