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
    
    
    override init(frame:CGRect){
        super.init(frame:frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
