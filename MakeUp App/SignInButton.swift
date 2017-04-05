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

        let returnString = NSMutableAttributedString()
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        imageAttachment.bounds = CGRect(x: 0, y: -10, width: 30, height: 30)
        let imageString = NSAttributedString(attachment: imageAttachment)
        
        returnString.append(imageString)
        
        let signIn = NSMutableAttributedString(string: text, attributes: [NSForegroundColorAttributeName: Palette.white.color])
        returnString.append(signIn)
        
        self.setAttributedTitle(returnString, for: .normal)
        
        self.titleLabel?.font = Fonts.Playfair(withStyle: .black, sizeLiteral: 16)
        self.backgroundColor = Palette.beige.color
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
