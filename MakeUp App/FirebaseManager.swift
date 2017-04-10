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
    
    var ref = FIRDatabase.database().reference()
    
    var currentUser: FIRUser?

    var currentUserNode: FIRDatabaseReference {
        return ref.child("Users")
    }
    
    private init() {}
    
    static private let ref = FIRDatabase.database().reference()
    
    private let currentUserID = UserDefaults.standard.string(forKey: "userID") ?? "No User Id"
    
    /// User Functions ///
    
    func loadUser(_ userID: String, completion: @escaping () -> ()) {
        _ = FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            self.currentUser = user
            completion()
        })
    }
    func createOrUpdate(_ user: FIRUser) {
        let name = user.displayName ?? "No name"
        currentUserNode.child(user.uid).updateChildValues(["name": name])
        currentUser = user
    }
    
    func toggleFavorite(_ product: Product) {
        let productRecord = currentUserNode.child((currentUser?.uid)!).child("favorites")
        if productRecord.value(forKey: product.upc) as! Bool == false || productRecord.value(forKey: product.upc) == nil {
            productRecord.updateChildValues([product.upc : true])
        } else {
            productRecord.updateChildValues([product.upc : false])
        }
    }
    
}
