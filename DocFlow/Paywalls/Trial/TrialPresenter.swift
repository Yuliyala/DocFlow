import UIKit
import StoreKit
import ApphudSDK

protocol TrialViewProtocol: AnyObject {
    func configureWeekProduct(infoText: String?, title: String, description: NSAttributedString)
    func configureMonthProduct(infoText: String?, title: String, description: NSAttributedString)
    func updateContinueButton(title: String)
    func showLoading()
    func hideLoading()
    func dismissView()
    func presentRestorePurchasesFailureAlert(errorDescription: String)
    func presentSubscriptionErrorAlert()
}

protocol TrialPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapContinue()
    func didTapClose()
    func didSelectProduct(at index: Int)
    func didTapRestore()
}

final class TrialPresenter {
    
    weak var view: TrialViewProtocol?
    
    private let appHudService: AppHudService
    private var weekProduct: Product?
    private var monthProduct: Product?
    private var hasTrial: Bool = false
    private var currentProductIndex: Int = 0
    private var isLoading: Bool = false
    
    var forceTrialMode: Bool?
    
    init(view: TrialViewProtocol, appHudService: AppHudService = .shared) {
        self.view = view
        self.appHudService = appHudService
    }
    
    private func loadProducts() {
        weekProduct = appHudService.storeProduct(for: appHudService.allProductWeek)
        monthProduct = appHudService.storeProduct(for: appHudService.allProductMonth)
        
        hasTrial = forceTrialMode ?? appHudService.hasTrial
        
        let weekPrice = weekProduct?.displayPrice ?? "$7.99"
        let monthPrice = monthProduct?.displayPrice ?? "$19.99"
        
        let trialDuration = appHudService.trialDuration(for: appHudService.allProductWeek)?.title ?? "3 Days"
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
        
        view?.configureWeekProduct(
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
        
        view?.configureMonthProduct(
            infoText: NSLocalizedString("paywall.selector.best_price", comment: "Best Price"),
            title: NSLocalizedString("paywall.selector.month_title", comment: "Month"),
            description: monthAttributedDescription
        )
        
        updateContinueButton()
    }
    
    private func updateContinueButton() {
        guard hasTrial else {
            view?.updateContinueButton(title: NSLocalizedString("paywall.button.continue", comment: "Continue button"))
            return
        }
        
        let weekPrice = weekProduct?.displayPrice ?? "$7.99"
        let monthPrice = monthProduct?.displayPrice ?? "$19.99"
        let trialDuration = appHudService.trialDuration(for: appHudService.allProductWeek)?.title ?? "3 Days"
        
        let buttonTitle: String
        switch currentProductIndex {
        case 0:
            buttonTitle = String(format: NSLocalizedString("paywall.trial.button.title", comment: "Continue button"), trialDuration, weekPrice)
        case 1:
            buttonTitle = String(format: NSLocalizedString("paywall.subcribe.button.title", comment: "Continue button"), monthPrice)
        default:
            buttonTitle = NSLocalizedString("paywall.button.continue", comment: "Continue button")
        }
        
        view?.updateContinueButton(title: buttonTitle)
    }
    
    private func purchaseProduct() {
        guard !isLoading else { return }
        
        isLoading = true
        view?.showLoading()
        
        let product = currentProductIndex == 0 ? appHudService.allProductWeek : appHudService.allProductMonth
        
        Task { @MainActor in
            let result = await appHudService.makePurchase(product: product)
            
            isLoading = false
            view?.hideLoading()
            
            if result {
                view?.dismissView()
            } else {
                view?.presentSubscriptionErrorAlert()
            }
        }
    }
    
    private func restorePurchases() {
        guard !isLoading else { return }
        
        isLoading = true
        view?.showLoading()
        
        Task { @MainActor in
            if let error = await appHudService.restorePurchases() {
                isLoading = false
                view?.hideLoading()
                view?.presentRestorePurchasesFailureAlert(errorDescription: error.localizedDescription)
            } else {
                isLoading = false
                view?.hideLoading()
                view?.dismissView()
            }
        }
    }
}

extension TrialPresenter: TrialPresenterProtocol {
    
    func viewDidLoad() {
        loadProducts()
    }
    
    func didTapContinue() {
        purchaseProduct()
    }
    
    func didTapClose() {
        view?.dismissView()
    }
    
    func didSelectProduct(at index: Int) {
        currentProductIndex = index
        updateContinueButton()
    }
    
    func didTapRestore() {
        restorePurchases()
    }
}

