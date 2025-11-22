import UIKit

protocol TermsTextViewDelegate: AnyObject {
    func didTapTermsOfService()
    func didTapPrivacyPolicy()
}

class TermsTextView: UITextView {
    weak var termsDelegate: TermsTextViewDelegate?

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupTextView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextView()
    }

    private func setupTextView() {
        self.isEditable = false
        self.isScrollEnabled = false
        self.backgroundColor = .clear
        self.delegate = self
        self.textAlignment = .center
        self.textContainer.lineFragmentPadding = 0
        self.textContainerInset = .zero
        
        self.linkTextAttributes = [
            .foregroundColor: UIColor.accent,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]

        let attributedString = createAttributedString()
        self.attributedText = attributedString
    }

    private func createAttributedString() -> NSAttributedString {
        let fullText = NSLocalizedString("terms.agreement", comment: "Terms agreement")
        let attributedString = NSMutableAttributedString(string: fullText)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        let mainAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.zalandoSans(.regular, size: 12),
            .foregroundColor: UIColor.textSecondary,
            .paragraphStyle: paragraphStyle
        ]
        attributedString.addAttributes(mainAttributes, range: NSRange(location: 0, length: fullText.count))

        let termsOfUseText = NSLocalizedString("terms.terms_of_use", comment: "Terms of Service")
        if let termsRange = fullText.range(of: termsOfUseText) {
            let nsRange = NSRange(termsRange, in: fullText)
            let termsAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.zalandoSans(.regular, size: 12),
                .foregroundColor: UIColor.accent,
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .link: "terms_of_use"
            ]
            attributedString.addAttributes(termsAttributes, range: nsRange)
        }

        let privacyPolicyText = NSLocalizedString("terms.privacy_policy", comment: "Privacy Policy")
        if let privacyRange = fullText.range(of: privacyPolicyText) {
            let nsRange = NSRange(privacyRange, in: fullText)
            let privacyAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.zalandoSans(.regular, size: 12),
                .foregroundColor: UIColor.accent,
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .link: "privacy_policy"
            ]
            attributedString.addAttributes(privacyAttributes, range: nsRange)
        }

        return attributedString
    }
}

extension TermsTextView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        switch URL.absoluteString {
        case "terms_of_use":
            termsDelegate?.didTapTermsOfService()
        case "privacy_policy":
            termsDelegate?.didTapPrivacyPolicy()
        default:
            break
        }
        return false
    }
}

