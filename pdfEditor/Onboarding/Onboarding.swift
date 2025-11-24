import UIKit

enum Onboarding: CaseIterable {
    case first
    case second
    case third

    var image: UIImage? {
        switch self {
        case .first:
            UIImage(named: "onb1")
        case .second:
            UIImage(named: "onb2")
        case .third:
            UIImage(named: "onb3")
        }
    }

    var title: String {
        switch self {
        case .first:
            NSLocalizedString("onboarding.first.title", comment: "")
        case .second:
            NSLocalizedString("onboarding.second.title", comment: "")
        case .third:
            NSLocalizedString("onboarding.third.title", comment: "")
        }
    }
    
    var body: String {
        switch self {
        case .first:
            NSLocalizedString("onboarding.first.description", comment: "")
        case .second:
            NSLocalizedString("onboarding.second.description", comment: "")
        case .third:
            NSLocalizedString("onboarding.third.description", comment: "")
        }
    }
    
    var currentPage: Int {
        Onboarding.allCases.firstIndex(of: self) ?? 0
    }
    
    static var totalPages: Int {
        allCases.count
    }
    
    var next: Onboarding? {
        switch self {
        case .first:
                .second
        case .second:
                .third
        case .third:
                .none
        }
    }
}
