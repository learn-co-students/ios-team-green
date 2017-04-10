//
//  youTubePlayerViewViewController.swift
//  MakeUp App
//
//  Created by Raquel Rahmey on 4/6/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class youTubePlayerViewViewController: UIViewController {
    
    let playerView = YTPlayerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Palette.white.color
        self.playerView.load(withVideoId: "zqwurtVUOME")
        setUpConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpConstraints() {
        self.view.addSubview(playerView)
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        playerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        playerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        playerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
    }


}
