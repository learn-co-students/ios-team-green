//
//  YoutubeAPIClient.swift
//  MakeUp App
//
//  Created by Raquel Rahmey on 4/4/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

final class YoutubeAPIClient {
    
    class func searchYoutubeVideos(search: String, type: YoutubeSearch, completion: @escaping ([JSON], String) -> ()) {
        let baseUrl = "https://www.googleapis.com/youtube/v3/search?key=\(Secrets.youTubeKey)&part=snippet&type=video&maxResults=50&q="
        let tutorialSearch = search + type.rawValue
        let validSearch = tutorialSearch.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        //Make max length 70 characters
        guard var shorterSearch = validSearch else { return }
        if shorterSearch.characters.count > 70 {
            let lowBound = shorterSearch.startIndex
            let hiBound = shorterSearch.index(shorterSearch.startIndex, offsetBy: 70)
            let midRange = lowBound ..< hiBound
            shorterSearch.removeSubrange(midRange)
        }
        
        let searchQuery = shorterSearch
        let url = baseUrl + searchQuery
        print("url", url)
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            if let data = response.data {
                let json = JSON(data: data)
                let itemsArray = json["items"].arrayValue
                completion(itemsArray, type.rawValue)
            }
        }
    }
    
    class func getYoutubeThumbnailImage(with imageUrlString: String, completion: @escaping (UIImage)-> ()) {
        Alamofire.request(imageUrlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            if let data = response.data {
                if let image = UIImage(data: data) {
                    completion(image)
                }
            }
        }

    }
    
}

enum YoutubeSearch: String {
    
    case review, tutorial
    
}
