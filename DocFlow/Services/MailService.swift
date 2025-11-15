import UIKit

class MailService {
    
    static func openMailApp() {
        let email = Constants.email
        let subject = NSLocalizedString("mail.title", comment: "")
        
        guard let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Failed to encode email subject")
            return
        }
        
        let mailtoString = "mailto:\(email)?subject=\(encodedSubject)"
        
        guard let mailtoURL = URL(string: mailtoString) else {
            print("Failed to create mailto URL")
            return
        }
        
        if UIApplication.shared.canOpenURL(mailtoURL) {
            UIApplication.shared.open(mailtoURL, options: [:]) { success in
                if !success {
                    print("Failed to open mail app")
                }
            }
        } else {
            print("Mail app is not available")
        }
    }
}


