import UIKit
import SnapKit

class LimitedBanner: UIView {
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .settingBanner
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let rightImage = UIImageView(image: .filesIcon)
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 10
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        let fontSize: CGFloat = isPad ? 32 : 24
        label.font = .zalandoSans(.medium, size: fontSize)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = NSLocalizedString("settings.banner.title", comment: "")
        return label
    }()
    
    lazy var rowEdit = row(
        text: NSLocalizedString("settings.banner.edit", comment: "")
    )
    
    lazy var rowConvert = row(
        text: NSLocalizedString("settings.banner.convert", comment: "")
    )
    
    lazy var rowScan = row(
        text: NSLocalizedString("settings.banner.scan", comment: "")
    )
    
    let ctaButton: UIButton = {
        let button = PrimaryButton()
        button.backgroundColor = .white
        button.setTitle(NSLocalizedString("settings.banner.button", comment: ""), for: .normal)
        button.setTitleColor(.accent, for: .normal)
        button.isUserInteractionEnabled = false
        return button
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
        clipsToBounds = true
        layer.cornerRadius = 24
        backgroundColor = .accent
        [backgroundImageView, rightImage, stackView].forEach(addSubview(_:))
        [
            titleLabel,
            rowEdit,
            rowConvert,
            rowScan,
            ctaButton
        ].forEach(stackView.addArrangedSubview(_:))
        
        stackView.setCustomSpacing(8, after: titleLabel)
        stackView.setCustomSpacing(6, after: rowEdit)
        stackView.setCustomSpacing(6, after: rowConvert)
        stackView.setCustomSpacing(16, after: rowScan)
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let buttonHeight: CGFloat = isPad ? 60 : 48
        let buttonWidth: CGFloat = isPad ? 280 : 210
        let imageHeight: CGFloat = isPad ? 150 : 110
        let imageTopOffset: CGFloat = isPad ? 60 : 46
        
        ctaButton.snp.makeConstraints {
            $0.height.equalTo(buttonHeight)
            $0.width.equalTo(buttonWidth)
            $0.left.equalToSuperview().offset(16)
        }
        
        rightImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(imageTopOffset)
            $0.trailing.equalToSuperview().offset(-8)
            $0.height.equalTo(imageHeight)
        }
    }
    
    private func row(text: String) -> UIStackView {
        let view = UIStackView()
        let imageView = UIImageView(image: .checkmarkBadge)
        imageView.contentMode = .scaleAspectFit
        let label = UILabel()
        let fontSize: CGFloat = isPad ? 18 : 14
        label.font = .zalandoSans(.regular, size: fontSize)
        label.textColor = .white
        label.numberOfLines = 1
        label.text = text
        view.axis = .horizontal
        view.spacing = isPad ? 12 : 8
        view.alignment = .center
        let iconSize: CGFloat = isPad ? 24 : 18
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(iconSize)
        }
        [imageView, label].forEach(view.addArrangedSubview(_:))
        return view
    }
}
