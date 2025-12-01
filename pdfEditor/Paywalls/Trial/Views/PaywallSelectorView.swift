import UIKit
import SnapKit

protocol PaywallSelectorViewDelegate: AnyObject {
    func paywallSelectorView(_ selectorView: PaywallSelectorView, didSelectIndex index: Int)
}

class PaywallSelectorView: UIView {

    weak var delegate: PaywallSelectorViewDelegate?
    
    private var selectedIndex: Int = 0 {
        didSet {
            updateSelectionState()
        }
    }

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()

    let weeklySelector: PaywallSelectorSection = {
        let view = PaywallSelectorSection(isMainInfoStyle: true)
        return view
    }()

    let monthlySelector: PaywallSelectorSection = {
        let view = PaywallSelectorSection(isMainInfoStyle: false)
        return view
    }()

    init() {
        super.init(frame: .zero)
        setupView()
        setupTapGestures()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupTapGestures()
    }

    private func setupView() {
        backgroundColor = .clear
        
        addSubview(stackView)

        [weeklySelector, monthlySelector].forEach { stackView.addArrangedSubview($0) }

        setupConstraints()
        
        selectedIndex = 0
    }
    
    private func setupTapGestures() {
        let weeklyTapGesture = UITapGestureRecognizer(target: self, action: #selector(weeklyTapped))
        weeklySelector.addGestureRecognizer(weeklyTapGesture)
        
        let monthlyTapGesture = UITapGestureRecognizer(target: self, action: #selector(monthlyTapped))
        monthlySelector.addGestureRecognizer(monthlyTapGesture)
    }
    
    @objc private func weeklyTapped() {
        selectIndex(0)
    }
    
    @objc private func monthlyTapped() {
        selectIndex(1)
    }
    
    private func selectIndex(_ index: Int) {
        guard index != selectedIndex else { return }
        selectedIndex = index
        delegate?.paywallSelectorView(self, didSelectIndex: index)
    }
    
    private func updateSelectionState() {
        weeklySelector.setSelected(selectedIndex == 0)
        monthlySelector.setSelected(selectedIndex == 1)
    }
    
    func setSelectedIndex(_ index: Int, animated: Bool = false) {
        guard index >= 0 && index <= 1 else { return }
        selectedIndex = index
    }
    
    func configureWeeklySection(infoText: String?, title: String, description: NSAttributedString) {
        weeklySelector.configure(infoText: infoText, title: title, description: description)
    }
    
    func configureWeeklySection(infoText: String?, title: String, description: String) {
        weeklySelector.configure(infoText: infoText, title: title, description: description)
    }
    
    func configureMonthlySection(infoText: String?, title: String, description: NSAttributedString) {
        monthlySelector.configure(infoText: infoText, title: title, description: description)
    }
    
    func configureMonthlySection(infoText: String?, title: String, description: String) {
        monthlySelector.configure(infoText: infoText, title: title, description: description)
    }

    private func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

class PaywallSelectorSection: RoundedShadowView {
    
    let isMainInfoStyle: Bool
    
    private let radioButton: RadioButton = {
        let radioButton = RadioButton()
        radioButton.isUserInteractionEnabled = false
        return radioButton
    }()

    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var infoBackground: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 24
//        view.backgroundColor = isMainInfoStyle ? .accent : .accentSecondary
        return view
    }()

    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = .zalandoSans(.regular, size: isSmallScreen ? 11 : 11)
        label.textColor = isMainInfoStyle ? .white : .accent
        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .zalandoSans(.semiBold, size: isSmallScreen ? 14 : 18)
        label.textColor = .textPrimary
        label.textAlignment = .center
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .zalandoSans(.regular, size: isSmallScreen ? 14 : 16)
        label.textColor = .textSecondary
        label.textAlignment = .center
        return label
    }()

    init(isMainInfoStyle: Bool = false) {
        self.isMainInfoStyle = isMainInfoStyle
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        self.isMainInfoStyle = false
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        cornerRadius = 24
        contentView.backgroundColor = .white
        contentView.clipsToBounds = true
        
        [titleStackView, radioButton, infoBackground, infoLabel].forEach { contentView.addSubview($0) }
        [titleLabel, descriptionLabel].forEach { titleStackView.addArrangedSubview($0) }
        
        self.snp.makeConstraints {
            $0.height.equalTo(isSmallScreen ? 70 : 108)
        }
        
        radioButton.snp.makeConstraints {
            $0.width.height.equalTo(isSmallScreen ? 14 : 24)
            $0.top.equalToSuperview().offset(isSmallScreen ? 8 : 12)
            $0.trailing.equalToSuperview().offset(isSmallScreen ? -8 : -12)
        }
        
        titleStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        infoLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(isSmallScreen ? 2 : 5)
            $0.leading.equalToSuperview().offset(12)
        }
        
        infoBackground.snp.makeConstraints {
            $0.top.equalToSuperview().offset(isSmallScreen ? -16 : -24)
            $0.height.equalTo(isSmallScreen ? 32 : 48)
            $0.width.equalTo(200)
            $0.trailing.equalTo(infoLabel.snp.trailing).offset(12)
        }
    }
    
    func setSelected(_ isSelected: Bool) {
        radioButton.setChecked(isSelected, animated: true)
        contentView.layer.borderColor = isSelected ? UIColor.accent.cgColor : UIColor.clear.cgColor
        contentView.layer.borderWidth = isSelected ? 1 : 0
    }
    
    func configure(infoText: String?, title: String, description: NSAttributedString) {
        if let infoText = infoText, !infoText.isEmpty {
            infoLabel.text = infoText
            infoLabel.isHidden = false
            infoBackground.isHidden = false
        } else {
            infoLabel.isHidden = true
            infoBackground.isHidden = true
        }
        
        titleLabel.text = title
        descriptionLabel.attributedText = description
    }
    
    func configure(infoText: String?, title: String, description: String) {
        let attributedDescription = NSAttributedString(
            string: description,
            attributes: [
                .font: UIFont.zalandoSans(.regular, size: isSmallScreen ? 14 : 16),
                .foregroundColor: UIColor.textSecondary
            ]
        )
        configure(infoText: infoText, title: title, description: attributedDescription)
    }
}


