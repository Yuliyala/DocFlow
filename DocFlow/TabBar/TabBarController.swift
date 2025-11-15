import UIKit
import SnapKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundSecondary
        
        // 🔧 ВРЕМЕННО для тестирования дизайна - удалить потом!
        addTestButtons()
    }
    
    // 🔧 ВРЕМЕННАЯ функция для быстрого доступа к paywalls
    private func addTestButtons() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        
        let trialButton = UIButton(type: .system)
        trialButton.setTitle("🎨 Trial Paywall (WITH Trial)", for: .normal)
        trialButton.backgroundColor = .accent
        trialButton.setTitleColor(.white, for: .normal)
        trialButton.layer.cornerRadius = 12
        trialButton.titleLabel?.font = .zalandoSans(.medium, size: 16)
        trialButton.addTarget(self, action: #selector(showTrialPaywallWithTrial), for: .touchUpInside)
        
        let noTrialButton = UIButton(type: .system)
        noTrialButton.setTitle("🎨 Trial Paywall (NO Trial)", for: .normal)
        noTrialButton.backgroundColor = UIColor(hex: "#8E4348")
        noTrialButton.setTitleColor(.white, for: .normal)
        noTrialButton.layer.cornerRadius = 12
        noTrialButton.titleLabel?.font = .zalandoSans(.medium, size: 16)
        noTrialButton.addTarget(self, action: #selector(showTrialPaywallNoTrial), for: .touchUpInside)
        
        let onboardingButton = UIButton(type: .system)
        onboardingButton.setTitle("🎨 Onboarding Paywall", for: .normal)
        onboardingButton.backgroundColor = .accentSecondary
        onboardingButton.setTitleColor(.white, for: .normal)
        onboardingButton.layer.cornerRadius = 12
        onboardingButton.titleLabel?.font = .zalandoSans(.medium, size: 16)
        onboardingButton.addTarget(self, action: #selector(showOnboardingPaywall), for: .touchUpInside)
        
        stackView.addArrangedSubview(trialButton)
        stackView.addArrangedSubview(noTrialButton)
        stackView.addArrangedSubview(onboardingButton)
        
        view.addSubview(stackView)
        
        trialButton.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        
        noTrialButton.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        
        onboardingButton.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.right.equalToSuperview().inset(32)
        }
    }
    
    @objc private func showTrialPaywallWithTrial() {
        let trialVC = TrialViewController()
        trialVC.forceTrialMode = true // 🔧 ВРЕМЕННО: принудительно включаем trial
        trialVC.modalPresentationStyle = .fullScreen
        present(trialVC, animated: true)
    }
    
    @objc private func showTrialPaywallNoTrial() {
        let trialVC = TrialViewController()
        trialVC.forceTrialMode = false // 🔧 ВРЕМЕННО: принудительно выключаем trial
        trialVC.modalPresentationStyle = .fullScreen
        present(trialVC, animated: true)
    }
    
    @objc private func showOnboardingPaywall() {
        let onboardingPaywallVC = OnboardingPaywallViewController()
        onboardingPaywallVC.modalPresentationStyle = .fullScreen
        present(onboardingPaywallVC, animated: true)
    }
}

