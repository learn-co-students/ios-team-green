//
//  File.swift
//  MakeUp App
//
//  Created by Raquel Rahmey on 4/6/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import Foundation
import UIKit

class YoutubePreviewCell:UICollectionViewCell {
    static let reuseIdentifier = "youtubePreviewCell"
    
    var heartImage = UIImageView()
    var imageView = UIImageView()
    var titleView = UILabel()
    var youtube: Youtube? {
        didSet {
            setUpCell()
        }
    }
    
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Palette.white.color
        setupConstraints()
    }
    
    func setUpCell() {
        guard let youtube = youtube else { print("could not get youtube"); return }
        ImageAPIClient.getProductImage(with: (youtube.thumbnailURL)) { (thumbnailImage) in
            DispatchQueue.main.async {
                self.imageView.image = thumbnailImage
                self.imageView.contentMode = UIViewContentMode.scaleAspectFill
        
            }
        }
        titleView.text = youtube.title
    }

    func setupConstraints() {
        
        self.contentView.backgroundColor = UIColor.getRandomColor()
        let items = [ imageView, heartImage]
        items.forEach { (item) in
            self.contentView.addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
            
        }
        
        titleView.textAlignment = .left
        titleView.text = youtube?.title
        titleView.font = Fonts.Playfair(withStyle: .black, sizeLiteral: 14)
        titleView.textColor = Palette.darkGrey.color
        titleView.numberOfLines = 0
        self.contentView.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        
       

        
        heartImage.image = #imageLiteral(resourceName: "Heart")
        heartImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        heartImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        heartImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.07).isActive = true
        heartImage.heightAnchor.constraint(equalTo: heartImage.widthAnchor).isActive = true
        
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        imageView.leftAnchor.constraint(equalTo: heartImage.rightAnchor, constant: 30).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        
        titleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant:10).isActive = true
       titleView.leftAnchor.constraint(equalTo: imageView.rightAnchor).isActive = true
       // titleView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 5).isActive = true
       // titleView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.30).isActive = true
        
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
