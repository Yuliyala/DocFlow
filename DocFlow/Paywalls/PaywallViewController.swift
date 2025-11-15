import UIKit

class PaywallViewController: UIViewController {
    
    private let appHudService: AppHudService = .shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentAppropriatePaywall()
    }
    
    private func presentAppropriatePaywall() {
        // Проверяем какой paywall показывать
        if let limitedPlacement = appHudService.limitedPlacement,
           let limitedProduct = appHudService.limitedProduct,
           appHudService.hasLimitedTrial || LocalStorage.shared.timer24HourStartDate != nil {
            // Показываем Limited Paywall
            presentLimitedPaywall()
        } else {
            // Показываем Trial Paywall
            presentTrialPaywall()
        }
    }
    
    private func presentTrialPaywall() {
        let trialVC = TrialViewController()
        trialVC.modalPresentationStyle = .fullScreen
        present(trialVC, animated: true)
    }
    
    private func presentLimitedPaywall() {
        let limitedVC = LimitedViewController()
        limitedVC.modalPresentationStyle = .fullScreen
        limitedVC.closeCallback = { [weak self] in
            self?.presentTrialPaywall()
        }
        present(limitedVC, animated: true)
    }
}

