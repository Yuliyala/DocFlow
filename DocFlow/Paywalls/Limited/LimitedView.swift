import UIKit

class LimitedView: UIView {

    private let checkedBackgroundView: CheckedView = {
        let view = CheckedView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 16
        return stackView
    }()

    private let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let restoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("paywall.button.restore", comment: "Restore button"), for: .normal)
        button.setTitleColor(.textSecondary, for: .normal)
        button.titleLabel?.font = .zalandoSans(.medium, size: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = AppHudService.shared.hasSubscribed
        return button
    }()

    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .textSecondary
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        return button
    }()

    private let iconView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(systemName: "doc.fill")
        view.tintColor = .accent
        view.contentMode = .scaleAspectFit
        return view
    }()

    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 12
        return stackView
    }()

    private let limitedOfferLabel: CapsuledLabel = {
        let label = CapsuledLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .zalandoSans(.semiBold, size: 16)
        label.textColor = .accent
        label.text = NSLocalizedString("limited.offer.label", comment: "Limited offer label")
        label.backgroundColor = .white
        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .zalandoSans(.semiBold, size: 40)
        label.textColor = .textPrimary
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()

    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        return stackView
    }()

    private let trialLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .zalandoSans(.semiBold, size: 16)
        label.textColor = .accent
        label.text = String(format: NSLocalizedString("limited.trial.label", comment: "Trial label"), "")
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .zalandoSans(.semiBold, size: 22)
        label.textColor = .textPrimary
        label.textAlignment = .center
        return label
    }()

    private let timerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        return stackView
    }()

    private let expiresLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .zalandoSans(.medium, size: 16)
        label.textColor = .textPrimary
        label.text = NSLocalizedString("limited.expires.label", comment: "Expires label")
        return label
    }()

    private let timerLabel: CapsuledLabel = {
        let label = CapsuledLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .zalandoSans(.medium, size: 22)
        label.textColor = .accent
        label.backgroundColor = .white
        label.insets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        label.text = NSLocalizedString("limited.timer.placeholder", comment: "Timer placeholder")
        return label
    }()

    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        return stackView
    }()

    private let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("paywall.button.continue", comment: "Continue button"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .zalandoSans(.medium, size: 16)
        button.backgroundColor = UIColor.accent
        button.layer.cornerRadius = 28
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let securedView: CapsuleContentView = {
        let view = CapsuleContentView.createSecurityCapsule()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let termsTextView: TermsTextView = {
        let view = TermsTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        addSubview(checkedBackgroundView)
        addSubview(headerStackView)
        addSubview(stackView)

        [restoreButton, .horizontalSpacer(), closeButton].forEach { headerStackView.addArrangedSubview($0) }
        [trialLabel, priceLabel].forEach { priceStackView.addArrangedSubview($0) }
        [expiresLabel, timerLabel].forEach { timerStackView.addArrangedSubview($0) }
        [limitedOfferLabel, titleLabel].forEach { titleStackView.addArrangedSubview($0) }
        [securedView, continueButton, termsTextView].forEach { buttonStackView.addArrangedSubview($0) }
        buttonStackView.setCustomSpacing(16, after: securedView)
        buttonStackView.setCustomSpacing(8, after: continueButton)

        [
            iconView,
            titleStackView,
            priceStackView,
            timerStackView,
            buttonStackView,
        ].forEach { stackView.addArrangedSubview($0) }
        setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            checkedBackgroundView.topAnchor.constraint(equalTo: topAnchor),
            checkedBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            checkedBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            checkedBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),

            headerStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            headerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            headerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            stackView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 60),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            continueButton.heightAnchor.constraint(equalToConstant: 56),
            continueButton.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            iconView.heightAnchor.constraint(equalToConstant: isSmallScreen ? 80 : 120),
            iconView.widthAnchor.constraint(equalToConstant: isSmallScreen ? 80 : 120),

            closeButton.widthAnchor.constraint(equalToConstant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 24),

            termsTextView.heightAnchor.constraint(equalToConstant: 30),
        ])
    }

    func configure(discount: String, price: String, discountPrice: String, expires: String, isGreyFlow: Bool, hasTrial: Bool, trialDuration: String = "", subscriptionDuration: String) {
        configureTitleLabel(discount: discount)
        configurePriceLabel(price: price, discountPrice: discountPrice, isGreyFlow: isGreyFlow, isTrial: hasTrial, subscriptionDuration: subscriptionDuration)
        timerLabel.text = expires
        trialLabel.font = isGreyFlow ? .zalandoSans(.semiBold, size: 28) : .zalandoSans(.semiBold, size: 16)
        trialLabel.text = String(format: NSLocalizedString("limited.trial.label", comment: "Trial label"), trialDuration.uppercased())
        if isGreyFlow {
            DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                self.closeButton.alpha = 1
            }
        } else {
            closeButton.alpha = 1
        }
        trialLabel.isHidden = !hasTrial
    }

    private func configureTitleLabel(discount: String) {
        let firstLine = NSLocalizedString("limited.title.premium", comment: "Premium title")
        let secondLine = String(format: NSLocalizedString("limited.title.discount", comment: "Discount percentage"), discount)
        let fullText = "\(firstLine)\n\(secondLine)"

        let attributedString = NSMutableAttributedString(string: fullText)

        let firstLineRange = NSRange(location: 0, length: firstLine.count)
        attributedString.addAttribute(.font, value: UIFont.zalandoSans(.semiBold, size: isSmallScreen ? 30 : 40), range: firstLineRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.textPrimary, range: firstLineRange)

        let secondLineRange = NSRange(location: firstLine.count + 1, length: secondLine.count)
        attributedString.addAttribute(.font, value: UIFont.zalandoSans(.semiBold, size: isSmallScreen ? 30 : 40), range: secondLineRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.accent, range: secondLineRange)

        titleLabel.attributedText = attributedString
    }

    private func configurePriceLabel(price: String, discountPrice: String, isGreyFlow: Bool, isTrial: Bool, subscriptionDuration: String) {
        let baseString = isTrial ? NSLocalizedString("limited.price.format", comment: "Price format") : NSLocalizedString("limited.price.format.notrial", comment: "Price format")
        let fullText = String(format: baseString, price, discountPrice, subscriptionDuration)
        let attributedString = NSMutableAttributedString(string: fullText)

        let fullRange = NSRange(location: 0, length: fullText.count)
        attributedString.addAttribute(
            .font,
            value: isGreyFlow ? UIFont.zalandoSans(.medium, size: 14) : UIFont.zalandoSans(.semiBold, size: 22),
            range: fullRange
        )
        attributedString.addAttribute(.foregroundColor, value: UIColor.textPrimary, range: fullRange)

        if let priceRange = fullText.range(of: price) {
            let nsRange = NSRange(priceRange, in: fullText)
            attributedString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: nsRange)
            attributedString.addAttribute(.foregroundColor, value: UIColor.textSecondary, range: nsRange)
        }

        priceLabel.attributedText = attributedString
    }
    
    func setupActions(
        closeTarget: Any?,
        closeAction: Selector,
        restoreTarget: Any?,
        restoreAction: Selector,
        continueTarget: Any?,
        continueAction: Selector
    ) {
        closeButton.addTarget(closeTarget, action: closeAction, for: .touchUpInside)
        restoreButton.addTarget(restoreTarget, action: restoreAction, for: .touchUpInside)
        continueButton.addTarget(continueTarget, action: continueAction, for: .touchUpInside)
    }
    
    func setTermsDelegate(_ delegate: TermsTextViewDelegate?) {
        termsTextView.termsDelegate = delegate
    }
    
    func updateTimerLabel(_ timerText: String) {
        timerLabel.text = timerText
    }
}


