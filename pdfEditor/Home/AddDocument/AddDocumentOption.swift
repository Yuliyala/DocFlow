import UIKit

enum AddDocumentOption: CaseIterable {
    case gallery
    case files
    case scan
    
    var icon: UIImage {
        switch self {
        case .gallery:
            return .galleryIcon ?? UIImage(systemName: "photo.on.rectangle") ?? UIImage()
        case .files:
            return .folderIcon ?? UIImage(systemName: "folder") ?? UIImage()
        case .scan:
            return .scan ?? UIImage(systemName: "scanner") ?? UIImage()
        }
    }
    
    var title: String {
        switch self {
        case .gallery:
            return NSLocalizedString("add_document.gallery", comment: "Gallery")
        case .files:
            return NSLocalizedString("add_document.files", comment: "Files")
        case .scan:
            return NSLocalizedString("add_document.scan", comment: "Scan")
        }
    }
}

