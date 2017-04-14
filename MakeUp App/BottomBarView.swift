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
    var resultButton = UIButton(type: .custom)
    var horizontalBar = HorizontalRule()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Palette.white.color.withAlphaComponent(0.2)
        setUpButtons()
        setUpButtonConstraints()
    }
    
    
    func setUpButtons() {
        homeButton.setBackgroundImage(#imageLiteral(resourceName: "BeautyGirl"), for: .normal)
        searchButton.setBackgroundImage(#imageLiteral(resourceName: "Search"), for: .normal)
        resultButton.setBackgroundImage(#imageLiteral(resourceName: "Home"), for: .normal)

        
        self.addSubview(homeButton)
        self.addSubview(searchButton)
        self.addSubview(resultButton)
        
    }
    
    func setUpButtonConstraints() {
        let buttons = [homeButton, searchButton, resultButton]
        buttons.forEach{$0.translatesAutoresizingMaskIntoConstraints = false}
        
        homeButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 50).isActive = true
        homeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        //homeButton.widthAnchor.constraint(equalToConstant: 56).isActive = true
        //homeButton.heightAnchor.constraint(equalToConstant: 68).isActive = true
       
        
        searchButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        searchButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        resultButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        resultButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -50).isActive = true
        
        
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
