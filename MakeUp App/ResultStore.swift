//
//  videoDataStore.swift
//  MakeUp App
//
//  Created by Raquel Rahmey on 4/5/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import Foundation


final class ResultStore {
    static let sharedInstance = ResultStore()
    private init() {}
    
    var youtubeReviewVideos:[Youtube] = []
    var youtubeTutorialVideos:[Youtube] = []
    var product: Product?

    
    
    func getYouTubeVideos(search: String, videoType: YoutubeSearch, completion: @escaping () -> ()) {
        YoutubeAPIClient.searchYoutubeVideos(search: search, type: videoType) { (youtubeVideosDictionary, typeString) in
            if typeString == "review" {
                self.youtubeReviewVideos.removeAll()
                for video in youtubeVideosDictionary {
                    let youtubeVideo = Youtube(dictionary: video, videoType: typeString)
                    self.youtubeReviewVideos.append(youtubeVideo)
                }
                completion()
            } else {
               self.youtubeTutorialVideos.removeAll()
                for video in youtubeVideosDictionary {
                    let youtubeVideo = Youtube(dictionary: video, videoType: typeString)
                    self.youtubeTutorialVideos.append(youtubeVideo)
                }
                completion()
            }
        }
    }
}
