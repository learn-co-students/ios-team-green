//
//  FirebaseManager.swift
//  MakeUp App
//
//  Created by Benjamin Bernstein on 4/10/17.
//  Copyright © 2017 Benjamin Bernstein. All rights reserved.
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
    
    let dateFormatter = DateFormatter()
    var time: String
    private init() {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        time = dateFormatter.string(from: Date())
    }
    
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
        
        time = dateFormatter.string(from: Date())

        guard let user = currentUser else { print("no user"); return }
        let productID = product.upc
        let productRecord = currentUserNode.child(user.uid).child("favorites").child("products")
        
        productRecord.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let favoriteRecord = snapshot.value as? [String:Any] else { return }
                if let product = favoriteRecord[productID] as? [String:Any]  {
                    if product["isFavorite"] as? Bool == false {
                        productRecord.updateChildValues([productID: [ "isFavorite": true, "timestamp": self.time]])
                        print("User added product favorite")
                    } else   {
                        productRecord.updateChildValues([productID: [ "isFavorite": false, "timestamp": self.time]])
                        print("User removed favorite")
                    }
                } else {
                    productRecord.updateChildValues([productID: [ "isFavorite": true, "timestamp": self.time]])
            }
        })
    }
    
    func toggleMediaFavorite(_ youtube: Youtube) {
        
        time = dateFormatter.string(from: Date())

        guard let user = currentUser else { print("no user"); return }
        let mediaRecord = currentUserNode.child(user.uid).child("favorites").child("media")
        let videoID = youtube.videoID
        
        mediaRecord.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let favoriteRecord = snapshot.value as? [String:Any] else { return }
            if let media = favoriteRecord[videoID] as? [String:Any]  {
                if media["isFavorite"] as? Bool == false {
                    mediaRecord.updateChildValues([videoID: [ "isFavorite": true, "timestamp": self.time]])
                    print("User added media favorite")
                } else {
                    mediaRecord.updateChildValues([videoID: [ "isFavorite": false, "timestamp": self.time]])
                    print("User removed media favorite")
                }
            } else {
                mediaRecord.updateChildValues([videoID: [ "isFavorite": true, "timestamp": self.time]])
            }
        })
    }
    
    func fetchUserProducts(completion: @escaping ([Product]) -> Void) {
        guard let user = currentUser else { print("no user"); return }
        let userFavorites = currentUserNode.child(user.uid).child("favorites").child("products")
        userFavorites.observe(.value, with: { (snapshot) in
            
            //Key is product ID, value is the timestamp
            var idsToRetrieve = [String:String]()
            snapshot.children.forEach {
                let snapShotValue = $0 as? FIRDataSnapshot
                guard let ID = snapShotValue?.key else { print("couldn't get ID from snapshot"); return }
                
                let product = snapShotValue?.value as? [String:Any]
                
                if let isFavorite = product?["isFavorite"]  {
                    if isFavorite as? Bool == true {
                        idsToRetrieve[ID] = product?["timestamp"] as? String
                    }
                }
            }
            var products = [Product]()
            idsToRetrieve.forEach({ (id) in
                self.ref.child("Products").child(id.key).observe(.value, with: { (snapshot) in
                    guard let dict = snapshot.value as? [String:Any] else { print("no dict snapshot"); return }
                    let newproduct = Product(dict: dict)
                    newproduct.savedAt = id.value
                    products.append(newproduct)
                    completion(products)
                })
            })
            //get here if there are no products...
            completion(products)
        })
    }
    
    
    func fetchUserMedia(completion: @escaping ([Youtube]) -> Void) {
        guard let user = currentUser else { print("no user"); return }
        let userMedia = currentUserNode.child(user.uid).child("favorites").child("media")
        userMedia.observe(.value, with: { (snapshot) in
            
            //Key is product ID, value is the timestamp
            var idsToRetrieve = [String:String]()
            snapshot.children.forEach {
                let snapShotValue = $0 as? FIRDataSnapshot
                guard let ID = snapShotValue?.key else { print("couldn't get ID from snapshot"); return }
                
                let media = snapShotValue?.value as? [String:Any]
                
                if let isFavorite = media?["isFavorite"]  {
                    if isFavorite as? Bool == true {
                        idsToRetrieve[ID] = media?["timestamp"] as? String
                    }
                }
            }
            
            var youtubes = [Youtube]()
            var i = 0
            if idsToRetrieve.count == 0 {
                completion(youtubes)
            }
            idsToRetrieve.forEach({ (id) in
                YoutubeAPIClient.getSingleYoutubeVideo(id: id.key, completion: { (video) in
                    video.savedAt = id.value
                    youtubes.append(video)
                    i += 1
                    if i == idsToRetrieve.count {
                        completion(youtubes)
                    }
                })
            })
            
            
        })
    }
}
