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
        
        self.title = title
  
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
  
        
        navigationController?.navigationBar.tintColor = Palette.beige.color
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func determineButton(type: ButtonType) -> UIBarButtonItem? {
        switch type.rawValue {
        case "mirror":
            return UIBarButtonItem(title: "Mirror", style: .plain, target: self, action: nil)
        case "backToProduct":
            return UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backToProduct(_:)))
        case "backToSearch":
            return UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backToSearch(_:)))
        case "buy":
            return UIBarButtonItem(title: "Buy", style: .plain, target: self, action: #selector(buy(_:)))
        case "favorite":
            let heartImage = #imageLiteral(resourceName: "Heart").withRenderingMode(.alwaysOriginal)
            let button = UIBarButtonItem(image: heartImage, landscapeImagePhone: heartImage, style: .plain, target: self, action: #selector(toggleProductFavorite))
            button.tag = 0
            return button
        case "notFavorite":
            let heartImage = #imageLiteral(resourceName: "Empty-Heart").withRenderingMode(.alwaysOriginal)
            let button = UIBarButtonItem(image: heartImage, landscapeImagePhone: heartImage, style: .plain, target: self, action: #selector(toggleProductFavorite))
            button.tag = 1
            return button
        default:
            return nil
        }
        
    }
    func backToProduct(_ sender: UIBarButtonItem) {
        NotificationCenter.default.post(name: .productVC, object: nil)
    }
    
    func backToSearch(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: .searchVC, object: nil)

    }
    
    func buy(_ sender: UIBarButtonItem) {
        if let validTitle = ResultStore.sharedInstance.product?.title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if let url = URL(string: "https://www.google.com/search?hl=en&output=search&tbm=shop&q=\(validTitle)") {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    
    func toggleProductFavorite(_ sender: UIBarButtonItem) {
        guard let product = ResultStore.sharedInstance.product else { return }
        FirebaseManager.shared.toggleProductFavorite(product)
        switch sender.tag {
        case 1:
            let heartImage = #imageLiteral(resourceName: "Heart").withRenderingMode(.alwaysOriginal)
            let button = UIBarButtonItem(image: heartImage, landscapeImagePhone: heartImage, style: .plain, target: self, action: #selector(toggleProductFavorite))
            button.tag = 0
            self.navigationItem.leftBarButtonItem = button
        default:
            let heartImage = #imageLiteral(resourceName: "Empty-Heart").withRenderingMode(.alwaysOriginal)
            let button = UIBarButtonItem(image: heartImage, landscapeImagePhone: heartImage, style: .plain, target: self, action: #selector(toggleProductFavorite))
            button.tag = 1
           self.navigationItem.leftBarButtonItem = button
        }
    }

    
}


enum ButtonType: String {
    case mirror, backToSearch, backToProduct, favorite, notFavorite, buy
}

