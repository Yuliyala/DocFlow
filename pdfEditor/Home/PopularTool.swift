import UIKit

enum PopularTool: CaseIterable {
    case newPDF
    case scan
    case imageToPDF
    case fileToPDF
    case mergePDF
    case splitPDF
    case sign
    case watermark
    
    var icon: UIImage {
        switch self {
        case .newPDF:
            return .newPdf
        case .scan:
            return .scan
        case .imageToPDF:
            return .pdf
        case .fileToPDF:
            return .fileToPdf
        case .mergePDF:
            return .mergePdf
        case .splitPDF:
            return .splitPdf
        case .sign:
            return .signature
        case .watermark:
            return .watermark
        }
    }
    
    var title: String {
        switch self {
        case .newPDF:
            return NSLocalizedString("tool.new_pdf", comment: "New PDF")
        case .scan:
            return NSLocalizedString("tool.scan", comment: "Scan")
        case .imageToPDF:
            return NSLocalizedString("tool.image_to_pdf", comment: "Image to PDF")
        case .fileToPDF:
            return NSLocalizedString("tool.file_to_pdf", comment: "File to PDF")
        case .mergePDF:
            return NSLocalizedString("tool.merge_pdf", comment: "Merge PDF")
        case .splitPDF:
            return NSLocalizedString("tool.split_pdf", comment: "Split PDF")
        case .sign:
            return NSLocalizedString("tool.sign", comment: "Sign")
        case .watermark:
            return NSLocalizedString("tool.watermark", comment: "Watermark")
        }
    }
}

