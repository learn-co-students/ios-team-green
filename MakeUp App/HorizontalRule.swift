//
//  HorizontalRule.swift
//  MakeUp App
//
//  Created by Benjamin Bernstein on 4/6/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import UIKit

class HorizontalRule: UIView {
    
    init() {
        let frame = CGRect.zero
        super.init(frame: frame)
        self.backgroundColor = Palette.beige.color
        self.heightAnchor.constraint(equalToConstant: 2).isActive = true
        self.frame = frame
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

