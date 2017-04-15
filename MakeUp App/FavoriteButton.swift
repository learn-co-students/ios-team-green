//
//  FavoriteButton.swift
//  MakeUp App
//
//  Created by Benjamin Bernstein on 4/14/17.
//  Copyright © 2017 Benjamin Bernstein. All rights reserved.
//

import UIKit

class FavoriteButton: UIBarButtonItem {
    
    init(type: FavoriteType) {
        let heartImage = #imageLiteral(resourceName: "Heart").withRenderingMode(.alwaysOriginal)
        super.init()
        switch type {
        case .favorite:
            let heartImage = #imageLiteral(resourceName: "Heart").withRenderingMode(.alwaysOriginal)
            self.image = heartImage
            self.landscapeImagePhone = heartImage
            self.style = .plain
            self.target = self
            self.tag = 0
        default:
            let heartImage = #imageLiteral(resourceName: "Empty-Heart").withRenderingMode(.alwaysOriginal)
            self.image = heartImage
            self.landscapeImagePhone = heartImage
            self.style = .plain
            self.target = self
            self.tag = 1
        }
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum FavoriteType: String {
    case favorite, notFavorite
}
