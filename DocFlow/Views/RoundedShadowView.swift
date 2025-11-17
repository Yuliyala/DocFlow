import UIKit
import SnapKit

class RoundedShadowView: UIView {
    private let shadowContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    var contentBackgroundColor: UIColor = .white {
        didSet {
            contentView.backgroundColor = contentBackgroundColor
        }
    }

    var cornerRadius: CGFloat = 0 {
        didSet {
            layoutSubviews()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .clear

        addSubview(shadowContainerView)
        shadowContainerView.addSubview(contentView)

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
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        shadowContainerView.layer.shadowPath = UIBezierPath(roundedRect: shadowContainerView.bounds, cornerRadius: cornerRadius).cgPath

        contentView.layer.cornerRadius = cornerRadius
        contentView.clipsToBounds = true
    }
}

