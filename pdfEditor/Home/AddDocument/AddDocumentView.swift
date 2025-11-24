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
        let galleryCard = AddDocumentOptionCard(option: .gallery)
        let filesCard = AddDocumentOptionCard(option: .files)
        let scanCard = AddDocumentOptionCard(option: .scan, fullWidth: true)
        
        [galleryCard, filesCard, scanCard].forEach { card in
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped(_:)))
            card.addGestureRecognizer(tapGesture)
            card.isUserInteractionEnabled = true
        }
        
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
    
    @objc private func closeTapped() {
        delegate?.addDocumentViewDidTapClose()
    }
    
    @objc private func cardTapped(_ gesture: UITapGestureRecognizer) {
        guard let card = gesture.view as? AddDocumentOptionCard else { return }
        delegate?.addDocumentViewDidSelectOption(card.option)
    }
}

