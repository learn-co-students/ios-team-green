//  TutorialsViewController.swift
//  MakeUp App
//
//  Created by Benjamin Bernstein on 4/4/17.
//  Copyright © 2017 Benjamin Bernstein. All rights reserved.

import UIKit

class YouTubeViewController: UITableViewController {
    
    let resultStore = ResultStore.sharedInstance

    var videos = [Youtube]()
    var type: String?
    let bottomBar = BottomBarView()
    var product = ResultStore.sharedInstance.product {
        didSet {
            getVideos()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Palette.white.color

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let type = type else { print("no type registered"); return }
        
        tableView.register(YoutubePreviewCell.self, forCellReuseIdentifier: "tutorialCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        navBar(title: type, leftButton: .back, rightButton: .buy)
        BottomBarView.constrainBottomBarToEdges(viewController: self, bottomBar: bottomBar)
        
        // TODO reached type controller so it can update its current index
        NotificationCenter.default.post(name: <#T##NSNotification.Name#>, object: nil)
        
        super.viewWillAppear(true)
        self.product = resultStore.product
    }
    
    func getVideos() {
        if let product = ResultStore.sharedInstance.product {
            guard let type = type else { print("no type registered"); return }
            ResultStore.sharedInstance.getYouTubeVideos(search: product.title, videoType: determineType(type: type), completion: {
                self.videos = ResultStore.sharedInstance.youtubeTutorialVideos
                self.tableView.reloadData()
            })
        }
        
    }
    
    func determineType(type: String) -> YoutubeSearch {
        switch type {
        case "Tutorials":
            return .tutorial
        default:
            return .review
        }
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
