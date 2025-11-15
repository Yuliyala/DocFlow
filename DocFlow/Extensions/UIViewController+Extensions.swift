import UIKit
import StoreKit

extension UIViewController {
    func presentInAppBrowser(with url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func presentInAppBrowser(with urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        presentInAppBrowser(with: url)
    }
    
    func requestAppRating() {
        if #available(iOS 14.0, *) {
            if let scene = view.window?.windowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        } else {
            SKStoreReviewController.requestReview()
        }
    }
    
    func getCurrentTopViewController() -> UIViewController {
        var topViewController: UIViewController = self
        
        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }
        
        if let navigationController = topViewController as? UINavigationController {
            return navigationController.topViewController ?? navigationController
        }
        
        if let tabBarController = topViewController as? UITabBarController {
            return tabBarController.selectedViewController ?? tabBarController
        }
        
        return topViewController
    }
}

