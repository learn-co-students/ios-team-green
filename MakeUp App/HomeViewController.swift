//
//  HomeViewController.swift
//  MakeUp App
//
//  Created by Benjamin Bernstein on 4/5/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Palette.white.color
        navBar(title: "Raquel Rahmey", leftButton: nil, rightButton: nil)
        setupScrollView()
    }
    
    
    func setupScrollView() {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 150)
        let scrollview = UIScrollView(frame: frame)
        let subviews = [UIView(), UIView(), UIView(), UIView()]
        let colors = [Palette.black.color, Palette.beige.color, Palette.white.color, Palette.darkGrey.color]
        
        scrollview.backgroundColor = Palette.pink.color
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        scrollview.autoresizingMask = UIViewAutoresizing.flexibleWidth
        scrollview.contentSize = CGSize(width: view.frame.width * 0.3, height: 150)
        scrollview.isScrollEnabled = true
        scrollview.isPagingEnabled = true
        view.addSubview(scrollview)
        
        subviews.enumerated().forEach { index, subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            subview.backgroundColor = colors[index]
            //
            scrollview.addSubview(subview)
            subview.topAnchor.constraint(equalTo: scrollview.topAnchor, constant: 0).isActive = true
            subview.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3).isActive = true
            subview.heightAnchor.constraint(equalTo: scrollview.heightAnchor, constant: 0).isActive = true
//            switch index {
//                case 0:
//                    //subview.3
//            }
//            
//            
            
        }
    }
}
