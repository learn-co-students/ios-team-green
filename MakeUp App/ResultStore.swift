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
    
    var youtubeReviewVideos = [Youtube]()
    var youtubeTutorialVideos = [Youtube]()
    
    var product: Product?
    
    func getYouTubeVideos(search: String, completion: @escaping () -> ()) {
        var finishedQueries = 0 {
            didSet {
                if finishedQueries == 2 {
                    print("finished queries is", finishedQueries)
                    completion()
                }
            }
        }
        
        YoutubeAPIClient.searchYoutubeVideos(search: search, type: .tutorial) { (youtubeVideosDictionary, typeString) in
            self.youtubeTutorialVideos.removeAll()
            for video in youtubeVideosDictionary {
                let youtubeVideo = Youtube(dictionary: video, videoType: typeString)
                self.youtubeTutorialVideos.append(youtubeVideo)
            }
            finishedQueries += 1
        }
        
        YoutubeAPIClient.searchYoutubeVideos(search: search, type: .review) { (youtubeVideosDictionary, typeString) in
            self.youtubeReviewVideos.removeAll()
            for video in youtubeVideosDictionary {
                let youtubeVideo = Youtube(dictionary: video, videoType: typeString)
                self.youtubeReviewVideos.append(youtubeVideo)
            }
            finishedQueries += 1
        }
        
    }
}
