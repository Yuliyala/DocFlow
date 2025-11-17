import UIKit

final class MailService {
    
    static func openMailApp() {
        let email = Constants.supportEmail
        let subject = NSLocalizedString("mail.title", comment: "")
        
        guard let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let mailtoURL = URL(string: "mailto:\(email)?subject=\(encodedSubject)"),
              UIApplication.shared.canOpenURL(mailtoURL) else {
            return
        }
        
        UIApplication.shared.open(mailtoURL)
    }
}
