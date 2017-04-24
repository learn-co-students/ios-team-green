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
    var youtubeTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        setUpGestureRecognizer()
        self.playerView.load(withVideoId: youtubeID)
        setUpConstraints()
        setUpSwipeGestureRecognizer()
        setUpNavBar()
        NotificationCenter.default.post(name: .toggleNav, object: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: .toggleNav , object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    func exitScreen() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUpConstraints() {
        self.view.addSubview(playerView)
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        playerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        playerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        
    }
    
    func setUpNavBar() {
        self.navigationItem.hidesBackButton = true
        let barButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(exitScreen))
        let font = Fonts.Playfair(withStyle: .bold, sizeLiteral: 22)
        barButtonItem.setTitleTextAttributes([NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.white], for: .normal)
        self.navigationItem.setLeftBarButton(barButtonItem, animated: true)

    }

    func setUpGestureRecognizer() {
        let gestureRecog = UITapGestureRecognizer(target: self, action: #selector(dismissView(tap:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(gestureRecog)
    }
    
    func setUpSwipeGestureRecognizer(){
        let gestureRecog = UISwipeGestureRecognizer(target: self, action: #selector(dismissView(tap:)))
        gestureRecog.direction = UISwipeGestureRecognizerDirection.right
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(gestureRecog)
        let gestureRecogTwo = UISwipeGestureRecognizer(target: self, action: #selector(dismissView(tap:)))
        gestureRecogTwo.direction = UISwipeGestureRecognizerDirection.down
        view.addGestureRecognizer(gestureRecogTwo)
    }
    
    
    
    func dismissView(tap: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    


}
