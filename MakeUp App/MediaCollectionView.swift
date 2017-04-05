//
//  MediaCollectionView.swift
//  MakeUp App
//
//  Created by Benjamin Bernstein on 4/5/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import UIKit

class MediaCollectionView: UICollectionView {
    
    init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.setCollectionViewLayout(layout, animated: true)
        self.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
        self.backgroundColor = Palette.white.color
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
