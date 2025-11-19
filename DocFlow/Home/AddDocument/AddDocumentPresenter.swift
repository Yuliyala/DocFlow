import UIKit

protocol AddDocumentViewProtocol: AnyObject {
    func dismiss()
}

protocol AddDocumentPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapClose()
    func didSelectOption(_ option: AddDocumentOption)
}

protocol AddDocumentPresenterDelegate: AnyObject {
    func addDocumentDidSelectGallery()
    func addDocumentDidSelectFiles()
    func addDocumentDidSelectScan()
}

final class AddDocumentPresenter {
    
    weak var view: AddDocumentViewProtocol?
    weak var delegate: AddDocumentPresenterDelegate?
    
    init(view: AddDocumentViewProtocol, delegate: AddDocumentPresenterDelegate?) {
        self.view = view
        self.delegate = delegate
    }
}

extension AddDocumentPresenter: AddDocumentPresenterProtocol {
    
    func viewDidLoad() {
        
    }
    
    func didTapClose() {
        view?.dismiss()
    }
    
    func didSelectOption(_ option: AddDocumentOption) {
        view?.dismiss()
        
        switch option {
        case .gallery:
            delegate?.addDocumentDidSelectGallery()
        case .files:
            delegate?.addDocumentDidSelectFiles()
        case .scan:
            delegate?.addDocumentDidSelectScan()
        }
    }
}

