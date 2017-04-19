//
//  ProductCell.swift
//  MakeUp App
//
//  Created by Amit Chadha on 4/11/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import Foundation
import UIKit

class ProductCell: UITableViewCell {

    var titleLabel = UILabel()
    var productImageView = UIImageView()
    
    var product: Product? {
        didSet {
            setUpCell()
        }
    }

    func setUpCell() {
        guard let myProduct = product else { print("could not get product"); return  }
        titleLabel.text = truncateStringAfterNumberofWords(string: myProduct.title, words: 12)
        
        if myProduct.imageURL != "No Image" {
            ImageAPIClient.getProductImage(with: myProduct.imageURL) { (productImage) in
                DispatchQueue.main.async {
                    self.productImageView.image = productImage
                }
            }
            
        } else {
            DispatchQueue.main.async {
                self.productImageView.image = #imageLiteral(resourceName: "No-Image")
            }
        }
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    func setupConstraints() {
        
        titleLabel.font = Fonts.Playfair(withStyle: .italic, sizeLiteral: 20)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        titleLabel.text = "No Title"
        titleLabel.textColor = Palette.black.color
        
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(productImageView)
        
        productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        productImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1).isActive = true
        productImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.33).isActive = true
        productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        productImageView.contentMode = UIViewContentMode.scaleAspectFit

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleLabel)

        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: productImageView.rightAnchor, constant: 10).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    
    }
    
}
