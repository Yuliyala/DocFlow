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
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        let fontSize: CGFloat = isPad ? 20 : 16
        titleLabel?.font = .zalandoSans(.medium, size: fontSize)
        layer.cornerRadius = isPad ? 20 : 16
        translatesAutoresizingMaskIntoConstraints = false
        updateAppearance()
    }
    
    private func updateAppearance() {
        switch (buttonStyle, buttonState) {
        case (.contained, .enabled):
            backgroundColor = .accent
            setTitleColor(.white, for: .normal)
        case (.contained, .disabled):
            backgroundColor = .buttonDisabled
            setTitleColor(.textSecondary, for: .normal)
        case (.contained, .pressed):
            backgroundColor = .accent
            setTitleColor(.white, for: .normal)
            
        case (.secondary, .enabled):
            backgroundColor = .buttonSecondary
            setTitleColor(.accent, for: .normal)
        case (.secondary, .disabled):
            backgroundColor = .buttonDisabled
            setTitleColor(.textSecondary, for: .normal)
        case (.secondary, .pressed):
            backgroundColor = .buttonSecondary
            setTitleColor(.accent, for: .normal)
            
        case (.ghost, .enabled):
            setTitleColor(.accent, for: .normal)
        case (.ghost, .disabled):
            setTitleColor(.textSecondary, for: .normal)
        case (.ghost, .pressed):
            setTitleColor(.textSecondary, for: .normal)
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

