import UIKit
import SnapKit

class TabBarController: UITabBarController {
    
    private let customTabBar = CustomTabBarView()
    private var bottomSheetTransitioningDelegate: CustomBottomSheetTransitioningDelegate?
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .accent
        
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        let iconSize: CGFloat = isPad ? 32 : 24
        let config = UIImage.SymbolConfiguration(pointSize: iconSize, weight: .medium)
        let plusImage = UIImage(systemName: "plus", withConfiguration: config)
        button.setImage(plusImage, for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        
        let cornerRadius: CGFloat = isPad ? 40 : 31
        button.layer.cornerRadius = cornerRadius
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
        
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        let tabBarHeight: CGFloat = isPad ? 80 : 62
        let tabBarWidth: CGFloat = isPad ? 250 : 194
        let buttonSize: CGFloat = isPad ? 80 : 62
        let horizontalSpacing: CGFloat = isPad ? 24 : 16
        let bottomSpacing: CGFloat = isPad ? 24 : 8
        
        customTabBar.snp.makeConstraints {
            $0.left.equalToSuperview().offset(horizontalSpacing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-bottomSpacing)
            $0.height.equalTo(tabBarHeight)
            $0.width.equalTo(tabBarWidth)
        }
        
        addButton.snp.makeConstraints {
            $0.width.height.equalTo(buttonSize)
            $0.trailing.equalToSuperview().offset(-horizontalSpacing)
            $0.centerY.equalTo(customTabBar)
        }
        
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    @objc private func addButtonTapped() {
        guard presentedViewController == nil else { return }
        
        let addDocumentVC = AddDocumentViewController(delegate: self)
        
        let transitioningDelegate = CustomBottomSheetTransitioningDelegate(heightPercentage: 0.36)
        self.bottomSheetTransitioningDelegate = transitioningDelegate
        
        addDocumentVC.modalPresentationStyle = .custom
        addDocumentVC.transitioningDelegate = transitioningDelegate
        
        present(addDocumentVC, animated: true)
    }
}

extension TabBarController: CustomTabBarViewDelegate {
    func customTabBarView(_ tabBarView: CustomTabBarView, didSelectTabAt index: Int) {
        selectedIndex = index
    }
}

extension TabBarController: AddDocumentModuleDelegate {
    func addDocumentDidSelectGallery() {
        
    }
    
    func addDocumentDidSelectFiles() {
        
    }
    
    func addDocumentDidSelectScan() {
        
    }
}
