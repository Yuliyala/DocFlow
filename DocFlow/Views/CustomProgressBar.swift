import UIKit

class CustomProgressBar: UIView {

    private let backgroundLayer = CALayer()
    private let progressLayer = CALayer()

    @IBInspectable var progress: CGFloat = 0.0 {
        didSet {
            progress = max(0.0, min(1.0, progress))
            updateProgress()
        }
    }

    @IBInspectable var progressColor: UIColor = .accent {
        didSet {
            progressLayer.backgroundColor = progressColor.cgColor
        }
    }

    @IBInspectable var trackColor: UIColor = .strokePrimary {
        didSet {
            backgroundLayer.backgroundColor = trackColor.cgColor
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            updateCornerRadius()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProgressBar()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupProgressBar()
    }

    private func setupProgressBar() {
        backgroundLayer.backgroundColor = trackColor.cgColor
        layer.addSublayer(backgroundLayer)

        progressLayer.backgroundColor = progressColor.cgColor
        layer.addSublayer(progressLayer)

        updateCornerRadius()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let radius = cornerRadius > 0 ? cornerRadius : bounds.height / 2

        backgroundLayer.frame = bounds
        backgroundLayer.cornerRadius = radius

        let progressWidth = bounds.width * progress
        progressLayer.frame = CGRect(x: 0, y: 0, width: progressWidth, height: bounds.height)
        progressLayer.cornerRadius = radius
    }

    private func updateProgress() {
        DispatchQueue.main.async {
            self.layoutSubviews()
        }
    }

    private func updateCornerRadius() {
        DispatchQueue.main.async {
            self.layoutSubviews()
        }
    }

    func setProgress(_ progress: CGFloat, animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                self.progress = progress
            }
        } else {
            self.progress = progress
        }
    }

    func setProgress(_ progress: CGFloat, duration: TimeInterval, completion: @escaping () -> Void) {
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            self.progress = progress
        }, completion: { _ in
            completion()
        })
    }
}

