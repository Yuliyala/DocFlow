import UIKit

class RadioButton: UIButton {

    private var isCheckedState: Bool = false {
        didSet {
            updateAppearance()
        }
    }

    var isChecked: Bool {
        get { return isCheckedState }
        set {
            isCheckedState = newValue
            sendActions(for: .valueChanged)
        }
    }

    var onStateChanged: ((Bool) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }

    private func setupButton() {
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        updateAppearance()
        adjustsImageWhenHighlighted = false
        adjustsImageWhenDisabled = false
    }

    @objc private func buttonTapped() {
        toggle()
    }

    func toggle() {
        isChecked = !isChecked
        onStateChanged?(isChecked)
    }

    func setChecked(_ checked: Bool, animated: Bool = false) {
        if animated {
            UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.isChecked = checked
            }, completion: nil)
        } else {
            isChecked = checked
        }
    }

    private func updateAppearance() {
        if isCheckedState {
            let image = UIImage(named: "radioButtonCheck")
            setImage(image, for: .normal)
        } else {
            let image = UIImage(named: "radioButton")
            setImage(image, for: .normal)
        }
        
        tintColor = nil

        if superview != nil {
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    self.transform = CGAffineTransform.identity
                }
            }
        }
    }
}

