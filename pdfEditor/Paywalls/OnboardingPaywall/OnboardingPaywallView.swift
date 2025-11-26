import UIKit
import SnapKit

protocol OnboardingPaywallViewDelegate: AnyObject {
    func onboardingPaywallViewDidTapContinue(_ view: OnboardingPaywallView)
    func onboardingPaywallViewDidTapClose(_ view: OnboardingPaywallView)
}

class OnboardingPaywallView: UIView {
    
    weak var delegate: OnboardingPaywallViewDelegate?
    
    private let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "onbPaywall")
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "closeButton"), for: .normal)
        button.alpha = 0
        return button
    }()
    
    private let pageControlContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundSecondary
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 5
        pageControl.currentPage = 3
        pageControl.pageIndicatorTintColor = .accent.withAlphaComponent(0.3)
        pageControl.currentPageIndicatorTintColor = .accent
        pageControl.isUserInteractionEnabled = false
        
        if #available(iOS 14.0, *) {
            pageControl.backgroundStyle = .minimal
        }
        
        return pageControl
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .zalandoSans(.semiBold, size: 32)
        label.textColor = .textPrimary
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = NSLocalizedString("onboarding.paywall.title", comment: "")
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .zalandoSans(.regular, size: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let continueButton: ActionButton = {
        let button = ActionButton(style: .contained, title: NSLocalizedString("onboarding.button.continue", comment: ""))
        return button
    }()
    
    let termsTextView: TermsTextView = {
        let textView = TermsTextView()
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
        backgroundColor = .backgroundPrimary
        
        addSubview(mainImageView)
        addSubview(closeButton)
        addSubview(pageControlContainer)
        pageControlContainer.addSubview(pageControl)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(continueButton)
        addSubview(termsTextView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        mainImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.55)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(8)
            $0.right.equalToSuperview().inset(16)
            $0.width.height.equalTo(32)
        }
        
        pageControlContainer.snp.makeConstraints {
            $0.top.equalTo(mainImageView.snp.bottom).offset(42)
            $0.centerX.equalToSuperview()
            $0.width.greaterThanOrEqualTo(96)
            $0.height.equalTo(24)
        }
        
        pageControl.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.left.right.equalToSuperview().inset(12)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(pageControlContainer.snp.bottom).offset(32)
            $0.left.right.equalToSuperview().inset(32)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(32)
        }
        
        continueButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-50)
            $0.height.equalTo(56)
        }
        
        termsTextView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(64)
            $0.top.equalTo(continueButton.snp.bottom).offset(8)
        }
    }
    
    private func setupActions() {
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    @objc private func continueButtonTapped() {
        delegate?.onboardingPaywallViewDidTapContinue(self)
    }
    
    @objc private func closeButtonTapped() {
        delegate?.onboardingPaywallViewDidTapClose(self)
    }
    
    func configure(type: OnboardingPaywallType, descriptionText: String) {
        backgroundColor = type.backgroundColor
        descriptionLabel.font = .zalandoSans(.regular, size: type.descriptionFontSize)
        descriptionLabel.textColor = type.descriptionTextColor
        descriptionLabel.text = descriptionText
        
        switch type {
        case .white:
            pageControl.currentPage = 3
        case .grey:
            pageControl.currentPage = 3
        }
        
        if type.showCloseButtonImmediately {
            showCloseButton(animated: false)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + type.closeButtonDelay) { [weak self] in
                self?.showCloseButton(animated: true)
            }
        }
    }
    
    private func showCloseButton(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.closeButton.alpha = 0.15
            }
        } else {
            closeButton.alpha = 0.15
        }
    }
}

