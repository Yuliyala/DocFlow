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

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        let fontSize: CGFloat = isPad ? 42 : 32
        label.font = .zalandoSans(.semiBold, size: fontSize)
        label.textColor = .textPrimary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        let fontSize: CGFloat = isPad ? 20 : 16
        label.font = .zalandoSans(.regular, size: fontSize)
        label.textColor = .textPrimary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    lazy var continueButton: ActionButton = {
        let button = ActionButton(style: .contained, title: NSLocalizedString("onboarding.button.continue", comment: ""))
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
        backgroundColor = .backgroundPrimary
        
        addSubview(mainImageView)
        addSubview(pageControlContainer)
        pageControlContainer.addSubview(pageControl)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(continueButton)
        
        setupConstraints()
    }

    private func setupConstraints() {
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        
        mainImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.58)
        }
        
        let pageControlTopOffset: CGFloat = isPad ? 70 : 50
        let pageControlHeight: CGFloat = isPad ? 32 : 24
        pageControlContainer.snp.makeConstraints {
            $0.top.equalTo(mainImageView.snp.bottom).offset(pageControlTopOffset)
            $0.centerX.equalToSuperview()
            $0.width.greaterThanOrEqualTo(96)
            $0.height.equalTo(pageControlHeight)
        }
        
        pageControl.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.left.right.equalToSuperview().inset(12)
        }
        
        let titleTopOffset: CGFloat = isPad ? 42 : 32
        let horizontalInset: CGFloat = isPad ? 48 : 32
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(pageControlContainer.snp.bottom).offset(titleTopOffset)
            $0.left.right.equalToSuperview().inset(horizontalInset)
        }
        
        let descriptionTopOffset: CGFloat = isPad ? 12 : 8
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(descriptionTopOffset)
            $0.left.right.equalToSuperview().inset(horizontalInset)
        }
        
        let buttonInset: CGFloat = isPad ? 24 : 16
        let buttonBottomOffset: CGFloat = isPad ? -80 : -50
        let buttonHeight: CGFloat = isPad ? 68 : 56
        continueButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(buttonInset)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(buttonBottomOffset)
            $0.height.equalTo(buttonHeight)
        }
    }

    func configure(with onboarding: Onboarding) {
        mainImageView.image = onboarding.image
        titleLabel.text = onboarding.title
        descriptionLabel.text = onboarding.body
        pageControl.currentPage = onboarding.currentPage
        
        if mainImageView.image == nil {
            mainImageView.backgroundColor = .backgroundSecondary
            mainImageView.layer.cornerRadius = 16
            mainImageView.clipsToBounds = true
        }
    }
}
