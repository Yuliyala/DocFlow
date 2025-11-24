import UIKit

protocol AddDocumentPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapClose()
    func didSelectOption(_ option: AddDocumentOption)
}

protocol AddDocumentPresenterDelegate: AnyObject {
    func addDocumentDidDismiss()
    func addDocumentDidSelectGallery()
    func addDocumentDidSelectFiles()
    func addDocumentDidSelectScan()
}

final class AddDocumentPresenter {
    
    weak var delegate: AddDocumentPresenterDelegate?
    
    init(delegate: AddDocumentPresenterDelegate?) {
        self.delegate = delegate
    }
}

extension AddDocumentPresenter: AddDocumentPresenterProtocol {
    
    func viewDidLoad() {
        
    }
    
    func didTapClose() {
        delegate?.addDocumentDidDismiss()
    }
    
    func didSelectOption(_ option: AddDocumentOption) {
        switch option {
        case .gallery:
            delegate?.addDocumentDidSelectGallery()
        case .files:
            delegate?.addDocumentDidSelectFiles()
        case .scan:
            delegate?.addDocumentDidSelectScan()
        }
        
        delegate?.addDocumentDidDismiss()
    }
}

