//
//  youTubePlayerViewViewController.swift
//  MakeUp App
//
//  Created by Raquel Rahmey on 4/6/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class YouTubePlayerViewViewController: UIViewController {
    
    let playerView = YTPlayerView()
    var youtubeID = ""

    override func viewDidLoad() {
        super.viewDidLoad()
//        let blurEffect = UIBlurEffect(style: .extraLight)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = view.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        view.addSubview(blurEffectView)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        setUpGestureRecognizer()
        self.playerView.load(withVideoId: youtubeID)
        setUpConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpConstraints() {
        self.view.addSubview(playerView)
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        playerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        playerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
    }

    func setUpGestureRecognizer() {
        let gestureRecog = UITapGestureRecognizer(target: self, action: #selector(dismissView(tap:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(gestureRecog)
    }
    
    func dismissView(tap: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }

}
