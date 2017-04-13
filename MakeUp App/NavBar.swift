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
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: Fonts.Playfair(withStyle: .regular, sizeLiteral: 10)], for: .normal)
        
        func determineButton(type: ButtonType) -> UIBarButtonItem? {
            switch type.rawValue {
            case "mirror":
                return UIBarButtonItem(title: "Mirror", style: .plain, target: self, action: nil)
            case "back":
                return UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(popLast(_:)))
            case "buy":
                return UIBarButtonItem(title: "Buy", style: .plain, target: self, action: #selector(buy(_:)))
            case "favorite":
                let heartImage = #imageLiteral(resourceName: "Heart").withRenderingMode(.alwaysOriginal)
                return UIBarButtonItem(image: heartImage, landscapeImagePhone: heartImage, style: .plain, target: self, action: #selector(toggleProductFavorite))
            default:
                return nil
            }
       
        }
    
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
    
    func buy(_ sender: UIBarButtonItem) {
        print("TODO: This goes to a google search for the productname")
    }
    
    func toggleProductFavorite() {
        guard let product = ResultStore.sharedInstance.product else { return }
        FirebaseManager.shared.toggleProductFavorite(product)
        self.navigationController?.popViewController(animated: true)
    }
    
}


enum ButtonType: String {
    case mirror, back, favorite, buy
}

