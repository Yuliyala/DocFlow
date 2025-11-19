import UIKit
import SnapKit

protocol AddDocumentViewDelegate: AnyObject {
    func addDocumentViewDidTapClose()
    func addDocumentViewDidSelectOption(_ option: AddDocumentOption)
}

final class AddDocumentView: UIView {
    
    weak var delegate: AddDocumentViewDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("add_document.title", comment: "Add Document")
        label.font = .zalandoSans(.medium, size: 16)
        label.textColor = UIColor.textPrimary
        label.textAlignment = .center
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        button.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
        button.tintColor = UIColor.textSecondary
        button.backgroundColor = UIColor.backgroundSecondary
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.strokePrimary.cgColor
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        return button
    }()
    
    private var optionCards: [AddDocumentOption: UIView] = [:]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor.primary
        
        addSubview(titleLabel)
        addSubview(closeButton)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.centerX.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.height.equalTo(40)
        }
        
        setupOptionCards()
    }
    
    private func setupOptionCards() {
        let galleryCard = createCard(for: .gallery)
        let filesCard = createCard(for: .files)
        let scanCard = createCard(for: .scan, fullWidth: true)
        
        optionCards[.gallery] = galleryCard
        optionCards[.files] = filesCard
        optionCards[.scan] = scanCard
        
        let topStackView = UIStackView(arrangedSubviews: [galleryCard, filesCard])
        topStackView.axis = .horizontal
        topStackView.spacing = 12
        topStackView.distribution = .fillEqually
        
        addSubview(topStackView)
        addSubview(scanCard)
        
        topStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(95)
        }
        
        scanCard.snp.makeConstraints {
            $0.top.equalTo(topStackView.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(64)
            $0.bottom.lessThanOrEqualTo(safeAreaLayoutGuide).offset(20)
        }
    }
    
    private func createCard(for option: AddDocumentOption, fullWidth: Bool = false) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor.white
        container.layer.cornerRadius = 24
        
        let iconView = UIImageView(image: option.icon)
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = UIColor.accent
        
        let label = UILabel()
        label.text = option.title
        label.font = .zalandoSans(.medium, size: 16)
        label.textColor = UIColor.textPrimary
        
        let arrowView = UIImageView(image: .arrowRight)
        arrowView.contentMode = .scaleAspectFit
        arrowView.tintColor = UIColor.textSecondary
        
        container.addSubview(iconView)
        container.addSubview(label)
        container.addSubview(arrowView)
        
        if fullWidth {
            iconView.snp.makeConstraints {
                $0.left.equalToSuperview().offset(16)
                $0.centerY.equalToSuperview()
                $0.width.height.equalTo(32)
            }
            
            label.snp.makeConstraints {
                $0.left.equalTo(iconView.snp.right).offset(12)
                $0.centerY.equalToSuperview()
            }
            
            arrowView.snp.makeConstraints {
                $0.right.equalToSuperview().offset(-16)
                $0.centerY.equalToSuperview()
                $0.width.equalTo(8)
                $0.height.equalTo(14)
            }
        } else {
            iconView.snp.makeConstraints {
                $0.top.equalToSuperview().offset(20)
                $0.left.equalToSuperview().offset(16)
                $0.width.height.equalTo(32)
            }
            
            label.snp.makeConstraints {
                $0.top.equalTo(iconView.snp.bottom).offset(12)
                $0.left.equalToSuperview().offset(16)
                $0.right.equalToSuperview().offset(-16)
            }
            
            arrowView.snp.makeConstraints {
                $0.top.equalToSuperview().offset(20)
                $0.right.equalToSuperview().offset(-16)
                $0.width.equalTo(8)
                $0.height.equalTo(14)
            }
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped(_:)))
        container.addGestureRecognizer(tapGesture)
        container.isUserInteractionEnabled = true
        container.tag = option.hashValue
        
        return container
    }
    
    @objc private func closeTapped() {
        delegate?.addDocumentViewDidTapClose()
    }
    
    @objc private func cardTapped(_ gesture: UITapGestureRecognizer) {
        guard let view = gesture.view else { return }
        
        let option = AddDocumentOption.allCases.first { $0.hashValue == view.tag }
        
        if let option = option {
            delegate?.addDocumentViewDidSelectOption(option)
        }
    }
}

