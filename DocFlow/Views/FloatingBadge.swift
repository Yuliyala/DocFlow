import UIKit

/// Круглый badge с иконкой (используется в онбординге)
class FloatingBadge: UIView {
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init(icon: UIImage?, backgroundColor: UIColor = .accent, size: CGFloat = 64) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = size / 2
        self.clipsToBounds = true
        
        iconImageView.image = icon
        setupUI(size: size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(size: CGFloat) {
        addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: size),
            heightAnchor.constraint(equalToConstant: size),
            
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: size * 0.5),
            iconImageView.heightAnchor.constraint(equalToConstant: size * 0.5)
        ])
    }
}


