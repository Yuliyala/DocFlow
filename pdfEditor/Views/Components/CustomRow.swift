import UIKit

class CustomRow: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .zalandoSans(.medium, size: 20)
        label.textColor = .textPrimary
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 20, trailing: 16)
        return stack
    }()
    
    private var rightView: UIView?
    
    var isBordered: Bool = false {
        didSet {
            layer.borderWidth = isBordered ? 1 : 0
        }
    }
    
    var onTap: (() -> Void)?
    
    init(title: String, titleFont: UIFont? = nil, paddingV: CGFloat = 20, isBordered: Bool = false, rightView: UIView? = nil) {
        super.init(frame: .zero)
        setupView()
        titleLabel.text = title
        if let titleFont = titleFont {
            titleLabel.font = titleFont
        }
        self.isBordered = isBordered
        self.rightView = rightView
        setupRightView()
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
        
        containerStackView.addArrangedSubview(titleLabel)
        containerStackView.addArrangedSubview(.horizontalSpacer())
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
    }
    
    private func setupRightView() {
        if let rightView = rightView {
            containerStackView.addArrangedSubview(rightView)
        }
    }
    
    func setRightView(_ view: UIView) {
        rightView?.removeFromSuperview()
        rightView = view
        containerStackView.addArrangedSubview(view)
    }
    
    @objc private func handleTap() {
        onTap?()
    }
}

