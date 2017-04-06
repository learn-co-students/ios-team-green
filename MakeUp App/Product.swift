//
//  Product.swift
//  MakeUp App
//
//  Created by Benjamin Bernstein on 4/5/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import Foundation
import UIKit

struct Product {
    var title: String
    var image: UIImage
    var imageURL: String
    var price: Double
    
    init() {
        // Random Product Name Initializer for Testing
        let randomNumber = arc4random_uniform(3)
        switch randomNumber {
        case 1:
            self.title = "Diorshow Mascara"
        case 2:
            self.title = "Naked Palette"
        case 3:
            self.title = "Glamglow"
        default:
            self.title = "Bobbi Brown Intensive Skin"

        }
        self.image = #imageLiteral(resourceName: "DIORSHOW")
        self.imageURL = "https://img1.r10.io/PIC/75877290/0/1/250/75877290.jpg"
        self.price = 20.00
    }
   
}
