import UIKit

protocol MainViewProtocol: AnyObject {
    func showEmptyState(_ show: Bool)
    func showLoading()
    func hideLoading()
}

protocol MainPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapTool(_ tool: PopularTool)
    func didTapAllDocuments()
    func didTapFavorites()
    func didChangeSearchText(_ text: String)
}

final class MainPresenter {
    
    weak var view: MainViewProtocol?
    
    private var documents: [Any] = []
    private var filteredDocuments: [Any] = []
    private var currentTab: DocumentTab = .allDocuments
    
    enum DocumentTab {
        case allDocuments
        case favorites
    }
    
    init(view: MainViewProtocol) {
        self.view = view
    }
    
    private func loadDocuments() {
        documents = []
        filteredDocuments = documents
        updateViewState()
    }
    
    private func loadFavorites() {
        filteredDocuments = []
        updateViewState()
    }
    
    private func filterDocuments(by searchText: String) {
        if searchText.isEmpty {
            filteredDocuments = documents
        } else {
            filteredDocuments = []
        }
        updateViewState()
    }
    
    private func updateViewState() {
        let isEmpty = filteredDocuments.isEmpty
        view?.showEmptyState(isEmpty)
    }
    
    private func handleToolSelection(_ tool: PopularTool) {
        
    }
}

extension MainPresenter: MainPresenterProtocol {
    
    func viewDidLoad() {
        loadDocuments()
    }
    
    func didTapTool(_ tool: PopularTool) {
        handleToolSelection(tool)
    }
    
    func didTapAllDocuments() {
        currentTab = .allDocuments
        loadDocuments()
    }
    
    func didTapFavorites() {
        currentTab = .favorites
        loadFavorites()
    }
    
    func didChangeSearchText(_ text: String) {
        filterDocuments(by: text)
    }
}
