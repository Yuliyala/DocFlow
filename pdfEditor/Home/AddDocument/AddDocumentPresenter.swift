import UIKit

protocol AddDocumentPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapClose()
    func didSelectOption(_ option: AddDocumentOption)
}

protocol AddDocumentPresenterDelegate: AnyObject {
    func dismissAddDocument()
}

protocol AddDocumentModuleDelegate: AnyObject {
    func addDocumentDidSelectGallery()
    func addDocumentDidSelectFiles()
    func addDocumentDidSelectScan()
}

final class AddDocumentPresenter {
    
    weak var view: AddDocumentPresenterDelegate?
    let delegate: AddDocumentModuleDelegate?
    
    init(delegate: AddDocumentModuleDelegate?) {
        self.delegate = delegate
    }
}

extension AddDocumentPresenter: AddDocumentPresenterProtocol {
    
    func viewDidLoad() {
        
    }
    
    func didTapClose() {
        view?.dismissAddDocument()
    }
    
    func didSelectOption(_ option: AddDocumentOption) {
        view?.dismissAddDocument()
        
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

