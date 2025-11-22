import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    
    private let mainView = MainView()
    private var presenter: MainPresenterProtocol!
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        presenter = MainPresenter(view: self)
        mainView.delegate = self
        
        presenter.viewDidLoad()
    }
}

extension HomeViewController: MainViewDelegate {
    func mainViewDidTapTool(_ tool: PopularTool) {
        presenter.didTapTool(tool)
    }
    
    func mainViewDidTapAllDocuments() {
        presenter.didTapAllDocuments()
    }
    
    func mainViewDidTapFavorites() {
        presenter.didTapFavorites()
    }
    
    func mainViewDidChangeSearchText(_ text: String) {
        presenter.didChangeSearchText(text)
    }
    
    func mainViewDidBeginSearch() {
        presenter.didBeginSearch()
    }
    
    func mainViewDidEndSearch() {
        presenter.didEndSearch()
    }
}

extension HomeViewController: MainViewProtocol {
    func showEmptyState(_ show: Bool, type: MainView.EmptyStateType) {
        mainView.showEmptyState(show, type: type)
    }
    
    func showDocuments(_ documents: [Document]) {
        mainView.showDocuments(documents)
    }
    
    func setSearchMode(_ isSearching: Bool) {
        mainView.setSearchMode(isSearching)
    }
    
    func showLoading() {
        
    }
    
    func hideLoading() {
        
    }
}
