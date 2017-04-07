//
//  NavBar.swift
//  MakeUp App
//
//  Created by Benjamin Bernstein on 4/5/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func navBar(title: String, leftButton: ButtonType?, rightButton: ButtonType?) {
        
        func determineButton(type: ButtonType) -> UIBarButtonItem? {
            switch type.rawValue {
            case "mirror":
                return UIBarButtonItem(title: "Mirror", style: .plain, target: self, action: nil)
            case "back":
                return UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(popLast(_:)))
            case "favorite":
                return UIBarButtonItem(image: #imageLiteral(resourceName: "Heart"), landscapeImagePhone: #imageLiteral(resourceName: "Heart"), style: .plain, target: self, action: nil)
            default:
                return nil
            }
       
        }
    
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: Fonts.Playfair(withStyle: .regular, sizeLiteral: 10)], for: .normal)
        
        if let leftButton = leftButton {
            self.navigationItem.leftBarButtonItem = determineButton(type: leftButton)
        }
        
        if let rightButton = rightButton {
            self.navigationItem.rightBarButtonItem = determineButton(type: rightButton)
            
        }
        
        navigationItem.title = title
        
        let navigationTitleFont = Fonts.Playfair(withStyle: .black, sizeLiteral: 18)
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: navigationTitleFont, NSForegroundColorAttributeName: Palette.white.color]
        navigationController?.navigationBar.barTintColor = Palette.beige.color
        
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: Fonts.Playfair(withStyle: .black, sizeLiteral: 16), NSForegroundColorAttributeName: Palette.black.color], for: .normal)
        
        navigationController?.navigationBar.tintColor = Palette.beige.color
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func popLast(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}


enum ButtonType: String {
    case mirror, back, favorite
}

