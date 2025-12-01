import UIKit
import SnapKit

final class DocumentCell: UIView {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundSecondary
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .accent
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .zalandoSans(.medium, size: isPad ? 20 : 16)
        label.textColor = .textPrimary
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = .zalandoSans(.regular, size: isPad ? 16 : 14)
        label.textColor = .textSecondary
        return label
    }()
    
    private lazy var moreButton: UIButton = {
        let button = UIButton(type: .system)
        let iconSize: CGFloat = isPad ? 22 : 18
        let config = UIImage.SymbolConfiguration(pointSize: iconSize, weight: .medium)
        button.setImage(.moreButton, for: .normal)
        button.tintColor = .iconPrimary
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(containerView)
        containerView.addSubview(iconView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(infoLabel)
        containerView.addSubview(moreButton)
        
        let horizontalInset: CGFloat = isPad ? 20 : 16
        let spacing: CGFloat = isPad ? 16 : 12
        let iconSize: CGFloat = isPad ? 84 : 64
        let buttonSize: CGFloat = isPad ? 32 : 24
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        iconView.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview().inset(horizontalInset)
            $0.width.height.equalTo(iconSize)
        }
        
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(iconView.snp.right).offset(spacing)
            $0.top.equalToSuperview().offset(isPad ? 32 : 24)
            $0.right.equalTo(moreButton.snp.left).offset(-12)
        }
        
        infoLabel.snp.makeConstraints {
            $0.left.equalTo(iconView.snp.right).offset(spacing)
            $0.top.equalTo(titleLabel.snp.bottom).offset(isPad ? 12 : 8)
            $0.right.equalTo(moreButton.snp.left).offset(-12)
        }
        
        moreButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-horizontalInset)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(buttonSize)
        }
    }
    
    func configure(with document: Document) {
        iconView.image = document.fileType.icon
        titleLabel.text = document.title
        infoLabel.text = document.displayInfo
    }
}
