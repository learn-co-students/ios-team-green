//
//  ProductAPIClient.swift
//  MakeUp App
//
//  Created by Raquel Rahmey on 4/6/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import Foundation
import Alamofire

class ImageAPIClient {
    
    class func getProductImage(with imageUrlString: String, completion: @escaping (UIImage)-> ()) {
        Alamofire.request(imageUrlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:
            nil).validate().responseJSON { (response) in
                print("data is ", response)
            if let data = response.data {
                if let image = UIImage(data: data) {
                    completion(image)
                }
            }
        }
        
    }
    

}

