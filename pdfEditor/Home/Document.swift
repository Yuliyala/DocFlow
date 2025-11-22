import UIKit

struct Document {
    let id: String
    let title: String
    let date: Date
    let fileType: FileType
    let fileSize: String
    var isFavorite: Bool
    
    enum FileType: String {
        case pdf = "PDF"
        case doc = "DOC"
        case docx = "DOCX"
        case txt = "TXT"
        
        var icon: UIImage {
            return .pdfIcon
        }
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
    
    var displayInfo: String {
        return "\(formattedDate) · \(fileType.rawValue) · \(fileSize)"
    }
}

extension Document {
    static var mockDocuments: [Document] = [
        Document(
            id: "1",
            title: "Non-Disclosure Agreement 2024",
            date: Date(timeIntervalSince1970: 1728518400),
            fileType: .pdf,
            fileSize: "4.9 MB",
            isFavorite: false
        ),
        Document(
            id: "2",
            title: "Disclosure Policy Guidelines",
            date: Date(timeIntervalSince1970: 1728432000),
            fileType: .pdf,
            fileSize: "2.3 MB",
            isFavorite: true
        ),
        Document(
            id: "3",
            title: "Financial Disclosure Report",
            date: Date(timeIntervalSince1970: 1728345600),
            fileType: .pdf,
            fileSize: "1.8 MB",
            isFavorite: false
        ),
        Document(
            id: "4",
            title: "Marketing Strategy 2025",
            date: Date(timeIntervalSince1970: 1728259200),
            fileType: .pdf,
            fileSize: "3.2 MB",
            isFavorite: true
        ),
        Document(
            id: "5",
            title: "Employee Handbook",
            date: Date(timeIntervalSince1970: 1728172800),
            fileType: .pdf,
            fileSize: "5.1 MB",
            isFavorite: false
        ),
        Document(
            id: "6",
            title: "Project Proposal Template",
            date: Date(timeIntervalSince1970: 1728086400),
            fileType: .docx,
            fileSize: "890 KB",
            isFavorite: false
        ),
        Document(
            id: "7",
            title: "Annual Report 2024",
            date: Date(timeIntervalSince1970: 1728000000),
            fileType: .pdf,
            fileSize: "6.7 MB",
            isFavorite: true
        ),
        Document(
            id: "8",
            title: "Meeting Notes - October",
            date: Date(timeIntervalSince1970: 1727913600),
            fileType: .doc,
            fileSize: "456 KB",
            isFavorite: false
        )
    ]
}
