//  TutorialsViewController.swift
//  MakeUp App
//
//  Created by Benjamin Bernstein on 4/4/17.
//  Copyright © 2017 Benjamin Bernstein. All rights reserved.

import UIKit

class YouTubeViewController: UITableViewController {
    
    var videos = [Youtube]()
    var type: String?
    let bottomBar = BottomBarView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Palette.white.color
        
        if type == "Tutorials" {
            print("tutorials 21")
            if let product = ResultStore.sharedInstance.product {
                ResultStore.sharedInstance.getYouTubeVideos(search: product.title, videoType: .tutorial, completion: {
                    print("results")
                    self.videos = ResultStore.sharedInstance.youtubeTutorialVideos
                    print("self.videos is", self.videos.count)
                    self.tableView.reloadData()
                })
            }
            
        } else {
            videos = ResultStore.sharedInstance.youtubeReviewVideos
        }
        
        tableView.register(YoutubePreviewCell.self, forCellReuseIdentifier: "tutorialCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        if let type = type {
            navBar(title: type, leftButton: .back, rightButton: .buy)
        }
        BottomBarView.constrainBottomBarToEdges(viewController: self, bottomBar: bottomBar)
    }
    
    //MARK: - Table View Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tutorialCell", for: indexPath) as! YoutubePreviewCell
        cell.youtube = videos[indexPath.item]
        
        // see if the cell video is already a favorite from the user store, then make it a favorite if so
        if UserStore.sharedInstance.favoriteMedia.contains(where: { (video) -> Bool in
            video.videoID == cell.youtube?.videoID
        }) {
            cell.isFavorite = true
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("number of rows as video count is", videos.count)
        return videos.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = YouTubePlayerViewViewController()
        let cell = videos[indexPath.item]
        destinationVC.youtubeID = cell.videoID
        destinationVC.modalPresentationStyle = .overCurrentContext
        destinationVC.modalTransitionStyle = .crossDissolve
        present(destinationVC, animated: true, completion: {
        })
    }
    
    
}
