import UIKit

final class PrimaryButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        backgroundColor = UIColor.accent
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .zalandoSans(.medium, size: 16)
        layer.cornerRadius = isSmallScreen ? 12 : 16
        clipsToBounds = true
    }
}

