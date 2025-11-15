import UIKit
import SnapKit

class OnboardingView: UIView {

    private let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        return imageView
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
        pageControl.currentPage = 0
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
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .zalandoSans(.regular, size: 16)
        label.textColor = .textPrimary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("onboarding.button.continue", comment: ""), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .zalandoSans(.medium, size: 16)
        button.backgroundColor = .accent
        button.layer.cornerRadius = 16
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = .background
        
        addSubview(mainImageView)
        addSubview(pageControlContainer)
        pageControlContainer.addSubview(pageControl)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(continueButton)
        
        setupConstraints()
    }

    private func setupConstraints() {
        mainImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.58)
        }
        
        pageControlContainer.snp.makeConstraints {
            $0.top.equalTo(mainImageView.snp.bottom).offset(50)
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
    }

    func configure(with onboarding: Onboarding) {
        mainImageView.image = onboarding.image
        titleLabel.text = onboarding.title
        descriptionLabel.text = onboarding.body
        
        switch onboarding {
        case .first:
            pageControl.currentPage = 0
        case .second:
            pageControl.currentPage = 1
        case .third:
            pageControl.currentPage = 2
        }
        
        if mainImageView.image == nil {
            mainImageView.backgroundColor = .backgroundSecondary
            mainImageView.layer.cornerRadius = 16
            mainImageView.clipsToBounds = true
        }
    }
}
