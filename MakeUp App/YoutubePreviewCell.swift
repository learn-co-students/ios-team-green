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
        self.backgroundColor = Palette.black.color
        setupConstraints()
    }
    
    func setUpCell() {
        self.layoutIfNeeded()
        contentView.backgroundColor = Palette.white.color
        guard let youtube = youtube else { print("could not get youtube"); return }
        titleView.text = youtube.title
        ImageAPIClient.getProductImage(with: (youtube.thumbnailURL)) { (thumbnailImage) in
            DispatchQueue.main.async {
                self.imageView?.image = thumbnailImage
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

        titleView.textAlignment = .center
        titleView.text = youtube?.title
        titleView.font = Fonts.Playfair(withStyle: .black, sizeLiteral: 14)
        titleView.textColor = Palette.darkGrey.color
        titleView.numberOfLines = 0
        self.contentView.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView?.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView?.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        imageView?.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.90).isActive = true
        imageView?.heightAnchor.constraint(lessThanOrEqualTo: contentView.heightAnchor, multiplier: 0.80).isActive = true
        
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(favoriteButton)

        favoriteButton.setImage(#imageLiteral(resourceName: "Empty-Heart"), for: .normal)
        favoriteButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5).isActive = true
        favoriteButton.topAnchor.constraint(equalTo: (imageView?.bottomAnchor)!, constant: 5).isActive = true
        favoriteButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.07).isActive = true
        favoriteButton.heightAnchor.constraint(equalTo: favoriteButton.widthAnchor).isActive = true
        favoriteButton.addTarget(self, action: #selector(toggleMediaFavorite), for: .touchUpInside)

        titleView.topAnchor.constraint(equalTo: (imageView?.bottomAnchor)!, constant:5).isActive = true
        titleView.leftAnchor.constraint(equalTo: favoriteButton.rightAnchor, constant: 5).isActive = true
        titleView.centerYAnchor.constraint(equalTo: favoriteButton.centerYAnchor).isActive = true
        titleView.heightAnchor.constraint(greaterThanOrEqualTo: favoriteButton.heightAnchor, multiplier: 1.0).isActive = true
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
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIColor {
    class func getRandomColor() -> UIColor {
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
