//
//  RealmManager.swift
//  MakeUp App
//
//  Created by Raquel Rahmey on 4/19/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmManager {
    
    static let shared = RealmManager()
    
    func saveVideoToRealm(youtube: Youtube) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(youtube)
        }
        print("just saved this video to realm", youtube.title)
        retrieveVideos()
    }
    
    func deleteVideoFromFavorite(youtube: Youtube) {
        let realm = try! Realm()
        realm.delete(youtube)
    }
    
    func retrieveVideos() {
        let realm = try! Realm()
        let videos = realm.objects(Youtube.self)
        print("saved videos are", videos)
    }
    
    func saveProductToRealm(product: Product) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(product)
        }
        print("just saved this product to realm", product.title)
        retrieveVideos()
    }
    
    func deleteProductFromFavorite(product: Product) {
        let realm = try! Realm()
        realm.delete(product)
    }
    
    func retrieveProducts() {
        let realm = try! Realm()
        let products = realm.objects(Product.self)
        print("saved products are", products)
    }
    
    
}
