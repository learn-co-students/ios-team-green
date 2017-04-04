//
//  GoogleButton.swift
//  MakeUp App
//
//  Created by Benjamin Bernstein on 4/4/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import UIKit

class SignInButton: UIButton {
    
    init(image: UIImage, text: String) {
        super.init(frame: CGRect())

        let googleString = NSMutableAttributedString()
        
        let googleImage = NSTextAttachment()
        googleImage.image = image
        googleImage.bounds = CGRect(x: 0, y: -10, width: 30, height: 30)
        let googlePictureString = NSAttributedString(attachment: googleImage)
        
        googleString.append(googlePictureString)
        
        let googleSignIn = NSMutableAttributedString(string: text, attributes: [NSForegroundColorAttributeName: Palette.white.color])
        googleString.append(googleSignIn)
        
        self.setAttributedTitle(googleString, for: .normal)
        
        self.titleLabel?.font = Fonts.Playfair(withStyle: .black, sizeLiteral: 16)
//        self.titleLabel?.textAlignment = .right
        self.backgroundColor = Palette.beige.color
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
