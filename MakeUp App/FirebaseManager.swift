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
    
    /// App Functions //

    
    func toggleProductFavorite(_ product: Product) {
        
        guard let user = currentUser else { print("no user"); return }
        let productRecord = currentUserNode.child(user.uid).child("favorites").child("products")
        let productID = product.upc
        productRecord.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let favoriteRecord = snapshot.value as? [String:Any] else { print("couldn't cast snapshot"); return }
            if favoriteRecord[productID] as? Bool == true {
                productRecord.updateChildValues([productID: false])
                print("removed favorite")
            } else {
                productRecord.updateChildValues([productID: true])
                print("added favorite")

                
            }
        })
    }
    
    func toggleMediaFavorite(_ product: Product) {
        
        guard let user = currentUser else { print("no user"); return }
        let productRecord = currentUserNode.child(user.uid).child("favorites").child("media")
        let productID = product.upc
        productRecord.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let favoriteRecord = snapshot.value as? [String:Any] else { print("couldn't cast snapshot"); return }
            if favoriteRecord[productID] as? Bool == true {
                productRecord.updateChildValues([productID: false])
                print("removed favorite")
            } else {
                productRecord.updateChildValues([productID: true])
                print("added favorite")
                
                
            }
        })
    }
    
    
    func fetchUserFavorites(completion: @escaping ([Product]) -> Void) {
        
        guard let user = currentUser else { print("no user"); return }
        let userFavorites = currentUserNode.child(user.uid).child("favorites").child("products")
        userFavorites.observe(.value, with: { (snapshot) in
            guard let favoriteRecord = snapshot.value as? [String:Any] else { print("the user has no favorites"); return }
            var idsToRetrieve = [String]()
            for key in favoriteRecord.keys {
                if favoriteRecord[key] as? Bool == true {
                    idsToRetrieve.append(key)
                }
            }
            var products = [Product]()
            var i = 1
            idsToRetrieve.forEach({ (id) in
                self.ref.child("Products").child(id).observe(.value, with: { (snapshot) in
                    guard let dict = snapshot.value as? [String:Any] else { print("no dict snapshot"); return }
                    let newproduct = Product(dict: dict)
                    products.append(newproduct)
                    i += i
                    if i >= idsToRetrieve.count {
                        completion(products)
                    }
                })
            })
            
        })
    }
}
