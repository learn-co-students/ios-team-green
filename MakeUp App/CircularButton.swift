//
//  GoogleButton.swift
//  MakeUp App
//
//  Created by Benjamin Bernstein on 4/4/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import UIKit

protocol CircularButtonDelegate {
    func buttonTapped(sender: CircularButton)
}

class CircularButton: UIView {
    
    var title: String
    var delegate: CircularButtonDelegate?
    
    init(image: UIImage, title: String, size: CGFloat) {
        
        self.title = title
        
        super.init(frame: CGRect())
        
        self.backgroundColor = Palette.beige.color
        self.frame = CGRect(x: 0, y: 0, width: size, height: size)
        
        self.layer.cornerRadius = self.frame.width * 0.55
        self.clipsToBounds = true
        
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
        textView.text = title
        textView.textAlignment = .center
    
    }
    
    func buttonTapped() {
        delegate?.buttonTapped(sender: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
