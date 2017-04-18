//
//  KeyBoardExtension.swift
//  MakeUp App
//
//  Created by Benjamin Bernstein on 4/14/17.
//  Copyright © 2017 enjamin Bernstein. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer (
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
