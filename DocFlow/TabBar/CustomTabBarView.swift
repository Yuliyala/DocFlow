import UIKit
import SnapKit

protocol CustomTabBarViewDelegate: AnyObject {
    func customTabBarView(_ tabBarView: CustomTabBarView, didSelectTabAt index: Int)
}

class CustomTabBarView: UIView {
    weak var delegate: CustomTabBarViewDelegate?
    
    private var selectedIndex: Int = 0
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#E8E8E8")
        view.layer.cornerRadius = 31
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.05
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        view.layer.masksToBounds = false
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 0
        return stackView
    }()
    
    private lazy var homeTab = createTab(
        title: NSLocalizedString("tab.health", comment: ""),
        image: .homeIcon,
        index: 0
    )
    
    private lazy var settingsTab = createTab(
        title: NSLocalizedString("tab.settings", comment: ""),
        image: .settingsIcon,
        index: 1
    )
    
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
        
        addSubview(containerView)
        containerView.addSubview(stackView)
        
        [homeTab, settingsTab].forEach { stackView.addArrangedSubview($0) }
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(2)
        }
        
        updateSelection()
    }
    
    private func createTab(title: String, image: UIImage, index: Int) -> UIView {
        let container = UIView()
        container.tag = index
        container.backgroundColor = .clear
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        backgroundView.layer.cornerRadius = 24
        backgroundView.clipsToBounds = true
        backgroundView.tag = 300 + index
        
        let innerStackView = UIStackView()
        innerStackView.axis = .vertical
        innerStackView.alignment = .center
        innerStackView.spacing = 4
        innerStackView.isUserInteractionEnabled = false
        
        let imageView = UIImageView(image: image.withRenderingMode(.alwaysTemplate))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .textSecondary
        imageView.tag = 100 + index
        
        let label = UILabel()
        label.text = title
        label.font = .zalandoSans(.medium, size: 12)
        label.textColor = .textSecondary
        label.textAlignment = .center
        label.tag = 200 + index
        
        innerStackView.addArrangedSubview(imageView)
        innerStackView.addArrangedSubview(label)
        
        container.addSubview(backgroundView)
        backgroundView.addSubview(innerStackView)
        
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(2)
            $0.height.greaterThanOrEqualTo(40)
        }
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        innerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tabTapped(_:)))
        container.addGestureRecognizer(tapGesture)
        container.isUserInteractionEnabled = true
        
        return container
    }
    
    @objc private func tabTapped(_ gesture: UITapGestureRecognizer) {
        guard let view = gesture.view else { return }
        selectTab(at: view.tag)
    }
    
    func selectTab(at index: Int) {
        selectedIndex = index
        updateSelection()
        delegate?.customTabBarView(self, didSelectTabAt: index)
    }
    
    private func updateSelection() {
        [homeTab, settingsTab].forEach { view in
            guard let imageView = view.viewWithTag(100 + view.tag) as? UIImageView,
                  let label = view.viewWithTag(200 + view.tag) as? UILabel,
                  let backgroundView = view.viewWithTag(300 + view.tag) else { return }
            
            let isSelected = view.tag == selectedIndex
            
            imageView.tintColor = isSelected ? .accent : .textSecondary
            label.textColor = isSelected ? .accent : .textSecondary
            backgroundView.backgroundColor = isSelected ? .white : .clear
        }
    }
}
