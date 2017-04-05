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
        
        print("home view")
    }
}
