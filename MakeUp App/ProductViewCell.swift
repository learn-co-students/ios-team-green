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
    
    var favoriteButton = UIButton()
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
        guard let myProduct = product else { print("could not get product"); return  }
        titleView.text = myProduct.title
        ImageAPIClient.getProductImage(with: myProduct.imageURL) { (productImage) in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.2, animations: { 
                    self.imageView.image = productImage
                })
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
        
        contentView.addSubview(favoriteButton)
       
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.setImage(#imageLiteral(resourceName: "Heart"), for: .normal)
        favoriteButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        favoriteButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        favoriteButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.15).isActive = true
        favoriteButton.heightAnchor.constraint(equalTo: favoriteButton.widthAnchor).isActive = true
        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleView)
        
        titleView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        titleView.leftAnchor.constraint(equalTo: favoriteButton.rightAnchor, constant: 10).isActive = true
        titleView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 10).isActive = true
        
    }
    
    func toggleFavorite() {
        guard let product = product else { return }
        FirebaseManager.shared.toggleFavorite(product)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
