import UIKit

enum SettingsOption: CaseIterable {
    case restore
    case share
    case privacy
    case terms
    case contact

    var image: UIImage {
        switch self {
        case .restore:
                .restoreIcon
        case .share:
                .shareIcon
        case .privacy:
                .securityIcon
        case .terms:
                .docSettingIcon
        case .contact:
                .messageIcon
        }
    }

    var title: String {
        switch self {
        case .restore:
            NSLocalizedString("settings.restore", comment: "Restore purchases")
        case .share:
            NSLocalizedString("settings.share", comment: "Share app")
        case .privacy:
            NSLocalizedString("settings.privacy", comment: "Privacy policy")
        case .terms:
            NSLocalizedString("settings.terms", comment: "Terms of use")
        case .contact:
            NSLocalizedString("settings.contact", comment: "Contact us")
        }
    }
}

