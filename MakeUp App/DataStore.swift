//
//  DataStore.swift
//  MakeUp App
//
//  Created by Benjamin Bernstein on 4/6/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import Foundation

struct DataStore {
    
    var myProducts = [Product]()
    var myMedia = [MediaItem]()
    
    init() {
        // Make 5 Products for Testing
        for _ in (1...5) {
            let newProduct = Product()
            let newMedia = MediaItem()
            myMedia.append(newMedia)
            myProducts.append(newProduct)
        }
    }
    
}
