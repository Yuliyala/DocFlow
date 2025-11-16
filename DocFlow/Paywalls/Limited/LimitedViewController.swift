import UIKit
import StoreKit

class LimitedViewController: UIViewController {
    
    var closeCallback: (() -> Void)?

    var timer: Timer?
    private let appHudService: AppHudService = .shared
    var product: Product?
    var isLoading = false
    
    // 🔧 ВРЕМЕННО для тестирования дизайна - удалить потом!
    var forceGreyFlowMode: Bool? = nil

    var rootView: LimitedView {
        return view as! LimitedView
    }

    override func loadView() {
        view = LimitedView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        setupTimer()
        setupProduct()
    }
    
    private func setupProduct() {
        self.product = appHudService.storeProduct(for: appHudService.limitedProduct)
        let weekProduct = appHudService.storeProduct(for: appHudService.allProductWeek)
        let displayPrice = weekProduct?.displayPrice ?? "$7.99"
        let dicsountDisplayPrice = product?.displayPrice ?? "$5.99"
        
        let price = weekProduct?.price ?? 0
        let discountPrice = product?.price ?? 0
        let discountPercentage = (price - discountPrice) / price * 100
    
        let trialDuration = appHudService.trialDuration(for: appHudService.limitedProduct)?.title ?? ""
        let subscriptionDuration = appHudService.durationProduct(for: appHudService.limitedProduct)?.title ?? ""
        
        // 🔧 ВРЕМЕННО: используем forceGreyFlowMode если он установлен
        let isGreyFlow = forceGreyFlowMode ?? FirebaseService.shared.isGreyFlow
        
        rootView.configure(
            discount: String(NSDecimalNumber(decimal: discountPercentage).int32Value),
            price: displayPrice,
            discountPrice: dicsountDisplayPrice,
            expires: getCurrentTimerString(),
            isGreyFlow: isGreyFlow,
            hasTrial: appHudService.hasLimitedTrial,
            trialDuration: trialDuration,
            subscriptionDuration: subscriptionDuration
        )
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopTimer()
    }
    
    deinit {
        stopTimer()
    }
    
    private func setupDelegates() {
        rootView.setTermsDelegate(self)
        
        rootView.setupActions(
            closeTarget: self,
            closeAction: #selector(closeButtonTapped),
            restoreTarget: self,
            restoreAction: #selector(restoreButtonTapped),
            continueTarget: self,
            continueAction: #selector(continueButtonTapped(_:))
        )
    }
    
    @objc private func closeButtonTapped() {
        if let closeCallback {
            closeCallback()
        } else {
            dismiss(animated: true)
        }
    }
    
    @objc private func restoreButtonTapped() {
        guard !isLoading else { return }
        isLoading = true
        Task { @MainActor in
            if let error = await appHudService.restorePurchases() {
                isLoading = false
                presentRestorePurchasesFailureAlert(errorDescription: error.localizedDescription)
            } else {
                isLoading = false
                self.dismiss(animated: true)
            }
        }
    }
    
    @objc private func continueButtonTapped(_ sender: UIButton) {
        animateButton(sender) {
            guard !self.isLoading else { return }
            self.isLoading = true
            Task { @MainActor in
                let result = await self.appHudService.makePurchase(product: self.appHudService.limitedProduct)
                self.isLoading = false
                if result {
                    self.dismiss(animated: true)
                } else {
                    self.presentSubscriptionErrorAlert()
                }
            }
        }
    }
}

extension LimitedViewController: TermsTextViewDelegate {
    func didTapTermsOfService() {
        presentInAppBrowser(with: Constants.termsOfCoditionURL)
    }
    
    func didTapPrivacyPolicy() {
        presentInAppBrowser(with: Constants.privacyPolicyURL)
    }
}


