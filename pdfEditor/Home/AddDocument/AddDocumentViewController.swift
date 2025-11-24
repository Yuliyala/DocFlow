import UIKit

final class AddDocumentViewController: UIViewController {
    
    private let addDocumentView = AddDocumentView()
    private let presenter: AddDocumentPresenterProtocol
    
    init(delegate: AddDocumentModuleDelegate?) {
        let presenter = AddDocumentPresenter(delegate: delegate)
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        presenter.view = self
        addDocumentView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = addDocumentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}

extension AddDocumentViewController: AddDocumentViewDelegate {
    func addDocumentViewDidTapClose() {
        presenter.didTapClose()
    }
    
    func addDocumentViewDidSelectOption(_ option: AddDocumentOption) {
        presenter.didSelectOption(option)
    }
}

extension AddDocumentViewController: AddDocumentPresenterDelegate {
    func dismissAddDocument() {
        dismiss(animated: true)
    }
}

