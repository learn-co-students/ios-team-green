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

}
