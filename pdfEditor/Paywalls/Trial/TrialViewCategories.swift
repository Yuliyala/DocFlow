import UIKit

enum TrialViewCategory: CaseIterable {
    case editor
    case converter
    case scanner

    var title: String {
        switch self {
        case .scanner:
            NSLocalizedString("trial.category.scanner", comment: "PDF Scanner category")
        case .editor:
            NSLocalizedString("trial.category.editor", comment: "PDF Editor category")
        case .converter:
            NSLocalizedString("trial.category.converter", comment: "File Converter category")
        }
    }
    
    var description: String {
        switch self {
        case .scanner:
            NSLocalizedString("trial.category.scanner.description", comment: "Scanner description")
        case .editor:
            NSLocalizedString("trial.category.editor.description", comment: "Editor description")
        case .converter:
            NSLocalizedString("trial.category.converter.description", comment: "Converter description")
        }
    }

    var icon: UIImage {
        switch self {
        case .scanner:
            UIImage(named: "scanningIcon") ?? UIImage()
        case .editor:
            UIImage(named: "docIcon") ?? UIImage()
        case .converter:
            UIImage(named: "pdfIcon") ?? UIImage()
        }
    }
}


