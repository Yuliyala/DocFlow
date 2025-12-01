import UIKit

final class GradientBlurView: UIView {
    
    private let blurView: TSBlurEffectView = {
        let blurView = TSBlurEffectView()
        return blurView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .clear
        addSubview(blurView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blurView.frame = bounds
    }
}


final class TSBlurEffectView: UIVisualEffectView {
    
    private var animator = UIViewPropertyAnimator(duration: 1, curve: .linear)
    
    var intensity: CGFloat = 1.0 {
        didSet {
            setupBlur()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        frame = superview?.bounds ?? .zero
        setupBlur()
    }
    
    override func didMoveToSuperview() {
        guard superview != nil else { return }
        backgroundColor = .clear
        setupBlur()
    }
    
    private func setupBlur() {
        animator.stopAnimation(true)
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear)
        effect = nil
        
        animator.addAnimations { [weak self] in
            self?.effect = UIBlurEffect(style: .regular)
        }
        
        if intensity > 0 && intensity <= 10 {
            animator.fractionComplete = intensity / 10
        } else {
            animator.fractionComplete = 0.05
        }
    }
    
    deinit {
        animator.stopAnimation(true)
    }
}

