import UIKit
import ApphudSDK
import StoreKit

class AppHudService {

    static let shared = AppHudService()

    private init() {}

    lazy var hasSubscribed: Bool = Apphud.hasPremiumAccess() || Apphud.hasActiveSubscription()
    
    var hasTrial: Bool = false
    var hasLimitedTrial = false
    
    var placements: [ApphudPlacement] = []
    
    // MARK: - Placements
    var limitedPlacement: ApphudPlacement? {
        placements.first { $0.identifier == AppHudConstants.limitedPlacement }
    }

    var startPlacement: ApphudPlacement? {
        placements.first { $0.identifier == AppHudConstants.startPlacement }
    }

    var allPlacement: ApphudPlacement? {
        placements.first { $0.identifier == AppHudConstants.allPlacement }
    }
    
    // MARK: - Products
    var limitedProduct: ApphudProduct? {
        limitedPlacement?.paywall?.products.first(where: { $0.productId == AppHudConstants.weekSaleProduct })
    }

    var startProduct: ApphudProduct? {
        startPlacement?.paywall?.products.first { $0.productId == AppHudConstants.weekProduct }
    }
    
    var allProductWeek: ApphudProduct? {
        allPlacement?.paywall?.products.first { $0.productId == AppHudConstants.weekProduct }
    }
    
    var allProductMonth: ApphudProduct? {
        allPlacement?.paywall?.products.first { $0.productId == AppHudConstants.monthProduct }
    }

    var productsMap: [ApphudProduct: Product] = [:]
    
    func storeProduct(for product: ApphudProduct?) -> Product? {
        guard let product else { return nil }
        return productsMap[product]
    }
    
    func durationProduct(for product: ApphudProduct?) -> SubscriptionDuration? {
        guard let product = product,
              let skProduct = product.skProduct else { 
            return nil 
        }
        
        let durationInSeconds = subscriptionDuration(product: skProduct)
        let durationInDays = Int(durationInSeconds / (24 * 60 * 60))
        
        switch durationInDays {
        case 7:
            return .week
        case 28...31:
            return .month
        default:
            return .days(durationInDays)
        }
    }
    
    func trialDuration(for product: ApphudProduct?) -> SubscriptionDuration? {
        guard let product = product,
              let skProductDuration = product.skProduct?.introductoryPrice?.subscriptionPeriod else {
            return nil
        }
        let durationInSeconds = subscriptionToTimeInterval(skProductDuration)
        let durationInDays = Int(durationInSeconds / (24 * 60 * 60))

        switch durationInDays {
        case 7:
            return .week
        case 28...31:
            return .month
        default:
            return .days(durationInDays)
        }
    }
    
    func preloadData() async {
        self.placements = await Apphud.placements().filter {
            AppHudConstants.allPlacementIDs.contains($0.identifier)
        }
        
        self.productsMap = await withTaskGroup(of: (ApphudProduct, Product)?.self, returning: [ApphudProduct: Product].self) { taskGroup in
            let apphudProducts = [limitedProduct, startProduct, allProductWeek, allProductMonth].compactMap { $0 }
            for apphudProduct in apphudProducts {
                taskGroup.addTask {
                    if let product = try? await apphudProduct.product() {
                        return (apphudProduct, product)
                    }
                    return nil
                }
            }

            var productsMap = [ApphudProduct: Product]()
            for await result in taskGroup {
                if let (apphudProduct, product) = result {
                    productsMap[apphudProduct] = product
                }
            }
            return productsMap
        }
        hasSubscribed = await hasActiveSubscription()
        if let weekProduct = allProductWeek?.skProduct, let limitedProduct = limitedProduct?.skProduct {
            Apphud.checkEligibilityForIntroductoryOffer(product: weekProduct) { isEligible in
                self.hasTrial = isEligible
            }
            Apphud.checkEligibilityForIntroductoryOffer(product: limitedProduct, callback: { isEligible in
                self.hasLimitedTrial = isEligible
            })
        }
    }
    
    func makePurchase(product: ApphudProduct?) async -> Bool {
        guard let product = product else { return false }
        
        let result = await Apphud.purchase(product)
        if result.success {
            hasSubscribed = true
        }
        return result.success
    }

    func restorePurchases() async -> Error? {
        let error = await Apphud.restorePurchases()
        if error == nil && (Apphud.hasActiveSubscription() || Apphud.hasPremiumAccess()) {
            hasSubscribed = true
        } else if error == nil {
            hasSubscribed = false
            return RestoreError.notFound
        }
        return error as! any Error
    }
    
    private func subscriptionDuration(product: SKProduct) -> TimeInterval {
        guard let subscriptionPeriod = product.subscriptionPeriod else {
            return 0
        }
        
        return subscriptionToTimeInterval(subscriptionPeriod)
    }
    
    private func subscriptionToTimeInterval(_ subscriptionPeriod: SKProductSubscriptionPeriod) -> TimeInterval {
        let currentDate = Date()
        let numberOfUnits = subscriptionPeriod.numberOfUnits
        let unit = subscriptionPeriod.unit
        
        var calendarComponent: Calendar.Component?
        
        switch unit {
        case .day:
            calendarComponent = .day
        case .month:
            calendarComponent = .month
        case .week:
            calendarComponent = .weekOfYear
        case .year:
            calendarComponent = .year
        default:
            break
        }
        
        guard let component = calendarComponent else {
            return 0
        }
        
        let calendar = Calendar(identifier: .iso8601)
        
        guard let newDate = calendar.date(byAdding: component, value: numberOfUnits, to: currentDate) else {
            return 0
        }
        
        return newDate.timeIntervalSince1970 - currentDate.timeIntervalSince1970
    }
    
    func hasActiveSubscription() async -> Bool {
        let apphudSubscriptions = await Apphud.subscriptions()
        let apphudNonSubscriptions = await Apphud.nonRenewingPurchases()
        
        let hasActiveSubsciption: Bool = apphudSubscriptions?.first(where: { $0.isActive() }) != nil
        let hasActiveNonSubscription: Bool = apphudNonSubscriptions?.first(where: { $0.isActive() }) != nil
        
        return Apphud.hasActiveSubscription() || Apphud.hasPremiumAccess() || hasActiveSubsciption || hasActiveNonSubscription
    }
}

enum SubscriptionDuration {
    case days(Int)
    case week
    case month
    case year
    
    var title: String {
        switch self {
        case .days(let int):
            String(format: NSLocalizedString("duration.days", comment: ""), int)
        case .week:
            NSLocalizedString("duration.week", comment: "")
        case .month:
            NSLocalizedString("duration.month", comment: "")
        case .year:
            NSLocalizedString("duration.year", comment: "")
        }
    }
}

enum RestoreError: Error {
    case notFound
    
    var localizedDescription: String {
        switch self {
        case .notFound:
            NSLocalizedString("restore.error.text", comment: "")
        }
    }
}


