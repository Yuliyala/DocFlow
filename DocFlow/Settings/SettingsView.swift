import UIKit
import SnapKit

protocol SettingsViewDelegate: AnyObject {
    func settingsViewDidSelectOption(_ option: SettingsOption)
    func settingsViewDidTapBanner()
}

class SettingsView: UIView {
    weak var delegate: SettingsViewDelegate?
    
    let navBar = {
        let view = CustomNavBar()
        view.set(title: NSLocalizedString("tab.settings", comment: ""))
        view.set(searchHidden: true)
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        if isSmallScreen {
            scrollView.contentInset.bottom = 110
        }
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [limitedBanner] + optionViews)
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(
            top: 0,
            left: 16,
            bottom: 16,
            right: 16
        )
        return stackView
    }()
    
    lazy var optionViews = SettingsOption.allCases.map(optionView(option:))
    
    let limitedBanner = LimitedBanner()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .background
        addSubview(navBar)
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        navBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(20)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(self)
        }
        
        stackView.setCustomSpacing(16, after: limitedBanner)
        setupGestureRecognizers()
    }
    
    private func optionView(option: SettingsOption) -> UIView {
        let view = CapsuleContentView()
        view.contentBackgroundColor = .white
        view.contentInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        view.isShadowEnabled = false
        
        let iconView = UIImageView()
        iconView.image = option.image
        iconView.contentMode = .scaleAspectFit

        let label = UILabel()
        label.textAlignment = .left
        label.font = .zalandoSans(.medium, size: 16)
        label.textColor = .textPrimary
        label.text = option.title

        let chevron = UIImageView(image: .arrowRight)
        chevron.contentMode = .scaleAspectFit

        iconView.snp.makeConstraints {
            $0.width.height.equalTo(40)
        }

        chevron.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        view.setContent([iconView, label, UIView.horizontalSpacer(), chevron])
        return view
    }
    
    private func setupGestureRecognizers() {
        let bannerTapGesture = UITapGestureRecognizer(target: self, action: #selector(bannerTapped))
        limitedBanner.addGestureRecognizer(bannerTapGesture)
        limitedBanner.isUserInteractionEnabled = true

        for (index, optionView) in optionViews.enumerated() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(optionTapped(_:)))
            optionView.addGestureRecognizer(tapGesture)
            optionView.isUserInteractionEnabled = true
            optionView.tag = index
        }
    }
    
    @objc private func bannerTapped() {
        delegate?.settingsViewDidTapBanner()
    }

    @objc private func optionTapped(_ gesture: UITapGestureRecognizer) {
        guard let view = gesture.view,
              view.tag < SettingsOption.allCases.count else { return }

        let option = SettingsOption.allCases[view.tag]
        delegate?.settingsViewDidSelectOption(option)
    }
}

