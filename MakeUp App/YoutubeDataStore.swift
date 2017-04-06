//
//  videoDataStore.swift
//  MakeUp App
//
//  Created by Raquel Rahmey on 4/5/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import Foundation


final class YoutubeDataStore {
    static let sharedInstance = YoutubeDataStore()
    private init() {}
    
    var youtubeReviewVideos:[YoutubeModel] = []
    var youtubeTutorialVideos:[YoutubeModel] = []
    
    
    func getYouTubeVideos(search: String, videoType: YoutubeSearch, completion: @escaping () -> ()) {
        YoutubeAPIClient.searchYoutubeVideos(search: search, type: videoType) { (youtubeVideosDictionary, typeString) in
            if typeString == "review" {
                self.youtubeReviewVideos.removeAll()
                for video in youtubeVideosDictionary {
                    let youtubeVideo = YoutubeModel(dictionary: video, videoType: typeString)
                    self.youtubeReviewVideos.append(youtubeVideo)
                }
                completion()
            } else {
               self.youtubeTutorialVideos.removeAll()
                for video in youtubeVideosDictionary {
                    let youtubeVideo = YoutubeModel(dictionary: video, videoType: typeString)
                    self.youtubeTutorialVideos.append(youtubeVideo)
                }
                completion()
            }
        }
    }
}
