//
//  DataStore.swift
//  MakeUp App
//
//  Created by Benjamin Bernstein on 4/6/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import Foundation

class UserStore {
    
    static let sharedInstance = UserStore()
    private init () {}

    var myProducts = [Product]()
    var myMedia = [Youtube]()
    
//    init() {
//        // Make 5 Products for Testing
//        for _ in (1...5) {
//            let newProduct = Product()
//            let newMedia = MediaItem()
//            myMedia.append(newMedia)
//            myProducts.append(newProduct)
//        }
//    }
    
    
    
//    import UIKit
//    
//    struct MediaItem {
//        var title: String
//        var image: UIImage
//        
//        init() {
//            // Random Product Name Initializer for Testing
//            let randomNumber = arc4random_uniform(3)
//            switch randomNumber {
//            case 1:
//                self.title = "Smoky AF Look"
//            case 2:
//                self.title = "I loved this Item"
//            case 3:
//                self.title = "OMG This is Great"
//            default:
//                self.title = "Skin and Contour"
//                
//            }
//            self.image = #imageLiteral(resourceName: "REVIEW")
//        }
//        
//    }
}
