import UIKit
import SnapKit

final class AddDocumentOptionCard: UIView {
    
    private(set) var option: AddDocumentOption
    private let isFullWidth: Bool
    
    private enum Layout {
        static let cornerRadius: CGFloat = 24
        static let iconSize: CGFloat = 32
        static let horizontalPadding: CGFloat = 16
        static let iconTitleSpacing: CGFloat = 12
        static let topPadding: CGFloat = 20
        static let arrowWidth: CGFloat = 8
        static let arrowHeight: CGFloat = 14
    }
    
    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.accent
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .zalandoSans(.medium, size: 16)
        label.textColor = UIColor.textPrimary
        return label
    }()
    
    private let arrowView: UIImageView = {
        let imageView = UIImageView(image: .arrowRight)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.textSecondary
        return imageView
    }()
    
    init(option: AddDocumentOption, fullWidth: Bool = false) {
        self.option = option
        self.isFullWidth = fullWidth
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor.white
        layer.cornerRadius = Layout.cornerRadius
        
        iconView.image = option.icon
        titleLabel.text = option.title
        
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(arrowView)
        
        if isFullWidth {
            setupFullWidthLayout()
        } else {
            setupCompactLayout()
        }
    }
    
    private func setupFullWidthLayout() {
        iconView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(Layout.horizontalPadding)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(Layout.iconSize)
        }
        
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(iconView.snp.right).offset(Layout.iconTitleSpacing)
            $0.centerY.equalToSuperview()
        }
        
        setupArrowConstraints(verticalAlignment: .center)
    }
    
    private func setupCompactLayout() {
        iconView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Layout.topPadding)
            $0.left.equalToSuperview().offset(Layout.horizontalPadding)
            $0.width.height.equalTo(Layout.iconSize)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(iconView.snp.bottom).offset(Layout.iconTitleSpacing)
            $0.left.equalToSuperview().offset(Layout.horizontalPadding)
            $0.right.equalToSuperview().offset(-Layout.horizontalPadding)
        }
        
        setupArrowConstraints(verticalAlignment: .top)
    }
    
    private func setupArrowConstraints(verticalAlignment: VerticalAlignment) {
        arrowView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-Layout.horizontalPadding)
            make.width.equalTo(Layout.arrowWidth)
            make.height.equalTo(Layout.arrowHeight)
            
            switch verticalAlignment {
            case .center:
                make.centerY.equalToSuperview()
            case .top:
                make.top.equalToSuperview().offset(Layout.topPadding)
            }
        }
    }
    
    private enum VerticalAlignment {
        case center
        case top
    }
}

