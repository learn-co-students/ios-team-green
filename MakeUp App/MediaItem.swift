//
//  MediaItem.swift
//  MakeUp App
//
//  Created by Benjamin Bernstein on 4/5/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import UIKit

struct MediaItem {
    var title: String
    var image: UIImage
    
    init() {
        // Random Product Name Initializer for Testing
        let randomNumber = arc4random_uniform(3)
        switch randomNumber {
        case 1:
            self.title = "Smoky AF Look"
        case 2:
            self.title = "I loved this Item"
        case 3:
            self.title = "OMG This is Great"
        default:
            self.title = "Skin and Contour"
            
        }
        self.image = #imageLiteral(resourceName: "REVIEW")
    }

}
