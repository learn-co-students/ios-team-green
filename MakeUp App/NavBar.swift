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
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: Fonts.Playfair(withStyle: .regular, sizeLiteral: 10)], for: .normal)
        
        func determineButton(type: ButtonType) -> UIBarButtonItem? {
            switch type.rawValue {
            case "mirror":
                return UIBarButtonItem(title: "Mirror", style: .plain, target: self, action: nil)
            case "back":
                return UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backToProduct(_:)))
            case "buy":
                return UIBarButtonItem(title: "Buy", style: .plain, target: self, action: #selector(buy(_:)))
            case "favorite":
                let heartImage = #imageLiteral(resourceName: "Heart").withRenderingMode(.alwaysOriginal)
                return UIBarButtonItem(image: heartImage, landscapeImagePhone: heartImage, style: .plain, target: self, action: #selector(toggleProductFavorite))
            case "notFavorite":
                let heartImage = #imageLiteral(resourceName: "Empty-Heart").withRenderingMode(.alwaysOriginal)
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
    
    func backToProduct(_ sender: UIBarButtonItem) {
        NotificationCenter.default.post(name: .productVC, object: nil)
    }
    
    func buy(_ sender: UIBarButtonItem) {        
        if let validTitle = ResultStore.sharedInstance.product?.title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if let url = URL(string: "https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=\(validTitle)") {
                UIApplication.shared.open(url, options: [:])
            }
        }
        

        
    }
    
    func toggleProductFavorite() {
        guard let product = ResultStore.sharedInstance.product else { return }
        FirebaseManager.shared.toggleProductFavorite(product)
        toggleHeartButton()
    }
    
    func toggleHeartButton() {
        //TODO: Set heart button depending on if product is favorite
    }
    
}


enum ButtonType: String {
    case mirror, back, favorite, notFavorite, buy
}

