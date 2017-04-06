//
//  User.swift
//  MakeUp App
//
//  Created by Benjamin Bernstein on 4/6/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import Foundation

final class UserData {
    
    static let shared = UserData()
    
    var dataStore = DataStore()

    private init() {}
}
