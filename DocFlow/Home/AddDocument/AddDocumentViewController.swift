import UIKit

final class AddDocumentViewController: UIViewController {
    
    private let addDocumentView = AddDocumentView()
    private var presenter: AddDocumentPresenterProtocol!
    
    weak var delegate: AddDocumentPresenterDelegate?
    
    override func loadView() {
        view = addDocumentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = AddDocumentPresenter(view: self, delegate: delegate)
        addDocumentView.delegate = self
        
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

extension AddDocumentViewController: AddDocumentViewProtocol {
    func dismiss() {
        dismiss(animated: true)
    }
}

