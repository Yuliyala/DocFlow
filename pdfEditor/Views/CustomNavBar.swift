import UIKit
import SnapKit

class CustomNavBar: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .zalandoSans(.semiBold, size: 32)
        label.textColor = UIColor.textPrimary
        label.textAlignment = .left
        return label
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = NSLocalizedString("search.placeholder", comment: "")
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor.background
        addSubview(titleLabel)
        addSubview(searchBar)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(8)
            $0.left.right.equalToSuperview().inset(16)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().offset(-8)
        }
        
        self.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(60)
        }
    }
    
    func set(title: String) {
        titleLabel.text = title
    }
    
    func set(searchHidden: Bool) {
        searchBar.isHidden = searchHidden
        
        if searchHidden {
            searchBar.snp.removeConstraints()
            titleLabel.snp.remakeConstraints {
                $0.top.equalTo(safeAreaLayoutGuide).offset(8)
                $0.left.right.equalToSuperview().inset(16)
                $0.bottom.equalToSuperview().offset(-8)
            }
        } else {
            titleLabel.snp.remakeConstraints {
                $0.top.equalTo(safeAreaLayoutGuide).offset(8)
                $0.left.right.equalToSuperview().inset(16)
            }
            searchBar.snp.remakeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(8)
                $0.left.right.equalToSuperview().inset(8)
                $0.bottom.equalToSuperview().offset(-8)
            }
        }
    }
}

