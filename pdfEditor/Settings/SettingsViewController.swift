import UIKit

class SettingsViewController: UIViewController {
    private let settingsView = SettingsView()
    
    override func loadView() {
        view = settingsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        settingsView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // TODO: Скрыть баннер и restore если есть подписка
        // settingsView.limitedBanner.isHidden = AppHudService.shared.hasSubscribed
        // settingsView.optionViews[0].isHidden = AppHudService.shared.hasSubscribed
    }
}

extension SettingsViewController: SettingsViewDelegate {
    func settingsViewDidSelectOption(_ option: SettingsOption) {
        switch option {
        case .restore:
            handleRestorePurchases()
        case .share:
            handleShareApp()
        case .privacy:
            handlePrivacyPolicy()
        case .terms:
            handleTermsOfUse()
        case .contact:
            handleContactUs()
        }
    }
    
    func settingsViewDidTapBanner() {
        let limitedVC = LimitedViewController()
        limitedVC.modalPresentationStyle = .fullScreen
        present(limitedVC, animated: true)
    }
    
    private func handleRestorePurchases() {
        // TODO: Восстановить покупки через AppHudService
        showAlert(title: "Restore", message: "Покупки восстановлены (заглушка)")
    }

    private func handleShareApp() {
        guard let url = URL(string: "https://apps.apple.com/app/id\(Constants.appId)") else { return }
        let activityVC = UIActivityViewController(
            activityItems: [url],
            applicationActivities: nil
        )
        activityVC.popoverPresentationController?.sourceView = view
        present(activityVC, animated: true)
    }

    private func handlePrivacyPolicy() {
        guard let url = Constants.privacyPolicyURL else { return }
        openURL(url)
    }

    private func handleTermsOfUse() {
        guard let url = Constants.termsOfServiceURL else { return }
        openURL(url)
    }

    private func handleContactUs() {
        MailService.openMailApp()
    }
    
    private func openURL(_ url: URL) {
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
