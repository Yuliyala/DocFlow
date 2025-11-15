import UIKit

extension UIColor {
    static var accent: UIColor {
        return UIColor(hex: "#DF4D53")
    }
    
    static var accentSecondary: UIColor {
        return UIColor(hex: "#FAE7E8")
    }
    
    static var background: UIColor {
        return UIColor(hex: "#F7F7F7")
    }
    
    static var backgroundSecondary: UIColor {
        return UIColor(hex: "#FFFFFF")
    }
    
    static var backgroundTertiary: UIColor {
        return UIColor(hex: "#F0F0F0")
    }
    
    static var textPrimary: UIColor {
        return UIColor(hex: "#131212")
    }
    
    static var textSecondary: UIColor {
        return UIColor(hex: "#6F6F6F")
    }
    
    static var textTertiary: UIColor {
        return UIColor(hex: "#FFFFFF")
    }
    
    static var iconPrimary: UIColor {
        return UIColor(hex: "#131212")
    }
    
    static var iconSecondary: UIColor {
        return UIColor(hex: "#6F6F6F")
    }
    
    static var iconTertiary: UIColor {
        return UIColor(hex: "#FFFFFF")
    }
    
    static var strokePrimary: UIColor {
        return UIColor(hex: "#EFEFEF")
    }
    
    static var buttonPrimary: UIColor {
        return UIColor(hex: "#DF4D53")
    }
    
    static var buttonSecondary: UIColor {
        return UIColor(hex: "#FAE7E8")
    }
    
    static var buttonDisabled: UIColor {
        return UIColor(hex: "#ECECEC")
    }
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }
    
    static var greyAccent: UIColor {
        return strokePrimary
    }
}

