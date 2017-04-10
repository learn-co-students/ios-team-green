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
    
    func fetchUserFavorites(completion: @escaping () -> Void) {
        //hard code ben bernstein user id for testing
        let userFavorites = currentUserNode.child(("7wETgHKfefaQzL8155WWbI3lkuj2")).child("favorites")
        print("user favorites is", userFavorites)
        userFavorites.observe(.value, with: { (snapshot) in
            guard let favoriteRecord = snapshot.value as? [String:Any] else { print("couldn't get snapshot"); return }
            print("favoritrecord", favoriteRecord)
            var idsToCheck = [String]()
            for key in favoriteRecord.keys {
                idsToCheck.append(key)
            }
            print("ids to retrieve", idsToCheck)
            var i = 1
            idsToCheck.forEach({ (id) in
                self.ref.child("Products").child(id).observe(.value, with: { (snapshot) in
                    guard let dict = snapshot.value as? [String:Any] else { print("no dict snapshot"); return }
                    let newproduct = Product(dict: dict)
                    print(" is", newproduct.title)
                    UserStore.sharedInstance.myProducts.append(newproduct)
                    i += i
                    if i == idsToCheck.count {
                        print("hit completion...")
                        UserStore.sharedInstance.myProducts.forEach { print($0.title) }
                        completion()
                    }
                })
            })
            
        })
    }
}
