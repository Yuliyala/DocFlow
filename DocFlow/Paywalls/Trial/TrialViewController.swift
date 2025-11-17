import UIKit
import StoreKit

class TrialViewController: UIViewController {

    private let appHudService: AppHudService = .shared
    private let rootView = TrialView()
    var weekProduct: Product?
    private var monthProduct: Product?
    private var isLoading = false
    private var hasTrial = false
    private var currentProductIndex: Int = 0
    
    var forceTrialMode: Bool?

    override func loadView() {
        view = rootView
        rootView.delegate = self
        rootView.paywallSelectorView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProducts()
        rootView.termsTextView.termsDelegate = self
    }
    
    private func setupProducts() {
        weekProduct = appHudService.storeProduct(for: appHudService.allProductWeek)
        monthProduct = appHudService.storeProduct(for: appHudService.allProductMonth)
        
        // 🔧 ВРЕМЕННО: используем forceTrialMode если он установлен
        let hasTrial = forceTrialMode ?? appHudService.hasTrial
        let weekPrice = weekProduct?.displayPrice ?? "$7.99"
        let monthPrice = monthProduct?.displayPrice ?? "$19.99"
        self.hasTrial = hasTrial
        
        let trialDuration: String = appHudService.trialDuration(for: appHudService.allProductWeek)?.title ?? "3 Days"
        let weekText = NSLocalizedString("paywall.selector.week", comment: "week")
        let thenText = NSLocalizedString("paywall.selector.then", comment: "then")
        
        let weekPriceText = hasTrial ? "\(thenText) \(weekPrice)" : weekPrice
        let weekPricePerWeek = "(\(weekPrice)/\(weekText))"
        let weekDescription = "\(weekPriceText)\n\(weekPricePerWeek)"
        
        let weekAttributedDescription = NSMutableAttributedString(string: weekDescription)
        if let range = weekDescription.range(of: weekPricePerWeek) {
            let nsRange = NSRange(range, in: weekDescription)
            weekAttributedDescription.addAttribute(.foregroundColor, value: UIColor.textSecondary, range: nsRange)
        }
        
        let weekInfoText: String? = {
            guard hasTrial else { return nil }
            return String(format: NSLocalizedString("paywall.selector.trial_badge", comment: ""), trialDuration)
        }()
        
        rootView.paywallSelectorView.weeklySelector.configure(
            infoText: weekInfoText,
            title: NSLocalizedString("paywall.selector.week_title", comment: "Week"),
            description: weekAttributedDescription
        )
        
        let monthPriceDecimal = monthProduct?.price ?? 19.99
        let weeklyPriceDecimal = monthPriceDecimal / 4
        let weeklyPriceString: String
        if let formatStyle = monthProduct?.priceFormatStyle {
            weeklyPriceString = formatStyle.format(weeklyPriceDecimal)
        } else {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .currency
            numberFormatter.locale = Locale.current
            weeklyPriceString = numberFormatter.string(from: weeklyPriceDecimal as NSDecimalNumber) ?? "$4.99"
        }
        let monthPricePerWeek = "(\(weeklyPriceString)/\(weekText))"
        let monthDescription = "\(monthPrice)\n\(monthPricePerWeek)"
        
        let monthAttributedDescription = NSMutableAttributedString(string: monthDescription)
        if let range = monthDescription.range(of: monthPricePerWeek) {
            let nsRange = NSRange(range, in: monthDescription)
            monthAttributedDescription.addAttribute(.foregroundColor, value: UIColor.textSecondary, range: nsRange)
        }
        
        rootView.paywallSelectorView.monthlySelector.configure(
            infoText: NSLocalizedString("paywall.selector.best_price", comment: "Best Price"),
            title: NSLocalizedString("paywall.selector.month_title", comment: "Month"),
            description: monthAttributedDescription
        )
        
        configureButton()
    }

    private func configureButton() {
        guard hasTrial else {
            rootView.continueButton.setTitle(NSLocalizedString("paywall.button.continue", comment: "Continue button"), for: .normal)
            return
        }
        
        let weekPrice = weekProduct?.displayPrice ?? "$7.99"
        let monthPrice = monthProduct?.displayPrice ?? "$19.99"
        let trialDuration: String = appHudService.trialDuration(for: appHudService.allProductWeek)?.title ?? "3 Days"
        
        switch currentProductIndex {
        case 0:
            rootView.continueButton.setTitle(String(format: String(format: NSLocalizedString("paywall.trial.button.title", comment: "Continue button"), trialDuration, weekPrice)), for: .normal)
        case 1:
            rootView.continueButton.setTitle(String(format: NSLocalizedString("paywall.subcribe.button.title", comment: "Continue button"), monthPrice), for: .normal)
        default:
            break
        }
    }
}

extension TrialViewController: TrialViewDelegate {
    func trialViewDidTapRestore() {
        guard !isLoading else { return }
        isLoading = true
        Task { @MainActor in
            if let error = await appHudService.restorePurchases() {
                isLoading = false
                presentRestorePurchasesFailureAlert(errorDescription: error.localizedDescription)
            } else {
                isLoading = false
                dismiss(animated: true)
            }
        }
    }

    func trialViewDidTapClose() {
        dismiss(animated: true)
    }
    
    func continueTapped() {
        guard !isLoading else { return }
        isLoading = true
        Task { @MainActor in
            let result = await appHudService.makePurchase(product: currentProductIndex == 0 ? appHudService.allProductWeek : appHudService.allProductMonth)
            isLoading = false
            if result {
                dismiss(animated: true)
            } else {
                presentSubscriptionErrorAlert()
            }
        }
    }
}

extension TrialViewController: PaywallSelectorViewDelegate {
    func paywallSelectorView(_ selectorView: PaywallSelectorView, didSelectIndex index: Int) {
        currentProductIndex = index
        configureButton()
    }
}

extension TrialViewController: TermsTextViewDelegate {
    func didTapTermsOfService() {
        guard let url = Constants.termsOfServiceURL else { return }
        presentInAppBrowser(with: url)
    }
    
    func didTapPrivacyPolicy() {
        guard let url = Constants.privacyPolicyURL else { return }
        presentInAppBrowser(with: url)
    }
}
