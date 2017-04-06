//
//  CollectionViewCell.swift
//  MakeUp App
//
//  Created by Benjamin Bernstein on 4/5/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import Foundation
import UIKit

class ProductViewCell: UICollectionViewCell {
    static let reuseIdentifier = "productCell"
    
    var heartImage = UIImageView()
    var imageView = UIImageView()
    var titleView = UILabel()
    
    var product: Product? {
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
        //
    }
    
    func setupConstraints() {
        titleView = UILabel()
        titleView.font = Fonts.Playfair(withStyle: .black, sizeLiteral: 16)
        titleView.numberOfLines = 0
        titleView.textAlignment = .left
        titleView.text = "Diorshow Mascara"
        titleView.textColor = Palette.darkGrey.color
        
        let items = [heartImage, imageView]
        items.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview($0)
        }
        
       
        imageView.image = #imageLiteral(resourceName: "DIORSHOW")
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        
        heartImage.image = #imageLiteral(resourceName: "Heart")
        heartImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        heartImage.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        heartImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.15).isActive = true
        heartImage.heightAnchor.constraint(equalTo: heartImage.widthAnchor).isActive = true
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleView)
        
        titleView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        titleView.leftAnchor.constraint(equalTo: heartImage.rightAnchor, constant: 10).isActive = true
        titleView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 10).isActive = true
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
