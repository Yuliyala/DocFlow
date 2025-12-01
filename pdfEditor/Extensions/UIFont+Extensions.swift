import UIKit

enum ZalandoSansWeight {
    case regular
    case medium
    case semiBold
    case bold
    
    var weightValue: CGFloat {
        switch self {
        case .regular:
            return 400
        case .medium:
            return 500
        case .semiBold:
            return 600
        case .bold:
            return 700
        }
    }
    
    var systemWeight: UIFont.Weight {
        switch self {
        case .regular:
            return .regular
        case .medium:
            return .medium
        case .semiBold:
            return .semibold
        case .bold:
            return .bold
        }
    }
}

extension UIFont {
    private static let zalandoSansVariableFontName = "ZalandoSans-VariableFont_wdth,wght"
    
    static func zalandoSans(_ weight: ZalandoSansWeight, size: CGFloat) -> UIFont {
        guard let variableFont = UIFont(name: zalandoSansVariableFontName, size: size) else {
            return UIFont.systemFont(ofSize: size, weight: weight.systemWeight)
        }
        
        let fontDescriptor = variableFont.fontDescriptor.addingAttributes([
            .traits: [
                UIFontDescriptor.TraitKey.weight: weight.weightValue
            ]
        ])
        
        return UIFont(descriptor: fontDescriptor, size: size)
    }

    static var isZalandoSansAvailable: Bool {
        return UIFont(name: zalandoSansVariableFontName, size: 12) != nil
    }

    static var availableZalandoSansFonts: [String] {
        let allFonts = UIFont.fontNames(forFamilyName: "Zalando Sans")
        return allFonts.isEmpty ? [] : allFonts
    }
}

