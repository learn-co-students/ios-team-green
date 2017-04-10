//
//  YoutubeModel.swift
//  MakeUp App
//
//  Created by Raquel Rahmey on 4/5/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import Foundation
import SwiftyJSON



class Youtube {
    var eTag:String
    var videoID:String
    var channelID:String
    var channelTitle:String
    var title:String
    var thumbnailURL:String
    var thumbnailWidth: Int
    var thumbnailHeight: Int
    var videoType: String

    
    init(dictionary:JSON, videoType:String) {
        eTag = dictionary["etag"].stringValue
        videoID = dictionary["id"]["videoId"].stringValue
        channelID = dictionary["snippet"]["channelId"].stringValue
        channelTitle = dictionary["snippet"]["channelTitle"].stringValue
        title = dictionary["snippet"]["title"].stringValue
        thumbnailURL = dictionary["snippet"]["thumbnails"]["high"]["url"].stringValue
        thumbnailWidth = dictionary["snippet"]["thumbnails"]["default"]["width"].intValue
        thumbnailHeight = dictionary["snippet"]["thumbnails"]["default"]["height"].intValue
        self.videoType = videoType
    }
    
    
    
}
 
