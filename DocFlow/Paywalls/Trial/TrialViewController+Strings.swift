import UIKit
import StoreKit

extension TrialViewController {
    func createWeeklyDescription(price: String, hasTrial: Bool) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        
        if hasTrial {
            let thenText = NSLocalizedString("paywall.selector.then", comment: "then")
            let weekText = NSLocalizedString("paywall.selector.week", comment: "week")
            
            let thenPart = NSAttributedString(
                string: "\(thenText) ",
                attributes: [
                    .font: UIFont.zalandoSans(.regular, size: view.isSmallScreen ? 14 : 16),
                    .foregroundColor: UIColor.textPrimary
                ]
            )
            
            let pricePart = NSAttributedString(
                string: price,
                attributes: [
                    .font: UIFont.zalandoSans(.regular, size: view.isSmallScreen ? 14 : 16),
                    .foregroundColor: UIColor.textPrimary
                ]
            )
            
            let weeklyPart = NSAttributedString(
                string: " (\(price)/\(weekText))",
                attributes: [
                    .font: UIFont.zalandoSans(.regular, size: view.isSmallScreen ? 10 : 12),
                    .foregroundColor: UIColor.textSecondary
                ]
            )
            
            attributedString.append(thenPart)
            attributedString.append(pricePart)
            attributedString.append(weeklyPart)
            
        } else {
            let weekText = NSLocalizedString("paywall.selector.week", comment: "week")
            
            let pricePart = NSAttributedString(
                string: price,
                attributes: [
                    .font: UIFont.zalandoSans(.regular, size: view.isSmallScreen ? 14 : 16),
                    .foregroundColor: UIColor.textPrimary
                ]
            )
            
            let weeklyPart = NSAttributedString(
                string: " (\(price)/\(weekText))",
                attributes: [
                    .font: UIFont.zalandoSans(.regular, size: view.isSmallScreen ? 10 : 12),
                    .foregroundColor: UIColor.textSecondary
                ]
            )
            
            attributedString.append(pricePart)
            attributedString.append(weeklyPart)
        }
        
        return attributedString
    }
    
    func monthAttributedDescription(price: String, priceDecimal: Decimal) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        
        let weeklyPriceDecimal = priceDecimal / 4
        
        let weeklyPriceString: String
        if let formatStyle = weekProduct?.priceFormatStyle {
            weeklyPriceString = formatStyle.format(weeklyPriceDecimal)
        } else {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .currency
            numberFormatter.locale = Locale.current
            weeklyPriceString = numberFormatter.string(from: weeklyPriceDecimal as NSDecimalNumber) ?? ""
        }
        
        let weekText = NSLocalizedString("paywall.selector.week", comment: "week")
        
        let pricePart = NSAttributedString(
            string: price,
            attributes: [
                .font: UIFont.zalandoSans(.regular, size: view.isSmallScreen ? 14 : 16),
                .foregroundColor: UIColor.textPrimary
            ]
        )
        
        let weeklyPart = NSAttributedString(
            string: " (\(weeklyPriceString)/\(weekText))",
            attributes: [
                .font: UIFont.zalandoSans(.regular, size: view.isSmallScreen ? 10 : 12),
                .foregroundColor: UIColor.textSecondary
            ]
        )
        
        attributedString.append(pricePart)
        attributedString.append(weeklyPart)
        
        return attributedString
    }
}


