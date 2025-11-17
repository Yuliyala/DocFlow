import UIKit
import SnapKit

class TabBarController: UITabBarController {
    
    private let customTabBar = CustomTabBarView()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .accent
        
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
        let plusImage = UIImage(systemName: "plus", withConfiguration: config)
        button.setImage(plusImage, for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        
        button.layer.cornerRadius = 31
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 8
        return button
    }()
    
    private let homeVC = HomeViewController()
    private let settingsVC = SettingsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        setupTabBar()
        setupAddButton()
    }
    
    private func setupTabBar() {
        if #available(iOS 17.0, *) {
            traitOverrides.horizontalSizeClass = .compact
        }
        
        if #available(iOS 18.0, *) {
            setTabBarHidden(true, animated: false)
        } else {
            tabBar.isHidden = true
        }
        
        viewControllers = [homeVC, settingsVC]
    }
    
    private func setupAddButton() {
        view.addSubview(customTabBar)
        view.addSubview(addButton)
        
        customTabBar.delegate = self
        
        customTabBar.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.height.equalTo(62)
            $0.width.equalTo(194)
        }
        
        addButton.snp.makeConstraints {
            $0.width.height.equalTo(62)
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalTo(customTabBar)
        }
        
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    @objc private func addButtonTapped() {
        // TODO: Implement add document functionality
    }
}

extension TabBarController: CustomTabBarViewDelegate {
    func customTabBarView(_ tabBarView: CustomTabBarView, didSelectTabAt index: Int) {
        selectedIndex = index
    }
}