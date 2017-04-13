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
        titleLabel.text = myProduct.description
        print("product desp: \(myProduct.description) imageURL: \(myProduct.imageURL)")
        ImageAPIClient.getProductImage(with: myProduct.imageURL) { (productImage) in
            DispatchQueue.main.async {
                print("product is", myProduct.title, myProduct.imageURL)
                self.productImageView.image = productImage
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
        
        titleLabel.font = Fonts.Playfair(withStyle: .black, sizeLiteral: 16)
        titleLabel.numberOfLines = 3
        titleLabel.textAlignment = .left
        titleLabel.text = "No Title"
        titleLabel.textColor = Palette.black.color
        
        //set AutoresizingMask  & add to subView before setting constraints
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(productImageView)

        
        //let gap : CGFloat = 2
        //let imageSize : CGFloat = 50
        //productImageView.frame = CGRect(x: gap, y: gap, width: imageSize, height: imageSize)
        productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2).isActive = true
        
        //productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        productImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 2).isActive = true
        productImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1).isActive = true
        productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor).isActive = true
        
        productImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor , constant: -2).isActive = true
        
        

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleLabel)

        
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: productImageView.rightAnchor, constant: 10).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        //titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor , constant: -2).isActive = true
    }
    


}
