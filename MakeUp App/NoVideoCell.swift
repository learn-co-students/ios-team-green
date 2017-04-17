//
//  File.swift
//  MakeUp App
//
//  Created by Raquel Rahmey on 4/6/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import Foundation
import UIKit

class NoVideoCell: UITableViewCell {
    
    var titleView = UILabel()
    var thumbnailView = UIImageView()
 
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = Palette.white.color
        setupConstraints()
    }
    
    func setUpCell() {
        self.layoutIfNeeded()
        contentView.backgroundColor = Palette.white.color
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
        titleView.text = "Sorry, no videos found! \n Tap to Search"
        titleView.numberOfLines = 2
        titleView.font = Fonts.Playfair(withStyle: .black, sizeLiteral: 14)
        titleView.textColor = Palette.darkGrey.color
        self.contentView.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(thumbnailView)
        thumbnailView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailView.image = #imageLiteral(resourceName: "Placeholder")
        
        thumbnailView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        thumbnailView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        thumbnailView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9).isActive = true
        thumbnailView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8).isActive = true
        thumbnailView.contentMode = UIViewContentMode.scaleAspectFit
        
        titleView.topAnchor.constraint(equalTo: thumbnailView.bottomAnchor, constant:5).isActive = true
        titleView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

