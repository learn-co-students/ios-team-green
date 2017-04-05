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
    
    let heartLabel: UIButton!
    let image: UIImageView!
    let title: UILabel

    var product: Product {
        didSet {
            setUpCell()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setUpCell() {
        
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
