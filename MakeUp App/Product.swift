//
//  ItemDetails.swift
//  ItemScanner
//
//  Created by ac on 4/4/17.
//  Copyright © 2017 amitc. All rights reserved.
//

import Foundation


class Product {
    let upc: String
    let ean: String
    let title: String
    let description: String
    let brand: String
    let model: String
    let color: String
    let size: String
    let dimension: String
    let weight: String
    let currency: String
    let imageURL: String
    let price: Double
    var savedAt: String
    
    init(dict:[String:Any]) {
        ean = dict["ean"] as? String ?? ""
        title = dict["title"] as? String ?? ""
        description = dict["description"] as? String ?? (dict["title"] as? String) ?? ""
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
        savedAt = "Never Saved"
    }
    
    func toDict() -> [String:Any] {
        var dict = [String:Any]()
        
        dict["ean"] = self.ean
        dict["title"] = self.title
        dict["description"] = self.description
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
