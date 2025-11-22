import UIKit
import StoreKit

class OnboardingViewController: UIViewController {

    private var coordinator: AppCoordinator? {
        navigationController as? AppCoordinator
    }

    private let onboarding: Onboarding
    private let onboardingView = OnboardingView()

    init(onboarding: Onboarding) {
        self.onboarding = onboarding
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = onboardingView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupActions()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if onboarding == .third, let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            requestReview(in: scene)
        }
    }
    
    private func requestReview(in scene: UIWindowScene) {
        SKStoreReviewController.requestReview(in: scene)
    }

    private func setupView() {
        onboardingView.configure(with: onboarding)
    }

    private func setupActions() {
        onboardingView.continueButton.addTarget(
            self,
            action: #selector(continueButtonTapped(_:)),
            for: .touchUpInside
        )
    }

    @objc private func continueButtonTapped(_ sender: UIButton) {
        animateButton(sender) {
            if let next = self.onboarding.next {
                self.coordinator?.openOnboarding(next)
            } else {
                self.coordinator?.paywallAfterOnboarding()
            }
        }
    }
}
