import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    
    private let homeView = HomeView()
    private var presenter: HomePresenterProtocol!
    
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        presenter = HomePresenter(view: self)
        homeView.delegate = self
        
        presenter.viewDidLoad()
    }
}

extension HomeViewController: HomeViewDelegate {
    func homeViewDidTapTool(_ tool: PopularTool) {
        presenter.didTapTool(tool)
    }
    
    func homeViewDidTapAllDocuments() {
        presenter.didTapAllDocuments()
    }
    
    func homeViewDidTapFavorites() {
        presenter.didTapFavorites()
    }
    
    func homeViewDidChangeSearchText(_ text: String) {
        presenter.didChangeSearchText(text)
    }
    
    func homeViewDidBeginSearch() {
        presenter.didBeginSearch()
    }
    
    func homeViewDidEndSearch() {
        presenter.didEndSearch()
    }
}

extension HomeViewController: HomeViewProtocol {
    func showEmptyState(_ show: Bool, type: HomeView.EmptyStateType) {
        homeView.showEmptyState(show, type: type)
    }
    
    func showDocuments(_ documents: [Document]) {
        homeView.showDocuments(documents)
    }
    
    func setSearchMode(_ isSearching: Bool) {
        homeView.setSearchMode(isSearching)
    }
    
    func showLoading() {
        
    }
    
    func hideLoading() {
        
    }
}
