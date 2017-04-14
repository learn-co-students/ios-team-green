//
//  ProductAPIClient.swift
//  MakeUp App
//
//  Created by ac on 4/11/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import Foundation

class ProductAPIClient {
   
    //var targetData:[String:Any] = [:]
    
    func stringSearch(searchString:String, completion:@escaping ([Product])->()) {
        var result:[Product] = []
        let escapedSearchString = searchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "Url string conversion failed"
        
        print("**In ProductAPIClient:stringSearch string: \(searchString) escapedSearchString:\(escapedSearchString)")

        let url = URL(string: "https://api.upcitemdb.com/prod/trial/search?s=\(escapedSearchString)&match_mode=0&type=product")
        guard let unwrappedUrl = url else { print("Invalid Url \(url?.absoluteString)"); return }
        let task = URLSession.shared.dataTask(with: unwrappedUrl) { (data, response, error) in
            if let unwrappedData = data {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: unwrappedData, options: []) as? [String:Any] else {
                        print("Invalid JSONSerialization"); return
                    }
                    //print("json=\(json)")
                    guard let itemsData = json["items"] as? [[String:Any]] else {
                        print("Cannot convert json to dictionary array"); return
                    }
             
                    for item in itemsData {
                        print("**item=\(item)")
                        var targetData:[String:Any]
                        
                        targetData = item
                        print("item[images]:", item["images"] ?? "No Image")
                        let imageArray = item["images"] as? [String] ?? ["No Image"]
                        //let image = imageArray[0]
                        if !(imageArray.isEmpty) {
                            targetData["image"] = imageArray[0]
                        } else {
                            targetData["image"] = "No Image" ;
                            print("imageArray is empty")
                        }
                        
                        print("THE DICITONARY IMAGE IS", targetData["image"] ?? "No Image" )
                        let product = Product(dict:targetData)
                        result.append(product)
                    }
                
                    completion(result)
                } catch {  }
            }
            
        }
        task.resume()
 
    } //func stringSearch
    
}
