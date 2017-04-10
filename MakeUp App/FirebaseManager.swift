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
        let productID = product.upc
        productRecord.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let favoriteRecord = snapshot.value as? [String:Any] else { print("couldn't cast snapshot"); return }
            if favoriteRecord[productID] as? Bool == true {
                productRecord.updateChildValues([productID: false])
            } else {
                productRecord.updateChildValues([productID: true])

            }
        })
    }
    
    func fetchUserFavorites(completion: () -> Void) {
        
        
        // get all the favorite IDS
        // look in Products for all the IDS, and get the dictionaries
        // Make products out of them
        // put them in allProducts
    }
    
}
