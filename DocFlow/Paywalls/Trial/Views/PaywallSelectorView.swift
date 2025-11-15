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

    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()

    let weeklySelector: PaywallSelectorSection = {
        let view = PaywallSelectorSection()
        return view
    }()

    let monthlySelector: PaywallSelectorSection = {
        let view = PaywallSelectorSection()
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

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.layer.cornerRadius = 24
        contentView.clipsToBounds = true
    }

    private func setupView() {
        backgroundColor = .clear
        
        addSubview(contentView)
        contentView.addSubview(stackView)

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
    
    func configureWeeklySection(infoText: String?, title: String, description: NSAttributedString, backgroundImage: String) {
        weeklySelector.configure(infoText: infoText, title: title, description: description, backgroundImage: backgroundImage)
    }
    
    func configureWeeklySection(infoText: String?, title: String, description: String, backgroundImage: String) {
        weeklySelector.configure(infoText: infoText, title: title, description: description, backgroundImage: backgroundImage)
    }
    
    func configureMonthlySection(infoText: String?, title: String, description: NSAttributedString, backgroundImage: String) {
        monthlySelector.configure(infoText: infoText, title: title, description: description, backgroundImage: backgroundImage)
    }
    
    func configureMonthlySection(infoText: String?, title: String, description: String, backgroundImage: String) {
        monthlySelector.configure(infoText: infoText, title: title, description: description, backgroundImage: backgroundImage)
    }

    private func setupConstraints() {
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
    }
}

class PaywallSelectorSection: UIView {
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 24
        return imageView
    }()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 4
        return stackView
    }()

    private let radioButton: RadioButton = {
        let radioButton = RadioButton()
        radioButton.isUserInteractionEnabled = false
        return radioButton
    }()

    private lazy var infoView: CapsuledLabel = {
        let view = CapsuledLabel()
        view.textColor = .white
        view.backgroundColor = .accent
        view.font = .zalandoSans(.medium, size: isSmallScreen ? 10 : 12)
        view.insets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .zalandoSans(.semiBold, size: isSmallScreen ? 24 : 32)
        label.textColor = .textPrimary
        label.textAlignment = .center
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .zalandoSans(.regular, size: 16)
        label.textColor = .textPrimary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .zalandoSans(.regular, size: 14)
        label.textColor = .textSecondary
        label.textAlignment = .center
        return label
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
        backgroundColor = .clear
        layer.cornerRadius = 24
        clipsToBounds = true
        
        addSubview(backgroundImageView)
        addSubview(contentStackView)
        addSubview(radioButton)
        addSubview(infoView)
        
        [titleLabel, priceLabel, descriptionLabel].forEach { contentStackView.addArrangedSubview($0) }

        self.snp.makeConstraints {
            $0.height.equalTo(129)
        }
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview().offset(8)
            $0.trailing.lessThanOrEqualToSuperview().offset(-8)
        }
        
        radioButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-24)
            $0.width.height.equalTo(24)
        }
        
        infoView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.lessThanOrEqualTo(radioButton.snp.leading).offset(-4)
        }
    }
    
    func setBackgroundImage(_ imageName: String) {
        backgroundImageView.image = UIImage(named: imageName)
    }

    func setSelected(_ isSelected: Bool) {
        radioButton.setChecked(isSelected, animated: true)
        
        if isSelected {
            backgroundImageView.layer.borderWidth = 1
            backgroundImageView.layer.borderColor = UIColor.accent.cgColor
        } else {
            backgroundImageView.layer.borderWidth = 0
            backgroundImageView.layer.borderColor = nil
        }
    }
    
    func configure(infoText: String?, title: String, price: String, weeklyPrice: String, backgroundImage: String) {
        if let infoText = infoText, !infoText.isEmpty {
            infoView.text = infoText
            infoView.isHidden = false
        } else {
            infoView.isHidden = true
        }
        
        titleLabel.text = title
        priceLabel.text = price
        descriptionLabel.text = weeklyPrice
        backgroundImageView.image = UIImage(named: backgroundImage)
    }
    
    func configure(infoText: String?, title: String, description: NSAttributedString, backgroundImage: String) {
        if let infoText = infoText, !infoText.isEmpty {
            infoView.text = infoText
            infoView.isHidden = false
        } else {
            infoView.isHidden = true
        }
        
        titleLabel.text = title
        priceLabel.attributedText = description
        descriptionLabel.text = ""
        backgroundImageView.image = UIImage(named: backgroundImage)
    }
    
    func configure(infoText: String?, title: String, description: String, backgroundImage: String) {
        let attributedDescription = NSAttributedString(
            string: description,
            attributes: [
                .font: UIFont.zalandoSans(.regular, size: 16),
                .foregroundColor: UIColor.textPrimary
            ]
        )
        configure(infoText: infoText, title: title, description: attributedDescription, backgroundImage: backgroundImage)
    }
}


