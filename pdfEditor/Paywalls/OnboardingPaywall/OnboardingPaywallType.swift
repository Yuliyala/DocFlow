import UIKit

enum OnboardingPaywallType {
    case white
    case grey
    
    var showCloseButtonImmediately: Bool {
        switch self {
        case .white:
            return true
        case .grey:
            return false
        }
    }
    
    var closeButtonDelay: TimeInterval {
        switch self {
        case .white:
            return 0
        case .grey:
            return 8.0
        }
    }
    
    var descriptionFontSize: CGFloat {
        return 16 
    }
    
    var descriptionTextColor: UIColor {
        switch self {
        case .white:
            return .textPrimary
        case .grey:
            return .textSecondary
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .white:
            return .backgroundPrimary
        case .grey:
            return .backgroundPrimary
        }
    }
    
    var shouldShowLimitedPaywallOnClose: Bool {
        switch self {
        case .white:
            return false
        case .grey:
            return true
        }
    }
}

