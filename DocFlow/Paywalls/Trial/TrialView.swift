import UIKit
import SnapKit

protocol TrialViewDelegate: AnyObject {
    func trialViewDidTapRestore()
    func trialViewDidTapClose()
    func continueTapped()
}

class TrialView: UIView {

    weak var delegate: TrialViewDelegate?

    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "paywallBackground")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = UIDevice.current.userInterfaceIdiom == .pad ? 32 : 16
        return stackView
    }()

    private let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()

    private let restoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("paywall.button.restore", comment: "Restore button"), for: .normal)
        button.setTitleColor(.textSecondary, for: .normal)
        button.titleLabel?.font = .zalandoSans(.medium, size: 16)
        return button
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "closeButton"), for: .normal)
        button.alpha = 0.15
        return button
    }()

    private let crownImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "crown")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .zalandoSans(.semiBold, size: isSmallScreen ? 24 : 32)
        label.textColor = .textPrimary
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        let fullText = NSLocalizedString("paywall.trial.title", comment: "Unlock Full Access to PDF Editor")
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let attributedString = NSMutableAttributedString(
            string: fullText,
            attributes: [
                .font: UIFont.zalandoSans(.semiBold, size: isSmallScreen ? 24 : 32),
                .foregroundColor: UIColor.textPrimary,
                .paragraphStyle: paragraphStyle
            ]
        )
        
        if let range = fullText.range(of: "PDF Editor") {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: UIColor.accent, range: nsRange)
        }
        
        label.attributedText = attributedString
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()

    private let categoriesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()

    private lazy var categoryViews: [CapsuleContentView] = [
        capsuleViewForCategory(.editor),
        capsuleViewForCategory(.converter),
        capsuleViewForCategory(.scanner),
    ]

    lazy var continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("paywall.button.continue", comment: "Continue button"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .zalandoSans(.medium, size: 16)
        button.backgroundColor = UIColor.accent
        button.layer.cornerRadius = isSmallScreen ? 12 : 16
        return button
    }()

    private let securedView: CapsuleContentView = {
        let view = CapsuleContentView.createSecurityCapsule()
        return view
    }()

    let paywallSelectorView: PaywallSelectorView = {
        let view = PaywallSelectorView()
        return view
    }()

    let termsTextView: TermsTextView = {
        let view = TermsTextView()
        return view
    }()

    init() {
        super.init(frame: .zero)
        setupView()
        setupActions()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupActions()
    }

    private func setupView() {
        addSubview(backgroundImageView)
        addSubview(headerStackView)
        addSubview(stackView)
        
        headerStackView.addArrangedSubview(restoreButton)
        headerStackView.addArrangedSubview(.horizontalSpacer())
        headerStackView.addArrangedSubview(closeButton)

        [
            crownImageView,
            titleLabel,
            categoriesStackView,
            paywallSelectorView,
            securedView,
            continueButton,
            termsTextView
        ].forEach { stackView.addArrangedSubview($0) }

        categoryViews.forEach { categoriesStackView.addArrangedSubview($0) }
        setupConstraints()
    }

    private func setupActions() {
        restoreButton.addTarget(self, action: #selector(restoreButtonTapped), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        continueButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            animateButton(self.continueButton) {
                self.delegate?.continueTapped()
            }
        }), for: .primaryActionTriggered)
    }

    @objc private func restoreButtonTapped() {
        delegate?.trialViewDidTapRestore()
    }

    @objc private func closeButtonTapped() {
        delegate?.trialViewDidTapClose()
    }

    private func capsuleViewForCategory(_ category: TrialViewCategory) -> CapsuleContentView {
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

    private func setupConstraints() {
        let crownSize: CGFloat = if isSmallScreen {
            42
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            80
        } else {
            56
        }
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        headerStackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(8)
            $0.left.right.equalToSuperview().inset(16)
        }
        
        closeButton.snp.makeConstraints {
            $0.width.height.equalTo(16)
        }

        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(89)
            $0.left.right.equalToSuperview().inset(4)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-8)
        }
        
        crownImageView.snp.makeConstraints {
            $0.width.height.equalTo(crownSize)
        }
        
        titleLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.greaterThanOrEqualTo(isSmallScreen ? 60 : 80)
        }
        
        categoriesStackView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
        }
        
        continueButton.snp.makeConstraints {
            $0.height.equalTo(isSmallScreen ? 40 : 56)
            $0.left.right.equalToSuperview().inset(16)
        }
        
        paywallSelectorView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
        }
        
        securedView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(32)
        }
        
        termsTextView.snp.makeConstraints {
            $0.height.equalTo(30)
        }
    }
}


