//
//  GoogleButton.swift
//  MakeUp App
//
//  Created by Benjamin Bernstein on 4/4/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import UIKit

class CircularButton: UIView {
    
    var text: String
    
    init(image: UIImage, text: String, size: CGFloat) {
        
        self.text = text
        
        super.init(frame: CGRect())
        
        self.backgroundColor = Palette.beige.color
        self.frame = CGRect(x: 0, y: 0, width: size, height: size)
        
        self.layer.cornerRadius = self.frame.width * 0.6
        self.clipsToBounds = true
        print("layercorner", self.layer.cornerRadius)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        self.addGestureRecognizer(gestureRecognizer)

        let imageView = UIImageView()
        let textView = UILabel()
        
        self.addSubview(imageView)
        self.addSubview(textView)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.topAnchor.constraint(equalTo: self.centerYAnchor, constant: 15).isActive = true
        textView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        textView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true

        imageView.bottomAnchor.constraint(equalTo: textView.topAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: textView.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: textView.widthAnchor, multiplier: 0.5).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        imageView.image = image
        
        textView.font = Fonts.Playfair(withStyle: .blackItalic, sizeLiteral: 16)
        textView.textColor = Palette.white.color
        textView.text = text
        textView.textAlignment = .center
    
    }
    
    func buttonTapped() {
        print(text, "button tapped")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
