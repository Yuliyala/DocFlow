import UIKit

enum Constants {
    // AppHud
    static let appHudKey = "app_vEXDHY1EFnSZaCom4SvxUs7nadWLPD"
    
    // Firebase Remote Config
    static let firebaseFlagKey = "isGreyFlow"
    
    // App Store
    static let appId = "987654321"
    
    // Support URLs
    static let privacyPolicyURL = URL(string: "https://docs.google.com/document/d/1eh7hRlFFguud9zdaV6tRiflMjz-jlA5Fhq4503eaxvQ/edit?usp=sharing")
    static let termsOfServiceURL = URL(string: "https://docs.google.com/document/d/1XViqMC1TwS0iuDI09fkp6s-8wMX6WHanAYkPkSGU5oU/edit?usp=sharing")
    static let supportURL = URL(string: "https://docs.google.com/document/d/1cD1pzbCDFhmkyYysqn9_beIs2lVB0g3MZmBxsZ-nheY/edit?usp=sharing")
    static let supportEmail = "support@pdfeditor.com"
}

enum AppHudConstants {
    // Product IDs
    static let weekProduct = "pdfeditorreadapp_wk799trial"
    static let monthProduct = "pdfeditorreadapp_mo1999notrial"
    static let weekSaleProduct = "pdfeditorreadapp_wk599trialsale"
    
    // Paywall IDs
    static let paywall1 = "pdfeditorreadapp_subs1one"
    static let paywall2 = "pdfeditorreadapp_subs2two"
    static let paywall1Sale = "pdfeditorreadapp_subs1sale"
    
    // Placement IDs
    static let startPlacement = "pdfeditorreadapp_beginning_app"
    static let allPlacement = "pdfeditorreadapp_within_app"
    static let limitedPlacement = "pdfeditorreadapp_limitedsett_app"
    
    static var allPlacementIDs: Set<String> {
        return [startPlacement, allPlacement, limitedPlacement]
    }
}
