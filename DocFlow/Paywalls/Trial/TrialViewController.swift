import UIKit
import SafariServices

final class TrialViewController: UIViewController {
    
    private let rootView = TrialView()
    private var presenter: TrialPresenterProtocol!
    
    var forceTrialMode: Bool?

    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPresenter()
        setupDelegates()
        presenter.viewDidLoad()
    }
    
    private func setupPresenter() {
        let presenterImpl = TrialPresenter(view: self)
        presenterImpl.forceTrialMode = forceTrialMode
        presenter = presenterImpl
    }
    
    private func setupDelegates() {
        rootView.delegate = self
        rootView.paywallSelectorView.delegate = self
        rootView.termsTextView.termsDelegate = self
    }
}

extension TrialViewController: TrialViewProtocol {
    
    func configureWeekProduct(infoText: String?, title: String, description: NSAttributedString) {
        rootView.paywallSelectorView.weeklySelector.configure(
            infoText: infoText,
            title: title,
            description: description
        )
    }
    
    func configureMonthProduct(infoText: String?, title: String, description: NSAttributedString) {
        rootView.paywallSelectorView.monthlySelector.configure(
            infoText: infoText,
            title: title,
            description: description
        )
    }
    
    func updateContinueButton(title: String) {
        rootView.continueButton.setTitle(title, for: .normal)
    }
    
    func showLoading() {
        rootView.continueButton.isEnabled = false
    }
    
    func hideLoading() {
        rootView.continueButton.isEnabled = true
    }
    
    func dismissView() {
        dismiss(animated: true)
    }
}

extension TrialViewController: TrialViewDelegate {
    
    func trialViewDidTapRestore() {
        presenter.didTapRestore()
    }

    func trialViewDidTapClose() {
        presenter.didTapClose()
    }
    
    func continueTapped() {
        presenter.didTapContinue()
    }
}

extension TrialViewController: PaywallSelectorViewDelegate {
    
    func paywallSelectorView(_ selectorView: PaywallSelectorView, didSelectIndex index: Int) {
        presenter.didSelectProduct(at: index)
    }
}

extension TrialViewController: TermsTextViewDelegate {
    
    func didTapTermsOfService() {
        guard let url = Constants.termsOfServiceURL else { return }
        openInSafari(url: url)
    }
    
    func didTapPrivacyPolicy() {
        guard let url = Constants.privacyPolicyURL else { return }
        openInSafari(url: url)
    }
    
    private func openInSafari(url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = UIColor.accent
        safariVC.modalPresentationStyle = .pageSheet
        present(safariVC, animated: true)
    }
}
