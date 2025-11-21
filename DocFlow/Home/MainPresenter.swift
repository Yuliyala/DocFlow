import UIKit

protocol MainViewProtocol: AnyObject {
    func showEmptyState(_ show: Bool, type: MainView.EmptyStateType)
    func showDocuments(_ documents: [Document])
    func setSearchMode(_ isSearching: Bool)
    func showLoading()
    func hideLoading()
}

protocol MainPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapTool(_ tool: PopularTool)
    func didTapAllDocuments()
    func didTapFavorites()
    func didChangeSearchText(_ text: String)
    func didBeginSearch()
    func didEndSearch()
}

final class MainPresenter {
    
    weak var view: MainViewProtocol?
    
    private var documents: [Document] = []
    private var filteredDocuments: [Document] = []
    private var currentTab: DocumentTab = .allDocuments
    private var currentSearchText: String = ""
    private var isSearching: Bool = false
    
    enum DocumentTab {
        case allDocuments
        case favorites
    }
    
    init(view: MainViewProtocol) {
        self.view = view
    }
    
    private func loadDocuments() {
        currentSearchText = ""
        documents = Document.mockDocuments
        filteredDocuments = documents
        updateViewState()
    }
    
    private func loadFavorites() {
        currentSearchText = ""
        filteredDocuments = documents.filter { $0.isFavorite }
        updateViewState()
    }
    
    private func filterDocuments(by searchText: String) {
        currentSearchText = searchText
        
        if searchText.isEmpty {
            filteredDocuments = currentTab == .favorites ? documents.filter { $0.isFavorite } : documents
        } else {
            let allDocs = currentTab == .favorites ? documents.filter { $0.isFavorite } : documents
            filteredDocuments = allDocs.filter { document in
                document.title.lowercased().contains(searchText.lowercased())
            }
        }
        updateViewState()
    }
    
    private func updateViewState() {
        let isEmpty = filteredDocuments.isEmpty
        
        if isSearching && currentSearchText.isEmpty {
            view?.showEmptyState(false, type: .noDocuments)
            view?.showDocuments([])
        } else if isEmpty {
            let emptyStateType: MainView.EmptyStateType = currentSearchText.isEmpty ? .noDocuments : .searchNotFound
            view?.showEmptyState(true, type: emptyStateType)
            view?.showDocuments([])
        } else {
            view?.showEmptyState(false, type: .noDocuments)
            view?.showDocuments(filteredDocuments)
        }
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
    
    func didBeginSearch() {
        isSearching = true
        view?.setSearchMode(true)
        updateViewState()
    }
    
    func didEndSearch() {
        isSearching = false
        view?.setSearchMode(false)
        
        if currentTab == .favorites {
            loadFavorites()
        } else {
            loadDocuments()
        }
    }
}
