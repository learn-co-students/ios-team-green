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
        self.backgroundColor = Palette.black.color
        setupConstraints()
    }
    
    func setUpCell() {
        contentView.backgroundColor = Palette.white.color
        guard let youtube = youtube else { print("could not get youtube"); return }
        ImageAPIClient.getProductImage(with: (youtube.thumbnailURL)) { (thumbnailImage) in
            DispatchQueue.main.async {
                self.imageView.image = thumbnailImage
                //self.imageView.contentMode = UIViewContentMode.center
                //self.imageView.contentMode = UIViewContentMode.scaleAspectFill
                
            }
        }
        titleView.text = youtube.title
    }
    
    func setupConstraints() {
        
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
        
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.90).isActive = true
        imageView.heightAnchor.constraint(lessThanOrEqualTo: contentView.heightAnchor, multiplier: 0.80).isActive = true
        
        heartImage.image = #imageLiteral(resourceName: "Heart")
        heartImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5).isActive = true
        heartImage.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5).isActive = true
        heartImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.07).isActive = true
        heartImage.heightAnchor.constraint(equalTo: heartImage.widthAnchor).isActive = true
        


        
         titleView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant:5).isActive = true
        titleView.leftAnchor.constraint(equalTo: heartImage.rightAnchor, constant: 5).isActive = true
         titleView.centerYAnchor.constraint(equalTo: heartImage.centerYAnchor).isActive = true
        titleView.heightAnchor.constraint(greaterThanOrEqualTo: heartImage.heightAnchor, multiplier: 1.0).isActive = true
    }
    
    //finish up title truncation 
    func fixTitle(title: String)-> String {
        guard let youtubeTitle = youtube?.title else { return ""}
        let numberOfWords = youtubeTitle.components(separatedBy: " ")
        if numberOfWords.count > 5 {
        } else {
            return youtubeTitle
        }
        return ""
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
