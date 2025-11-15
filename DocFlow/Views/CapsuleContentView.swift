import UIKit
import SnapKit

class CapsuleContentView: UIView {

    private let shadowContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundSecondary
        return view
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = spacing
        stackView.layoutMargins = contentInsets
        return stackView
    }()

    var contentBackgroundColor: UIColor = .backgroundSecondary {
        didSet {
            contentView.backgroundColor = contentBackgroundColor
        }
    }

    var spacing: CGFloat = 8 {
        didSet {
            contentStackView.spacing = spacing
        }
    }

    var contentInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12) {
        didSet {
            contentStackView.layoutMargins = contentInsets
        }
    }
    
    var customCornerRadius: CGFloat? = nil {
        didSet {
            setNeedsLayout()
        }
    }

    init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    func setContent(_ content: [UIView]) {
        contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        content.forEach { contentStackView.addArrangedSubview($0) }
    }

    private func setupView() {
        backgroundColor = .clear
        addSubview(shadowContainerView)
        shadowContainerView.addSubview(contentView)
        contentView.addSubview(contentStackView)
        setupShadow()
        setupConstraints()
    }

    private func setupShadow() {
        shadowContainerView.layer.shadowColor = UIColor.black.cgColor
        shadowContainerView.layer.shadowOpacity = 0.1
        shadowContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadowContainerView.layer.shadowRadius = 4
        shadowContainerView.layer.masksToBounds = false
    }

    private func setupConstraints() {
        shadowContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let cornerRadius = customCornerRadius ?? 10
        shadowContainerView.layer.shadowPath = UIBezierPath(roundedRect: shadowContainerView.bounds, cornerRadius: cornerRadius).cgPath
        contentView.layer.cornerRadius = cornerRadius
        contentView.clipsToBounds = true
    }

    static func createSecurityCapsule() -> CapsuleContentView {
        let capsule = CapsuleContentView()

        let lockImageView = UIImageView()
        lockImageView.image = .lock
        lockImageView.tintColor = .accent
        lockImageView.contentMode = .scaleAspectFit

        let securityLabel = UILabel()
        securityLabel.text = NSLocalizedString("security.full_message", comment: "security.full_message")
        securityLabel.font = .zalandoSans(.regular, size: 12)
        securityLabel.textColor = .accent
        securityLabel.numberOfLines = 1

        lockImageView.snp.makeConstraints {
            $0.width.height.equalTo(18)
        }

        capsule.setContent([lockImageView, securityLabel])
        return capsule
    }
}

