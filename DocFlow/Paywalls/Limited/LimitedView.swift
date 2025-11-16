import UIKit
import SnapKit

class LimitedView: UIView {

    private let checkedBackgroundView: CheckedView = {
        let view = CheckedView()
        return view
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 16
        return stackView
    }()

    private let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()

    let restoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("paywall.button.restore", comment: "Restore button"), for: .normal)
        button.setTitleColor(.textSecondary, for: .normal)
        button.titleLabel?.font = .zalandoSans(.medium, size: 16)
        button.isHidden = AppHudService.shared.hasSubscribed
        return button
    }()

    let closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "closeButton"), for: .normal)
        button.alpha = 0
        return button
    }()

    private let confettiImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .confetti
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let limitedTimeLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("limited.time.offer", comment: "LIMITED-TIME OFFER")
        label.font = .zalandoSans(.semiBold, size: 16)
        label.textColor = .accent
        label.textAlignment = .center
        return label
    }()

    private let crownImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .crown
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .zalandoSans(.semiBold, size: 32)
        label.textColor = .textPrimary
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()

    private let categoriesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        return stackView
    }()

    private let trialLabel: CapsuledLabel = {
        let label = CapsuledLabel()
        label.font = .zalandoSans(.semiBold, size: 14)
        label.textColor = .white
        label.backgroundColor = .accent
        label.insets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        label.text = String(format: NSLocalizedString("limited.trial.label", comment: "Trial label"), "")
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
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
        stackView.spacing = 8
        return stackView
    }()

    private let expiresLabel: UILabel = {
        let label = UILabel()
        label.font = .zalandoSans(.medium, size: 16)
        label.textColor = .textPrimary
        label.text = NSLocalizedString("limited.expires.label", comment: "Expires label")
        return label
    }()

    private let timerCapsuleView: CapsuleContentView = {
        let capsule = CapsuleContentView()
        capsule.contentBackgroundColor = .white
        capsule.contentInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        capsule.spacing = 8
        return capsule
    }()
    
    private let clockImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .clock
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .accent
        return imageView
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.font = .zalandoSans(.medium, size: 18)
        label.textColor = .textPrimary
        label.text = NSLocalizedString("limited.timer.placeholder", comment: "Timer placeholder")
        return label
    }()

    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()

    let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("paywall.button.continue", comment: "Continue button"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .zalandoSans(.medium, size: 16)
        button.backgroundColor = UIColor.accent
        button.layer.cornerRadius = 16
        return button
    }()

    private let securedView: CapsuleContentView = {
        let view = CapsuleContentView.createSecurityCapsule()
        return view
    }()

    let termsTextView: TermsTextView = {
        let view = TermsTextView()
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
        backgroundColor = .background
        
        addSubview(checkedBackgroundView)
        addSubview(headerStackView)
        addSubview(stackView)
        addSubview(confettiImageView)

        [restoreButton, .horizontalSpacer(), closeButton].forEach { headerStackView.addArrangedSubview($0) }
        
        LimitedViewCategory.allCases.forEach { category in
            let capsuleView = capsuleViewForCategory(category)
            categoriesStackView.addArrangedSubview(capsuleView)
        }
        
        timerCapsuleView.setContent([clockImageView, timerLabel])
        timerCapsuleView.customCornerRadius = 10
        
        [trialLabel, priceLabel, timerCapsuleView].forEach { priceStackView.addArrangedSubview($0) }
        [securedView, continueButton, termsTextView].forEach { buttonStackView.addArrangedSubview($0) }
        buttonStackView.setCustomSpacing(16, after: securedView)
        buttonStackView.setCustomSpacing(8, after: continueButton)

        [
            crownImageView,
            limitedTimeLabel,
            titleLabel,
            categoriesStackView,
            priceStackView,
            buttonStackView,
        ].forEach { stackView.addArrangedSubview($0) }
        
        setupConstraints()
    }

    func setupConstraints() {
        checkedBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        headerStackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(8)
            $0.left.right.equalToSuperview().inset(16)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(headerStackView.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-8)
        }
        
        let crownSize: CGFloat = if isSmallScreen {
            42
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            80
        } else {
            56
        }
        
        crownImageView.snp.makeConstraints {
            $0.width.height.equalTo(crownSize)
        }
        
        confettiImageView.snp.makeConstraints {
            $0.centerX.equalTo(crownImageView)
            $0.top.equalTo(crownImageView)
            $0.left.right.equalToSuperview().inset(16)
        }
        
        clockImageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        continueButton.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.width.equalTo(stackView)
        }
        
        closeButton.snp.makeConstraints {
            $0.width.height.equalTo(16)
        }
        
        termsTextView.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        
        categoriesStackView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
        }
    }

    func configure(discount: String, price: String, discountPrice: String, expires: String, isGreyFlow: Bool, hasTrial: Bool, trialDuration: String = "", subscriptionDuration: String) {
        configureTitleLabel()
        configurePriceLabel(price: price, discountPrice: discountPrice, isGreyFlow: isGreyFlow, isTrial: hasTrial, subscriptionDuration: subscriptionDuration)
        timerLabel.text = expires
        trialLabel.text = String(format: NSLocalizedString("limited.trial.label", comment: "Trial label"), trialDuration.uppercased())
        
        if isGreyFlow {
            continueButton.setTitle(NSLocalizedString("limited.button.try_free", comment: "Try Free button"), for: .normal)
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                UIView.animate(withDuration: 0.3) {
                    self.closeButton.alpha = 0.15
                }
            }
        } else {
            continueButton.setTitle(NSLocalizedString("paywall.button.continue", comment: "Continue button"), for: .normal)
            closeButton.alpha = 0.15
        }
        
        trialLabel.isHidden = !hasTrial
    }

    private func configureTitleLabel() {
        let fullText = NSLocalizedString("limited.title.full", comment: "Unlock Full Access\nto PDF Editor")
        let attributedString = NSMutableAttributedString(string: fullText)

        let fullRange = NSRange(location: 0, length: fullText.count)
        attributedString.addAttribute(.font, value: UIFont.zalandoSans(.semiBold, size: isSmallScreen ? 24 : 32), range: fullRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.textPrimary, range: fullRange)

        if let pdfEditorRange = fullText.range(of: "PDF Editor") {
            let nsRange = NSRange(pdfEditorRange, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: UIColor.accent, range: nsRange)
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byWordWrapping
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: fullRange)

        titleLabel.attributedText = attributedString
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
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
    
    private func capsuleViewForCategory(_ category: LimitedViewCategory) -> CapsuleContentView {
        let capsuleView = CapsuleContentView()

        let iconImageView = UIImageView()
        iconImageView.image = category.icon
        iconImageView.tintColor = .accent
        iconImageView.contentMode = .scaleAspectFit
        
        let textStackView = UIStackView()
        textStackView.axis = .vertical
        textStackView.alignment = .leading
        textStackView.distribution = .fill
        textStackView.spacing = 2

        let titleLabel = UILabel()
        titleLabel.text = category.title
        let fontSize: CGFloat = if isSmallScreen {
            12
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            22
        } else {
            14
        }
        titleLabel.font = .zalandoSans(.medium, size: fontSize)
        titleLabel.textColor = .textPrimary
        titleLabel.numberOfLines = 1
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = category.description
        let descFontSize: CGFloat = if isSmallScreen {
            10
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            16
        } else {
            12
        }
        descriptionLabel.font = .zalandoSans(.regular, size: descFontSize)
        descriptionLabel.textColor = .textSecondary
        descriptionLabel.numberOfLines = 1
        
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(descriptionLabel)

        capsuleView.setContent([iconImageView, textStackView])
        capsuleView.customCornerRadius = 24
        capsuleView.contentInsets = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)

        let iconSize: CGFloat = if isSmallScreen {
           36
        } else if UIDevice.current.userInterfaceIdiom == .pad {
           64
        } else {
           48
        }
        
        iconImageView.snp.makeConstraints {
            $0.width.height.equalTo(iconSize)
        }

        return capsuleView
    }
}

enum LimitedViewCategory: CaseIterable {
    case editor
    case converter
    case scanner
    
    var title: String {
        switch self {
        case .editor:
            return NSLocalizedString("paywall.category.edit.title", comment: "Edit PDF Files")
        case .converter:
            return NSLocalizedString("paywall.category.convert.title", comment: "Converter All File Formats")
        case .scanner:
            return NSLocalizedString("paywall.category.scan.title", comment: "Scanning & Printing")
        }
    }
    
    var description: String {
        switch self {
        case .editor:
            return NSLocalizedString("paywall.category.edit.description", comment: "Customize your PDFs with intuitive editing tools.")
        case .converter:
            return NSLocalizedString("paywall.category.convert.description", comment: "Easily convert any file type to PDF in seconds.")
        case .scanner:
            return NSLocalizedString("paywall.category.scan.description", comment: "Turn paper into digital files and print with ease.")
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .editor:
            return .docIcon
        case .converter:
            return .pdfIcon
        case .scanner:
            return .scanningIcon
        }
    }
}
