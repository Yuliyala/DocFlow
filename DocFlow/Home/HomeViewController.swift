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
}

extension HomeViewController: MainViewProtocol {
    func showEmptyState(_ show: Bool) {
        mainView.showEmptyState(show)
    }
    
    func showLoading() {
        
    }
    
    func hideLoading() {
        
    }
}
