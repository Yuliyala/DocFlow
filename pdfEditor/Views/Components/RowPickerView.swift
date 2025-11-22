import UIKit

class RowPickerView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .zalandoSans(.medium, size: 16)
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .zalandoSans(.regular, size: 16)
        label.textColor = .textPrimary
        label.text = "Select"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .textPrimary
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
        return stack
    }()
    
    private let rightStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()
    
    var value: String? {
        didSet {
            valueLabel.text = value ?? "Select"
            valueLabel.textColor = value != nil ? .textPrimary : .textSecondary
        }
    }
    
    var isBordered: Bool = true {
        didSet {
            layer.borderWidth = isBordered ? 1 : 0
        }
    }
    
    var onTap: (() -> Void)?
    
    init(title: String, value: String? = nil, isBordered: Bool = true) {
        super.init(frame: .zero)
        setupView()
        titleLabel.text = title
        self.value = value
        self.isBordered = isBordered
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .backgroundSecondary
        layer.cornerRadius = 20
        layer.borderWidth = isBordered ? 1 : 0
        layer.borderColor = UIColor.strokePrimary.cgColor
        
        addSubview(containerStackView)
        
        rightStackView.addArrangedSubview(valueLabel)
        rightStackView.addArrangedSubview(chevronImageView)
        
        containerStackView.addArrangedSubview(titleLabel)
        containerStackView.addArrangedSubview(.horizontalSpacer())
        containerStackView.addArrangedSubview(rightStackView)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            chevronImageView.widthAnchor.constraint(equalToConstant: 12),
            chevronImageView.heightAnchor.constraint(equalToConstant: 12)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
    }
    
    @objc private func handleTap() {
        onTap?()
    }
}

