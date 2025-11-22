import UIKit

class RowInputView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .zalandoSans(.medium, size: 16)
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textField: UITextField = {
        let field = UITextField()
        field.font = .zalandoSans(.regular, size: 16)
        field.textColor = .textPrimary
        field.textAlignment = .right
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let measurementLabel: UILabel = {
        let label = UILabel()
        label.font = .zalandoSans(.regular, size: 16)
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
        return stack
    }()
    
    var text: String {
        get { textField.text ?? "" }
        set { textField.text = newValue }
    }
    
    var placeholder: String {
        get { textField.placeholder ?? "" }
        set { textField.placeholder = newValue }
    }
    
    var keyboardType: UIKeyboardType {
        get { textField.keyboardType }
        set { textField.keyboardType = newValue }
    }
    
    var measurement: String? {
        didSet {
            measurementLabel.text = measurement
            measurementLabel.isHidden = measurement == nil || text.isEmpty
        }
    }
    
    weak var delegate: UITextFieldDelegate? {
        didSet {
            textField.delegate = delegate
        }
    }
    
    init(title: String, placeholder: String = "", measurement: String? = nil, keyboardType: UIKeyboardType = .default) {
        super.init(frame: .zero)
        setupView()
        titleLabel.text = title
        textField.placeholder = placeholder
        self.measurement = measurement
        self.keyboardType = keyboardType
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .backgroundSecondary
        layer.cornerRadius = 20
        layer.borderWidth = 1
        layer.borderColor = UIColor.strokePrimary.cgColor
        
        addSubview(containerStackView)
        
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(measurementLabel)
        
        containerStackView.addArrangedSubview(titleLabel)
        containerStackView.addArrangedSubview(.horizontalSpacer())
        containerStackView.addArrangedSubview(stackView)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange() {
        measurementLabel.isHidden = measurement == nil || text.isEmpty
    }
}

