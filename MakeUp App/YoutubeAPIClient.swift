//
//  YoutubeAPIClient.swift
//  MakeUp App
//
//  Created by Raquel Rahmey on 4/4/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import Foundation
import Alamofire

final class YoutubeAPIClient{
    

    class func searchYoutubeVideos(search: String, type: YoutubeSearch) {
        let baseUrl = "https://www.googleapis.com/youtube/v3/search?key=\(Secrets.youTubeKey)&part=snippet&type=video&maxResults=50&q="
        let tutorialSearch = search + type.rawValue
        let validSearch = tutorialSearch.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let searchQuery = validSearch else {print("search could not be converted"); return }
        let url = baseUrl + searchQuery
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (dataResponse) in
            if let JSON = dataResponse.data {
                print(dataResponse)
                print(dataResponse.result)
                print(JSON)
            }
        }
    }
    

}

enum YoutubeSearch: String{
    
    case review, tutorial
    
}
