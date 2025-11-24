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
        
        presenter = AddDocumentPresenter(delegate: self)
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

extension AddDocumentViewController: AddDocumentPresenterDelegate {
    func addDocumentDidDismiss() {
        dismiss(animated: true)
    }
    
    func addDocumentDidSelectGallery() {
        delegate?.addDocumentDidSelectGallery()
    }
    
    func addDocumentDidSelectFiles() {
        delegate?.addDocumentDidSelectFiles()
    }
    
    func addDocumentDidSelectScan() {
        delegate?.addDocumentDidSelectScan()
    }
}

