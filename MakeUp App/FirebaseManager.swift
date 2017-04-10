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
    
    private init() {}
    
    static private let ref = FIRDatabase.database().reference()
    
    private let currentUserID = UserDefaults.standard.string(forKey: "userId") ?? "No User Id"
    
    private enum Child {
        static var users: FIRDatabaseReference { return ref.child("Users") }
    }
    
    private var currentUserNode: FIRDatabaseReference {
        return Child.users.child(currentUserID)
    }
    
    /// User Functions ///
    
    func createOrUpdate(_ user: FIRUser) {
        let name = user.displayName
        FIRDatabase.database().reference(withPath: "Users").updateChildValues(["name": name])
    
        print("user name is", name)
        //create or update user
    }
}
