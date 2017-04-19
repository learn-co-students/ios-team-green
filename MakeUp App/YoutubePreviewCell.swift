//
//  File.swift
//  MakeUp App
//
//  Created by Raquel Rahmey on 4/6/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import Foundation
import UIKit

class YoutubePreviewCell: UITableViewCell {
        
    var favoriteButton = UIButton()
    var titleView = UILabel()
    var thumbnailView = UIImageView()
    var youtube: Youtube? {
        didSet {
            setUpCell()
        }
    }
    
    var isFavorite = false {
        didSet {
          determineFavorite()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = Palette.white.color
        setupConstraints()
    }
    
    func setUpCell() {
        self.layoutIfNeeded()
        contentView.backgroundColor = Palette.white.color
        let whiteBackgroundView = UIView()
        whiteBackgroundView.backgroundColor = Palette.white.color
        self.selectedBackgroundView = whiteBackgroundView
        
        guard let youtube = youtube else { return }
        titleView.text = truncateStringAfterNumberofWords(string: youtube.title, words: 8)
        ImageAPIClient.getProductImage(with: (youtube.thumbnailURL)) { (thumbnailImage) in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.2, animations: { 
                    self.thumbnailView.image = thumbnailImage
                })
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
        }
    }
    
    func setupConstraints() {
        let items = [imageView]
        items.forEach { (item) in
            if let item = item {
                self.contentView.addSubview(item)
                item.translatesAutoresizingMaskIntoConstraints = false
            }   
        }

        titleView.textAlignment = .left
        titleView.text = youtube?.title
        titleView.font = Fonts.Playfair(withStyle: .italic, sizeLiteral: 18)
        titleView.textColor = Palette.darkGrey.color
        titleView.numberOfLines = 0
        self.contentView.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(thumbnailView)
        thumbnailView.translatesAutoresizingMaskIntoConstraints = false
        
        thumbnailView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        thumbnailView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        thumbnailView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8).isActive = true
        thumbnailView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8).isActive = true
        thumbnailView.contentMode = UIViewContentMode.scaleAspectFit
        
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(favoriteButton)

        favoriteButton.setImage(#imageLiteral(resourceName: "Empty-Heart"), for: .normal)
        favoriteButton.leftAnchor.constraint(equalTo: thumbnailView.leftAnchor, constant: 5).isActive = true
        favoriteButton.topAnchor.constraint(equalTo: titleView.topAnchor).isActive = true
        favoriteButton.heightAnchor.constraint(equalTo: favoriteButton.widthAnchor).isActive = true
        favoriteButton.addTarget(self, action: #selector(toggleMediaFavorite), for: .touchUpInside)

        titleView.topAnchor.constraint(equalTo: thumbnailView.bottomAnchor, constant: 5).isActive = true
        titleView.leftAnchor.constraint(equalTo: favoriteButton.rightAnchor, constant: 5).isActive = true
        titleView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 5).isActive = true
    }
    
    func determineFavorite() {
        if self.isFavorite {
            favoriteButton.setImage(#imageLiteral(resourceName: "Heart"), for: .normal)
        } else {
            favoriteButton.setImage(#imageLiteral(resourceName: "Empty-Heart"), for: .normal)
        }
    }
    
    func toggleMediaFavorite() {
        if !isFavorite {
            favoriteButton.setImage(#imageLiteral(resourceName: "Heart"), for: .normal)
            isFavorite = true
        } else {
            favoriteButton.setImage(#imageLiteral(resourceName: "Empty-Heart"), for: .normal)
            isFavorite = false

        }
        guard let youtube = youtube else { return }
        FirebaseManager.shared.toggleMediaFavorite(youtube)
    }
    
    override func prepareForReuse() {
        self.isFavorite = false
        self.youtube = nil
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

