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
        
        
        let spaceCount = search.characters.filter { $0 == " " }.count
        var checkedSearch = ""
        if spaceCount > 4 {
            checkedSearch = truncateStringAfterWhiteSpace(string: search, words: 4)
        } else {
            checkedSearch = search
        }
        
        let combinedSearch = checkedSearch + type.rawValue
        print("combinedSearch is", combinedSearch)

        let validSearch = combinedSearch.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        print("valid search is", validSearch)
        
        let url = baseUrl + validSearch!
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            if let data = response.data {
                let json = JSON(data: data)
                let itemsArray = json["items"].arrayValue
                completion(itemsArray, type.rawValue)
            }
        }
    }
    
    
    
}

func truncateStringAfterWhiteSpace(string: String, words: Int) -> String {
    var whiteCount = 0
    var whiteSpacePosition = 0
    for (index, value) in Array(string.characters).enumerated() {
        if value == " " {
            whiteCount += 1
            if whiteCount == words {
                whiteSpacePosition = index
            }
        }
    }
    let startIndex = string.startIndex
    let endIndex = string.index(startIndex, offsetBy: whiteSpacePosition)
    return string[startIndex...endIndex]
}

enum YoutubeSearch: String {
    
    case review, tutorial
    
}
