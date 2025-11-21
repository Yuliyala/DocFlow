import UIKit
import SnapKit

final class DocumentCell: UIView {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.secondary
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.accent
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .zalandoSans(.medium, size: isPad ? 20 : 16)
        label.textColor = UIColor.textPrimary
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = .zalandoSans(.regular, size: isPad ? 15 : 12)
        label.textColor = UIColor.textSecondary
        return label
    }()
    
    private lazy var moreButton: UIButton = {
        let button = UIButton(type: .system)
        let iconSize: CGFloat = isPad ? 22 : 18
        let config = UIImage.SymbolConfiguration(pointSize: iconSize, weight: .medium)
        button.setImage(UIImage(systemName: "ellipsis", withConfiguration: config), for: .normal)
        button.tintColor = UIColor.textSecondary
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
        
        let cellHeight: CGFloat = isPad ? 110 : 88
        let horizontalInset: CGFloat = isPad ? 20 : 16
        let spacing: CGFloat = isPad ? 16 : 12
        let verticalInset: CGFloat = isPad ? 20 : 16
        let iconWidth: CGFloat = isPad ? 60 : 48
        let iconHeight: CGFloat = isPad ? 70 : 56
        let buttonSize: CGFloat = isPad ? 32 : 24
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(cellHeight)
        }
        
        iconView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(horizontalInset)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(iconWidth)
            $0.height.equalTo(iconHeight)
        }
        
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(iconView.snp.right).offset(spacing)
            $0.top.equalToSuperview().offset(verticalInset)
            $0.right.equalTo(moreButton.snp.left).offset(-8)
        }
        
        infoLabel.snp.makeConstraints {
            $0.left.equalTo(iconView.snp.right).offset(spacing)
            $0.top.equalTo(titleLabel.snp.bottom).offset(isPad ? 6 : 4)
            $0.right.equalTo(moreButton.snp.left).offset(-8)
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
