import UIKit
import StoreKit

class OnboardingPaywallViewController: UIViewController {
    
    private let appHudService: AppHudService = .shared
    private let firebaseService: FirebaseService = .shared
    private var weekProduct: Product?
    private var isLoading = false
    private var paywallType: OnboardingPaywallType = .white
    
    var rootView: OnboardingPaywallView {
        return view as! OnboardingPaywallView
    }
    
    override func loadView() {
        view = OnboardingPaywallView()
        rootView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.termsTextView.termsDelegate = self
        determinePaywallType()
        setupProducts()
    }
    
    private func determinePaywallType() {
        paywallType = firebaseService.isGreyFlow ? .grey : .white
    }
    
    private func setupProducts() {
        weekProduct = appHudService.storeProduct(for: appHudService.allProductWeek)
        
        let weekPrice = weekProduct?.displayPrice ?? "$7.99"
        let duration = appHudService.durationProduct(for: appHudService.allProductWeek)?.title ?? "week"
        let trialDuration = appHudService.trialDuration(for: appHudService.allProductWeek)?.title ?? "3-day"
        
        // ВСЕГДА показываем текст с trial для Onboarding Paywall
        let descriptionText = createDescriptionText(
            price: weekPrice,
            duration: duration,
            trialDuration: trialDuration,
            hasTrial: true
        )
        
        rootView.configure(type: paywallType, descriptionText: descriptionText)
    }
    
    private func createDescriptionText(price: String, duration: String, trialDuration: String, hasTrial: Bool) -> String {
        if hasTrial {
            return String(format: NSLocalizedString("onboarding.paywall.description_with_trial", comment: ""), price, duration, trialDuration)
        } else {
            return String(format: NSLocalizedString("onboarding.paywall.description_no_trial", comment: ""), price, duration)
        }
    }
    
    private func purchaseProduct() {
        guard let product = weekProduct, !isLoading else { return }
        
        isLoading = true
        rootView.continueButton.isEnabled = false
        
        Task {
            do {
                let result = try await product.purchase()
                
                await MainActor.run {
                    handlePurchaseResult(result)
                }
            } catch {
                await MainActor.run {
                    showError(error.localizedDescription)
                }
            }
        }
    }
    
    private func handlePurchaseResult(_ result: Product.PurchaseResult) {
        isLoading = false
        rootView.continueButton.isEnabled = true
        
        switch result {
        case .success(let verification):
            switch verification {
            case .verified:
                appHudService.hasSubscribed = true
                navigateToMain()
            case .unverified(_, let error):
                showError(error.localizedDescription)
            }
        case .userCancelled:
            break
        case .pending:
            showError(NSLocalizedString("paywall.error.pending", comment: ""))
        @unknown default:
            break
        }
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(
            title: NSLocalizedString("paywall.error.title", comment: ""),
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: NSLocalizedString("paywall.error.ok", comment: ""), style: .default))
        present(alert, animated: true)
    }
    
    private func navigateToMain() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            let tabBarController = TabBarController()
            window.rootViewController = tabBarController
            
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
        }
    }
    
    private func showLimitedPaywall() {
        let limitedVC = LimitedViewController()
        limitedVC.modalPresentationStyle = .fullScreen
        present(limitedVC, animated: true)
    }
}

extension OnboardingPaywallViewController: OnboardingPaywallViewDelegate {
    func onboardingPaywallViewDidTapContinue(_ view: OnboardingPaywallView) {
        animateButton(rootView.continueButton) {
            self.purchaseProduct()
        }
    }
    
    func onboardingPaywallViewDidTapClose(_ view: OnboardingPaywallView) {
        if paywallType.shouldShowLimitedPaywallOnClose {
            showLimitedPaywall()
        } else {
            navigateToMain()
        }
    }
}

extension OnboardingPaywallViewController: TermsTextViewDelegate {
    func didTapTermsOfService() {
        presentInAppBrowser(with: Constants.termsOfCoditionURL)
    }
    
    func didTapPrivacyPolicy() {
        presentInAppBrowser(with: Constants.privacyPolicyURL)
    }
}

