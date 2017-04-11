//
//  CollectionViewCell.swift
//  MakeUp App
//
//  Created by Benjamin Bernstein on 4/5/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import Foundation
import UIKit

class MediaViewCell: UICollectionViewCell {
    static let reuseIdentifier = "mediaCell"
    
    var favoriteButton = UIButton()
    var imageView = UIImageView()
    var titleView = UILabel()
    
    var youtube: Youtube? {
        didSet {
            setUpCell()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Palette.white.color
        setupConstraints()
    }
    
    func setUpCell() {
        guard let youtube = youtube else {print("could not get youtube"); return}
        titleView.text = youtube.title
        ImageAPIClient.getProductImage(with: youtube.thumbnailURL) { (image) in
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
    
    func setupConstraints() {
        titleView = UILabel()
        titleView.font = Fonts.Playfair(withStyle: .black, sizeLiteral: 16)
        titleView.numberOfLines = 0
        titleView.textAlignment = .left
        titleView.text = "No Title"
        titleView.textColor = Palette.darkGrey.color
        
        let items = [imageView]
        items.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview($0)
        }

        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(favoriteButton)
        
        favoriteButton.setImage(#imageLiteral(resourceName: "Heart"), for: .normal)
        favoriteButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        favoriteButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        favoriteButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.15).isActive = true
        favoriteButton.heightAnchor.constraint(equalTo: favoriteButton.widthAnchor).isActive = true
        favoriteButton.addTarget(self, action: #selector(toggleMediaFavorite), for: .touchUpInside)

        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleView)
        
        titleView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        titleView.leftAnchor.constraint(equalTo: favoriteButton.rightAnchor, constant: 10).isActive = true
        titleView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 10).isActive = true
        
    }

    func toggleMediaFavorite() {
        guard let youtube = youtube else { return }
        print("line 82 is real")
        FirebaseManager.shared.toggleMediaFavorite(youtube)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
