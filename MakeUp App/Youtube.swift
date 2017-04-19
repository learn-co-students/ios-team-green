//
//  YoutubeModel.swift
//  MakeUp App
//
//  Created by Raquel Rahmey on 4/5/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Youtube: Object {
    dynamic var eTag: String = ""
    dynamic var videoID: String = ""
    dynamic var channelID: String = ""
    dynamic var channelTitle: String = ""
    dynamic var title: String = ""
    dynamic var thumbnailURL: String = ""
    dynamic var thumbnailWidth: Int = 0
    dynamic var thumbnailHeight: Int = 0
    dynamic var videoType: String = ""
    dynamic var publishedAt: String = ""
    dynamic var savedAt: String = "Never Saved"    

    
    convenience init(dictionary:JSON, videoType:String) {
        self.init()
        eTag = dictionary["etag"].stringValue
        
        // account for two methods of retrieving youtube, maybe there's a better way to do this but probably not
        videoID = dictionary["id"]["videoId"].stringValue
        if videoID == "" {
            videoID = dictionary["id"].stringValue
        }
        
        channelID = dictionary["snippet"]["channelId"].stringValue
        channelTitle = dictionary["snippet"]["channelTitle"].stringValue
        title = dictionary["snippet"]["title"].stringValue
        thumbnailURL = dictionary["snippet"]["thumbnails"]["high"]["url"].stringValue
        thumbnailWidth = dictionary["snippet"]["thumbnails"]["default"]["width"].intValue
        thumbnailHeight = dictionary["snippet"]["thumbnails"]["default"]["height"].intValue
        publishedAt = dictionary["snippet"]["publishedAt"].stringValue
        self.videoType = videoType
    }
    
    
}
 
