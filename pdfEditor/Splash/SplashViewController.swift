import UIKit
import SnapKit
import ApphudSDK

class SplashViewController: UIViewController {

    private var coordinator: AppCoordinator? {
        navigationController as? AppCoordinator
    }

    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("splash.welcome", comment: "")
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        let fontSize: CGFloat = isPad ? 32 : 24
        label.font = .zalandoSans(.medium, size: fontSize)
        label.textColor = .textPrimary
        label.textAlignment = .center
        return label
    }()
    
    private lazy var appNameLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("splash.app_name", comment: "")
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        let fontSize: CGFloat = isPad ? 52 : 40
        label.font = .zalandoSans(.semiBold, size: fontSize)
        label.textColor = .accent
        label.textAlignment = .center
        return label
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = .splashIcon
        return imageView
    }()
    
    private let progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.progressTintColor = .accent
        progress.trackTintColor = .strokePrimary
        progress.layer.cornerRadius = 2
        progress.clipsToBounds = true
        return progress
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        startLoadingAnimation()
        startIconPulsation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.loadData()
        }
    }
    
    private func startLoadingAnimation() {
        progressView.setProgress(0, animated: false)
        UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseInOut) { [weak self] in
            self?.progressView.setProgress(0.9, animated: true)
        }
    }
    
    private func startIconPulsation() {
        let pulse = CABasicAnimation(keyPath: "transform.scale")
        pulse.duration = 1.0
        pulse.fromValue = 1.0
        pulse.toValue = 1.1
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        pulse.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        logoImageView.layer.add(pulse, forKey: "pulsation")
    }
    
    private func loadData() {
        Task { @MainActor in
            let isConnected = await NetworkStatusService.shared.checkNetworkStatusAsync()
            if !isConnected {
                self.presentNetworkErrorAlert()
                return
            }
            
            await activate()
            await AppHudService.shared.preloadData()
            await FirebaseService.shared.load()
            
            self.progressView.setProgress(1.0, animated: true)
            self.logoImageView.layer.removeAnimation(forKey: "pulsation")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if LocalStorage.shared.isOnboardingShown || AppHudService.shared.hasSubscribed {
                    self.coordinator?.openApp()
                } else {
                    self.coordinator?.openOnboarding()
                }
            }
        }
    }
    
    private func activate() async {
        await withCheckedContinuation { continuation in
            Apphud.start(apiKey: Constants.appHudKey) { _ in
                continuation.resume()
            }
        }
    }
    
    private func presentNetworkErrorAlert() {
        let alertController = UIAlertController(
            title: NSLocalizedString("network.error.title", comment: ""),
            message: NSLocalizedString("network.error.message", comment: ""),
            preferredStyle: .alert
        )
        
        let retryAction = UIAlertAction(title: NSLocalizedString("network.error.ok", comment: ""), style: .default) { _ in
            self.retry()
        }
        alertController.addAction(retryAction)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("network.error.cancel", comment: ""), style: .cancel) { _ in
            self.coordinator?.openApp()
        }
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    private func retry() {
        startLoadingAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.loadData()
        }
    }

    private func setupUI() {
        view.backgroundColor = .backgroundPrimary
        
        view.addSubview(welcomeLabel)
        view.addSubview(appNameLabel)
        view.addSubview(logoImageView)
        view.addSubview(progressView)
    }

    private func setupConstraints() {
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        
        let logoSize: CGFloat = isPad ? 180 : 132
        logoImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(logoSize)
        }
        
        let labelSpacing: CGFloat = isPad ? -34 : -26
        appNameLabel.snp.makeConstraints {
            $0.bottom.equalTo(logoImageView.snp.top).offset(labelSpacing)
            $0.centerX.equalToSuperview()
        }
        
        welcomeLabel.snp.makeConstraints {
            $0.bottom.equalTo(appNameLabel.snp.top).offset(-6)
            $0.centerX.equalToSuperview()
        }
        
        let progressInset: CGFloat = isPad ? 150 : 100
        let progressBottomOffset: CGFloat = isPad ? -100 : -50
        let progressHeight: CGFloat = isPad ? 10 : 8
        
        progressView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(progressInset)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(progressBottomOffset)
            $0.height.equalTo(progressHeight)
        }
    }
}
