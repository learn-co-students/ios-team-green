//  TutorialsViewController.swift
//  MakeUp App
//
//  Created by Benjamin Bernstein on 4/4/17.
//  Copyright © 2017 Benjamin Bernstein. All rights reserved.

import UIKit

class YouTubeViewController: UITableViewController {
    
    let resultStore = ResultStore.sharedInstance
    var videos = [Youtube]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var videosFound: Bool = true {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var type: YoutubeSearch?
    var product: Product? {
        didSet {
            getVideos()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Palette.white.color
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        updateProductIfNeeded()
        determineViewControllerType()
        registerTableViewMethods()
        
        guard let type = type else { print("no type registered"); return }
        
        navBar(title: type.rawValue, leftButton: .backToProduct, rightButton: .buy)
    }
    
    func updateProductIfNeeded() {
        videos.removeAll()
        if self.product?.title != resultStore.product?.title {
            self.product = resultStore.product
        }
    }
    
    func determineViewControllerType() {
        type == .review ? NotificationCenter.default.post(name: .reviewsVC, object: nil) : NotificationCenter.default.post(name: .tutorialsVC, object: nil)
    }
    
    func registerTableViewMethods() {
        tableView.register(YoutubePreviewCell.self, forCellReuseIdentifier: "tutorialCell")
        tableView.separatorColor = Palette.beige.color
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func getVideos() {
        print("called getvideos")
        if let product = ResultStore.sharedInstance.product {
            print("product at 51 is now", product.title)
            guard let type = type else { print("no type registered at 60"); return }
            print("type at 70 is", type)
            ResultStore.sharedInstance.getYouTubeVideos(search: product.title, completion: {
                print("\ncompleted a youtube search", "\nyoutubetutorialvideos # is", self.resultStore.youtubeTutorialVideos.count, "# youtubereviewvideos is", self.resultStore.youtubeReviewVideos.count)
                switch type {
                case .tutorial :
                    self.videos = self.resultStore.youtubeTutorialVideos
                default:
                    self.videos = self.resultStore.youtubeReviewVideos
                }
                if self.videos.isEmpty {
                    self.tableView.numberOfRows(inSection: 1)
                    self.videosFound = false
                }
                
            })
        }
        
    }
    
    private func determineType(type: String) -> YoutubeSearch {
        switch type {
        case "Tutorials":
            NotificationCenter.default.post(name: .tutorialsVC, object: nil)
            return .tutorial
        default:
            NotificationCenter.default.post(name: .reviewsVC, object: nil)
            return .review
        }
    }
    
    //MARK: - Table View Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if !videosFound { return NoVideoCell() }
                    
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
        //guard videos.count > 0 else  { return 1 }
        return videos.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let youTubePlayerVC = YouTubePlayerViewViewController()
        let cell = videos[indexPath.item]
        youTubePlayerVC.youtubeID = cell.videoID
        youTubePlayerVC.modalPresentationStyle = .overCurrentContext
        youTubePlayerVC.modalTransitionStyle = .crossDissolve
        present(youTubePlayerVC, animated: true, completion: {
        })
    }
    
    
}
