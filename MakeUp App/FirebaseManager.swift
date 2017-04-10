//
//  FirebaseManager.swift
//  MakeUp App
//
//  Created by Benjamin Bernstein on 4/10/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

final class FirebaseManager {
    
    static let shared = FirebaseManager()
    
    var currentUser: FIRUser?
    
    private init() {}
    
    static private let ref = FIRDatabase.database().reference()
    
    private let currentUserID = UserDefaults.standard.string(forKey: "userID") ?? "No User Id"
    
    /// User Functions ///
    
    func createOrUpdate(_ user: FIRUser) {
        let name = user.displayName ?? "No name"
        FIRDatabase.database().reference().child("Users").child(user.uid).updateChildValues(["name": name])
        currentUser = user
    }
    
}
