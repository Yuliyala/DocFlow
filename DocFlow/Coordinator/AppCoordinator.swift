import UIKit

class AppCoordinator: UINavigationController {
    
    init() {
        super.init(rootViewController: SplashViewController())
        setNavigationBarHidden(true, animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func openOnboarding(_ onboarding: Onboarding = .first) {
        pushViewController(OnboardingViewController(onboarding: onboarding), animated: true)
    }

    func openApp() {
        pushViewController(TabBarController(), animated: true)
    }
    
    func paywallAfterOnboarding() {
        pushViewController(OnboardingPaywallViewController(), animated: true)
    }

    func openAppAfterOnboarding() {
        LocalStorage.shared.markOnboardingAsShown()
        self.viewControllers = [TabBarController()]
    }
}

