import UIKit
import Foundation

enum Palette {
    case white, beige, pink, black, darkGrey
    
    var color: UIColor {
        switch self {
        case .beige: return UIColor(hex: 0xFFAB91)
        case .white: return UIColor(hex: 0xffffff)
        case .pink: return UIColor(hex: 0xFFCDD2)
        case .black: return UIColor(hex: 0x000000)
        case .darkGrey: return UIColor(hex: 0x4F4F4F)
        
        }
    }
}

extension UIColor {
    
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
    
    class func forGradient(_ red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
    }
    
}

