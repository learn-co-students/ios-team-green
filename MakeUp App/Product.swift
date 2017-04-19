//
//  ItemDetails.swift
//  ItemScanner
//
//  Created by ac on 4/4/17.
//  Copyright © 2017 amitc. All rights reserved.
//

import Foundation
import RealmSwift


class Product: Object  {
    dynamic var upc: String = ""
    dynamic var ean: String = ""
    dynamic var title: String = ""
    dynamic var productDescription: String = ""
    dynamic var brand: String = ""
    dynamic var model: String = ""
    dynamic var color: String = ""
    dynamic var size: String = ""
    dynamic var dimension: String = ""
    dynamic var weight: String = ""
    dynamic var currency: String = ""
    dynamic var imageURL: String = ""
    dynamic var price: Double = 0.0
    dynamic var savedAt: String = "Never Saved"
    var identifier: String {
        if upc != "" {
            return upc
        } else {
            return ean
        }
    }
    
    convenience init(dict:[String:Any]) {
        self.init()
        ean = dict["ean"] as? String ?? ""
        title = dict["title"] as? String ?? ""
        productDescription = dict["description"] as? String ?? (dict["title"] as? String) ?? ""
        upc = dict["upc"] as? String ?? ""
        brand = dict["brand"] as? String ?? ""
        model = dict["model"] as? String ?? ""
        color = dict["color"] as? String ?? ""
        size = dict["size"] as? String ?? ""
        dimension = dict["dimension"] as? String ?? ""
        weight = dict["weight"] as? String ?? ""
        currency = dict["currency"] as? String ?? ""
        imageURL = dict["image"] as? String ?? ""
        price = dict["price"] as? Double ?? 0
    }
    
    func toDict() -> [String:Any] {
        var dict = [String:Any]()
        
        dict["ean"] = self.ean
        dict["title"] = self.title
        dict["description"] = self.productDescription
        dict["upc"] = self.upc
        dict["brand"] = self.brand
        dict["model"] = self.model
        dict["color"] = self.color
        dict["size"] = self.size
        dict["dimension"] = self.dimension
        dict["weight"] = self.weight
        dict["currency"] = self.currency
        dict["image"] = self.imageURL
        dict["price"] = self.price
    
        return dict
    }
    
    
    
}
