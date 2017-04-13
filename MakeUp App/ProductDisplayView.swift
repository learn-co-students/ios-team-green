//
//  ProductDisplayCell.swift
//  MakeUp App
//
//  Created by Raquel Rahmey on 4/6/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import Foundation
import UIKit

class ProductDisplayView: UIView {
    
    var imageView = UIImageView()
    var productTitle = UILabel()
    var heartImage = UIImageView()
    var favoriteButton = UIButton()
    var product: Product? {
        didSet{
            setUpView()
            setupConstraints()

        }
    }

    let resultStore = ResultStore.sharedInstance
    
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Palette.white.color
    }
    
    func setUpView() {
        guard let product = product else { print("could not get product"); return }
        ImageAPIClient.getProductImage(with: (product.imageURL)) { (productImage) in
            DispatchQueue.main.async {
                self.imageView.image = productImage
                print("image is", productImage)
            }
        }
    }
    
    func setupConstraints() {
        guard let product = product else { print("could not get product"); return }
        let imageItems = [imageView, heartImage]
        imageItems.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        let labelItems = [productTitle]
        labelItems.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        productTitle.text = product.title
        productTitle.textAlignment = .left
        productTitle.font = Fonts.Playfair(withStyle: .bold, sizeLiteral: 25)
        productTitle.textColor = Palette.black.color
        productTitle.numberOfLines = 0
        
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        
        productTitle.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 20).isActive = true
        productTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        productTitle.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive = true
        
        
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
