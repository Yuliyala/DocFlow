import UIKit

enum ButtonStyle {
    case contained
    case secondary
    case ghost
}

enum ButtonState {
    case enabled
    case disabled
    case pressed
}

class ActionButton: UIButton {
    
    var buttonStyle: ButtonStyle = .contained {
        didSet {
            updateAppearance()
        }
    }
    
    var buttonState: ButtonState = .enabled {
        didSet {
            updateAppearance()
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            buttonState = isEnabled ? .enabled : .disabled
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    convenience init(style: ButtonStyle, title: String) {
        self.init(frame: .zero)
        self.buttonStyle = style
        setTitle(title, for: .normal)
        setupButton()
    }
    
    private func setupButton() {
        titleLabel?.font = .zalandoSans(.medium, size: 16)
        layer.cornerRadius = 28
        translatesAutoresizingMaskIntoConstraints = false
        updateAppearance()
    }
    
    private func updateAppearance() {
        switch (buttonStyle, buttonState) {
        case (.contained, .enabled):
            backgroundColor = .buttonPrimary
            setTitleColor(.textTertiary, for: .normal)
        case (.contained, .disabled):
            backgroundColor = .buttonDisabled
            setTitleColor(.textSecondary, for: .normal)
        case (.contained, .pressed):
            backgroundColor = .buttonPrimary.withAlphaComponent(0.8)
            setTitleColor(.textTertiary, for: .normal)
            
        case (.secondary, .enabled):
            backgroundColor = .backgroundSecondary
            layer.borderWidth = 1
            layer.borderColor = UIColor.buttonPrimary.cgColor
            setTitleColor(.buttonPrimary, for: .normal)
        case (.secondary, .disabled):
            backgroundColor = .backgroundSecondary
            layer.borderWidth = 1
            layer.borderColor = UIColor.buttonDisabled.cgColor
            setTitleColor(.buttonDisabled, for: .normal)
        case (.secondary, .pressed):
            backgroundColor = .buttonSecondary
            layer.borderWidth = 1
            layer.borderColor = UIColor.buttonPrimary.cgColor
            setTitleColor(.buttonPrimary, for: .normal)
            
        case (.ghost, .enabled):
            backgroundColor = .backgroundSecondary
            layer.borderWidth = 0
            setTitleColor(.buttonPrimary, for: .normal)
        case (.ghost, .disabled):
            backgroundColor = .backgroundSecondary
            layer.borderWidth = 0
            setTitleColor(.buttonDisabled, for: .normal)
        case (.ghost, .pressed):
            backgroundColor = .buttonSecondary
            layer.borderWidth = 0
            setTitleColor(.buttonPrimary, for: .normal)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if isEnabled {
            buttonState = .pressed
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if isEnabled {
            buttonState = .enabled
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        if isEnabled {
            buttonState = .enabled
        }
    }
}

