//
//  UserStore.swift
//  MakeUp App
//
//  Created by Benjamin Bernstein on 4/11/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import Foundation


final class UserStore {
    static let sharedInstance = UserStore()
    
    // This should eventually be realm. Right now this should be only used to check user favorites against data from another product ....

    var favoriteProducts = [Product]()
    var favoriteMedia = [Youtube]()
    
    private init() {}
    

}
