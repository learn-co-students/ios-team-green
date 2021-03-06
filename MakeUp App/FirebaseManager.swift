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
    var loginType: String?
    var emailId: String?
    
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
    
    /// User Functions FB signIn///
    
    func loadUser(_ userID: String, completion: @escaping () -> ()) {
        _ = FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            self.currentUser = user
            print("**In loadUser:currentUser: name:\(self.currentUser?.displayName), email:\(self.currentUser?.email) uid:\(self.currentUser?.uid)")
            completion()
        })
    }
    func createOrUpdate(_ user: FIRUser) {
        let name = user.displayName ?? "No name"
        currentUserNode.child(user.uid).updateChildValues(["name": name])
        currentUser = user
    }
    
    /// Email SignUp
    func createUser(email cu_email: String, password cu_password: String, name cu_name: String, handler: @escaping (Error?)->()) {
        FIRAuth.auth()?.createUser(withEmail: cu_email, password: cu_password, completion: { (user, error) in
            if let error = error {
               handler(error)
            } else {
                FIRAuth.auth()?.signIn(withEmail: cu_email, password: cu_password, completion: { (user, error) in
                    print("In createUser:signIn: uid: \(user?.uid) email:\(cu_email) name:\(cu_name)")
                    if let user = user {
                        
                        self.currentUser = user
                        UserDefaults.standard.set(user.uid, forKey: "userID")
                        self.currentUserNode.updateChildValues([ "/\(user.uid)/name" : cu_name])
                        handler(nil)
                    } else  {
                        handler(error)
                    }
                    
                })
            }
            
        })
    }
    
    func signInUser(email cu_email: String, password cu_password: String, handler: @escaping (Error?)->()) {
        FIRAuth.auth()?.signIn(withEmail: cu_email, password: cu_password) { (user, error) in
            if let error = error {
                handler(error)
            } else {
                self.currentUser = user
                UserDefaults.standard.set(user?.uid, forKey: "userID")
                handler(nil)
            }
        } //FIRAuth.auth()?.signIn
    }
    
    func getUserName(uid: String , handler:@escaping (String?)-> ()) {
        var username :String?
        FirebaseManager.shared.ref.child("Users/\(uid)").observeSingleEvent(of: .value, with: { (snapshot) in
            if let userData = snapshot.value as? [String: Any] {
                username = userData["name"] as? String
            }
           handler(username)
        })        
    }
    
    //Password Reset email
    func resetPassword(email: String , handler: @escaping (Error?)->()) {
        FIRAuth.auth()?.sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                handler(error)
            } else {
                handler(nil)
            }
        }
    }
    
    /// App Functions //
    
    
    func toggleProductFavorite(_ product: Product) {
        time = dateFormatter.string(from: Date())
        
        guard let user = currentUser else { print("no user"); return }
        let productID = product.identifier
        let productRecord = currentUserNode.child(user.uid).child("favorites").child("products")
        productRecord.observeSingleEvent(of: .value, with: { (snapshot) in
            if let favoriteRecord = snapshot.value as? [String:Any] {
                if let product = favoriteRecord[productID] as? [String:Any]  {
                    if product["isFavorite"] as? Bool == false {
                        productRecord.updateChildValues([productID: [ "isFavorite": true, "timestamp": self.time]])
                        print("User added product favorite")
                    } else   {
                        productRecord.updateChildValues([productID: [ "isFavorite": false, "timestamp": self.time]])
                        print("User removed favorite")
                    }
                }
                else {
                    print("adding a product record that wasn't there")
                    productRecord.updateChildValues([productID: [ "isFavorite": true, "timestamp": self.time]])
                }
            } else {
                print("adding a product record that wasn't there, and favorites products wasn't there yet either")
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
            if let favoriteRecord = snapshot.value as? [String:Any] {
                if let media = favoriteRecord[videoID] as? [String:Any]  {
                    if media["isFavorite"] as? Bool == false {
                        mediaRecord.updateChildValues([videoID: [ "isFavorite": true, "timestamp": self.time]])
                        print("User added media favorite")
                    } else {
                        mediaRecord.updateChildValues([videoID: [ "isFavorite": false, "timestamp": self.time]])
                        print("User removed media favorite")
                    }
                }
                else {
                    print("adding a media record that wasn't there")
                    mediaRecord.updateChildValues([videoID: [ "isFavorite": true, "timestamp": self.time]])
                }
            } else {
                print("adding a media record that wasn't there, and favorites media wasn't there yet either")
                mediaRecord.updateChildValues([videoID: [ "isFavorite": true, "timestamp": self.time]])
            }
        })
    }
    
    func addProductToDatabase(_ product: Product) {
        print("I am in add product to database")
        FIRDatabase.database().reference(withPath: "Products").child(product.identifier).setValue(product.toDict()) { (error, ref) in
            if error != nil {
                print("error adding to database", error as Any)
            } else {
                print ("added to database, the reference is", ref)
            }
        }
        
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
