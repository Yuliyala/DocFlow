import UIKit

extension UIView {
    static func horizontalSpacer() -> UIView {
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return spacer
    }

    static func verticalSpacer() -> UIView {
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .vertical)
        return spacer
    }
    
    var isSmallScreen: Bool {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return windowScene.screen.bounds.height < 700
        }
        if let window = UIApplication.shared.windows.first, let screen = window.windowScene?.screen {
            return screen.bounds.height < 700
        }
        return false
    }
    
    var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}
