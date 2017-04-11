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
        
        let checkedSearch = truncateStringAfterNumberofWords(string: search, words: 4)
        
        let combinedSearch = checkedSearch + " " + type.rawValue
        print("combinedSearch is", combinedSearch)
        
        let validSearch = combinedSearch.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        print("valid search is", validSearch ?? "no search")
        
        let url = baseUrl + validSearch!
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            if let data = response.data {
                let json = JSON(data: data)
                let itemsArray = json["items"].arrayValue
                completion(itemsArray, type.rawValue)
            }
        }
    }
    
    class func getSingleYoutubeVideo(id: String, completion: @escaping (Youtube) -> ()) {
        let baseUrl = "https://www.googleapis.com/youtube/v3/videos?id=\(id)&key=\(Secrets.youTubeKey)&part=snippet"
        
        Alamofire.request(baseUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            if let data = response.data {
                let json = JSON(data: data)
                let items = json["items"].arrayValue
                let theVideo = items[0]
                let video = Youtube(dictionary: theVideo, videoType: "not applicable")
                completion(video)
            }
        }
    }
    
    
    
}

func truncateStringAfterNumberofWords(string: String, words: Int) -> String {
    var spaceCount = 0
    var whiteSpacePosition = 0
    var shouldBeCut = false
    for (index, value) in Array(string.characters).enumerated() {
        if value == " " {
            spaceCount += 1
            if spaceCount == words {
                whiteSpacePosition = index
                shouldBeCut = true
            }
        }
    }
    let startIndex = string.startIndex
    let endIndex = string.index(startIndex, offsetBy: whiteSpacePosition)
    if shouldBeCut {
        return string[startIndex...endIndex]
    } else {
        return string
    }
}

enum YoutubeSearch: String {
    
    case review, tutorial
    
}
