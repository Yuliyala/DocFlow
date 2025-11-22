import UIKit
import SnapKit

class CapsuledLabel: UIView {

    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()

    var text: String? {
        get { return label.text }
        set { label.text = newValue }
    }

    var font: UIFont? {
        get { return label.font }
        set { label.font = newValue }
    }

    var textColor: UIColor? {
        get { return label.textColor }
        set { label.textColor = newValue }
    }

    var insets: UIEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8) {
        didSet {
            setConstraints()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    convenience init(insets: UIEdgeInsets) {
        self.init(frame: .zero)
        self.insets = insets
        setConstraints()
    }

    private func setupView() {
        addSubview(label)
        setConstraints()
        backgroundColor = .backgroundTertiary
        clipsToBounds = true
    }

    private func setConstraints() {
        label.snp.remakeConstraints {
            $0.top.equalToSuperview().offset(insets.top)
            $0.bottom.equalToSuperview().offset(-insets.bottom)
            $0.leading.equalToSuperview().offset(insets.left)
            $0.trailing.equalToSuperview().offset(-insets.right)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        clipsToBounds = true
    }
}

