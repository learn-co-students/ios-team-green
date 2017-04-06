//
//  ResultsViewController.swift
//  MakeUp App
//
//  Created by Benjamin Bernstein on 4/4/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import UIKit


class ResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let store = YoutubeDataStore.sharedInstance
    let reviewVideoTableView = UITableView()
    let thumbnailImage = UIImageView()
    var image = UIImage() {
        didSet {
            thumbnailImage.image = self.image
        }
    }
//    let tutorialVideoTableView = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewVideoTableView.delegate = self
        reviewVideoTableView.dataSource = self
//        tutorialVideoTableView.delegate = self
//        tutorialVideoTableView.dataSource = self
        view.backgroundColor = UIColor.green
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpView()
        super.viewWillAppear(animated)
        YoutubeAPIClient.getYoutubeThumbnailImage(with: "https://i.ytimg.com/vi/zqwurtVUOME/hqdefault.jpg") { (productImage) in
            DispatchQueue.main.async {
                self.image = productImage
            }
            
        }
        store.getYouTubeVideos(search: "kat von d tattoo liner", videoType: .review) {
            DispatchQueue.main.async {
                self.reviewVideoTableView.reloadData()
            }
        }
    }
    
    
    func setUpView() {
        reviewVideoTableView.frame = CGRect(x: 0, y: 50, width: view.frame.width, height: (view.frame.height/2))
        reviewVideoTableView.backgroundColor = UIColor.blue
        reviewVideoTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        thumbnailImage.frame = CGRect(x: 0, y: 350, width: view.frame.width, height: (view.frame.height/2))
        view.addSubview(reviewVideoTableView)
        view.addSubview(thumbnailImage)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.youtubeReviewVideos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let reviewVideo = store.youtubeReviewVideos[indexPath.row]
        cell.textLabel?.text = reviewVideo.title
        return cell
    }
    

}
