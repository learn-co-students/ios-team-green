//
//  ViewController.swift
//  MakeUp App
//
//  Created by Raquel Rahmey on 4/4/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let store = YoutubeDataStore.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        store.getYouTubeVideos(search: "kate von d tattoo liner", videoType: .review)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(store.youtubeReviewVideos)
        print(store.youtubeTutorialVideos)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

