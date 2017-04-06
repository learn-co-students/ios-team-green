//
//  ProductDisplayCell.swift
//  MakeUp App
//
//  Created by Raquel Rahmey on 4/6/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import Foundation
import UIKit

class ProductDisplayCell: UIView {
    
    var imageView = UIImageView()
    var productTitle = UILabel()
    var productPrice = UILabel()
    var heartImage = UIImageView()
    var product = Product()
//        didSet{
//            setUpView()
//        }

    
    
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Palette.white.color
        print("the product is ", product.imageURL)
        setUpView()
        setupConstraints()
    }
    
    func setUpView() {
        ProductAPIClient.getProductImage(with: (product.imageURL)) { (productImage) in
            print("i have suucessfully come back from the internet")
            DispatchQueue.main.async {
                self.imageView.image = productImage
                
            }
        }
    }
    
    func setupConstraints() {
        let imageItems = [imageView, heartImage]
        imageItems.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        let labelItems = [productPrice, productTitle]
        labelItems.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        productTitle.text = product.title
        productTitle.textAlignment = .left
        productTitle.font = Fonts.Playfair(withStyle: .bold, sizeLiteral: 25)
        productTitle.textColor = Palette.black.color
        productTitle.numberOfLines = 0
        
        productPrice.text = "$" + String(product.price)
        productPrice.textAlignment = .left
        productPrice.font = Fonts.Playfair(withStyle: .regular, sizeLiteral: 15)
        productPrice.textColor = Palette.darkGrey.color
        productPrice.numberOfLines = 0
        
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        
        productTitle.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 20).isActive = true
        productTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        productTitle.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive = true
        
        productPrice.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 20).isActive = true
        productPrice.topAnchor.constraint(equalTo: productTitle.bottomAnchor, constant: 10).isActive = true
        productPrice.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true 
        
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
