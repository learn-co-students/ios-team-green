//
//  Fonts.swift
//  MakeUp App
//
//  Created by Benjamin Bernstein on 4/4/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import UIKit

enum PlayfairStyle: String {
    case black = "-Black"
    case blackItalic = "-BlackItalic"
    case bold = "-Bold"
    case boldItalic = "-BoldItalic"
    case italic = "-Italic"
    case regular = "-Regular"

}

struct Fonts {
    
    static func Playfair(withStyle style: PlayfairStyle, sizeLiteral: CGFloat) -> UIFont {
        if let safeFont = UIFont(name: "PlayfairDisplay\(style.rawValue)", size: sizeLiteral) {
            return safeFont
        } else {
            assert(false, "NO FONT FOUND")
            return UIFont.systemFont(ofSize: sizeLiteral)
        }
    }

}
