import UIKit
import SnapKit

protocol HomeViewDelegate: AnyObject {
    func homeViewDidTapTool(_ tool: PopularTool)
    func homeViewDidTapAllDocuments()
    func homeViewDidTapFavorites()
    func homeViewDidChangeSearchText(_ text: String)
    func homeViewDidBeginSearch()
    func homeViewDidEndSearch()
}

class HomeView: UIView {
    weak var delegate: HomeViewDelegate?
    
    private var selectedTab: DocumentTab = .allDocuments
    
    enum DocumentTab {
        case allDocuments
        case favorites
    }
    
    enum EmptyStateType {
        case noDocuments
        case searchNotFound
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("tab.editor", comment: "PDF Editor")
        label.font = .zalandoSans(.semiBold, size: 32)
        label.textColor = .textPrimary
        label.textAlignment = .left
        return label
    }()
    
    private lazy var searchBar: CustomSearchBar = {
        let searchBar = CustomSearchBar()
        searchBar.placeholder = NSLocalizedString("search.placeholder", comment: "Search")
        searchBar.delegate = self
        return searchBar
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alignment = .fill
        return stackView
    }()
    
    private let popularToolsLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("main.popular_tools", comment: "Popular Tools")
        label.font = .zalandoSans(.medium, size: 18)
        label.textColor = .textPrimary
        label.textAlignment = .left
        return label
    }()
    
    private lazy var toolsGridView: UIView = {
        let view = UIView()
        setupToolsGrid(in: view)
        return view
    }()
    
    private let myDocumentsLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("main.my_documents", comment: "My Documents")
        label.font = .zalandoSans(.medium, size: 18)
        label.textColor = .textPrimary
        label.textAlignment = .left
        return label
    }()
    
    private lazy var segmentedControl: CustomSegmentedControl = {
        let items = [
            NSLocalizedString("main.all_documents", comment: "All Documents"),
            NSLocalizedString("main.favorites", comment: "Favorites")
        ]
        let control = CustomSegmentedControl(items: items)
        control.delegate = self
        return control
    }()
    
    private let documentsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        return stackView
    }()
    
    private let emptyStateView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let emptyStateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .files
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .accent
        return imageView
    }()
    
    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("main.no_documents", comment: "No Documents")
        label.font = .zalandoSans(.semiBold, size: isPad ? 24 : 18)
        label.textColor = .textPrimary
        label.textAlignment = .center
        return label
    }()
    
    private lazy var emptyStateDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("main.tap_to_add", comment: "Tap \"+\" to add a document.")
        label.font = .zalandoSans(.regular, size: isPad ? 18 : 14)
        label.textColor = .textSecondary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private var emptyStateLabelTopConstraint: Constraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .backgroundPrimary
        
        addSubview(titleLabel)
        addSubview(searchBar)
        addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        [
            popularToolsLabel,
            toolsGridView,
            myDocumentsLabel,
            segmentedControl,
            documentsStackView,
            emptyStateView
        ].forEach { contentStackView.addArrangedSubview($0) }
        
        contentStackView.setCustomSpacing(16, after: popularToolsLabel)
        contentStackView.setCustomSpacing(4, after: toolsGridView)
        contentStackView.setCustomSpacing(12, after: myDocumentsLabel)
        contentStackView.setCustomSpacing(16, after: segmentedControl)
        
        [emptyStateImageView, emptyStateLabel, emptyStateDescriptionLabel].forEach { emptyStateView.addSubview($0) }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(8)
            $0.left.right.equalToSuperview().inset(16)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(20)
            $0.left.right.bottom.equalToSuperview()
            $0.bottom.equalToSuperview().inset(50)
        }
        
        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        popularToolsLabel.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.left.right.equalToSuperview().inset(16)
        }
        
        toolsGridView.snp.makeConstraints {
            $0.height.equalTo(200)
        }
        
        myDocumentsLabel.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.left.right.equalToSuperview().inset(16)
        }
        
        segmentedControl.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.left.right.equalToSuperview().inset(16)
        }
        
        documentsStackView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
        }
        
        let emptyStateHeight: CGFloat = isPad ? 400 : 300
        let imageWidth: CGFloat = isPad ? 130 : 100
        let imageHeight: CGFloat = isPad ? 117 : 90
        let labelOffset: CGFloat = isPad ? 20 : 16
        let descriptionOffset: CGFloat = isPad ? 6 : 4
        let horizontalInset: CGFloat = isPad ? 48 : 32
        
        emptyStateView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(emptyStateHeight)
        }
        
        emptyStateImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(8)
            $0.width.equalTo(imageWidth)
            $0.height.equalTo(imageHeight)
        }
        
        emptyStateLabel.snp.makeConstraints {
            emptyStateLabelTopConstraint = $0.top.equalTo(emptyStateImageView.snp.bottom).offset(labelOffset).constraint
            $0.left.right.equalToSuperview().inset(horizontalInset)
        }
        
        emptyStateDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(emptyStateLabel.snp.bottom).offset(descriptionOffset)
            $0.left.right.equalToSuperview().inset(horizontalInset)
        }
    }
    
    private func setupToolsGrid(in container: UIView) {
        let tools = PopularTool.allCases
        let columns = 4
        let spacing: CGFloat = 12
        let horizontalInset: CGFloat = 28
        
        for (index, tool) in tools.enumerated() {
            let row = index / columns
            let column = index % columns
            
            let toolView = createToolView(for: tool)
            container.addSubview(toolView)
            
            let totalHorizontalInsets = horizontalInset * 2
            let totalSpacing = CGFloat(columns - 1) * spacing
            let availableWidth = UIScreen.main.bounds.width - totalHorizontalInsets - totalSpacing
            let itemWidth = availableWidth / CGFloat(columns)
            
            toolView.snp.makeConstraints {
                $0.top.equalToSuperview().offset(CGFloat(row) * (84 + spacing))
                $0.left.equalToSuperview().offset(CGFloat(column) * (itemWidth + spacing))
                $0.width.equalTo(itemWidth)
                $0.height.equalTo(84)
            }
        }
    }
    
    private func createToolView(for tool: PopularTool) -> UIView {
        let container = UIView()
        container.tag = PopularTool.allCases.firstIndex(of: tool) ?? 0
        
        let iconContainer = UIView()
        iconContainer.backgroundColor = .backgroundSecondary
        iconContainer.layer.cornerRadius = 12
        
        let iconView = UIImageView(image: tool.icon)
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .accent
        
        let label = UILabel()
        label.text = tool.title
        label.font = .zalandoSans(.regular, size: 12)
        label.textColor = .textPrimary
        label.textAlignment = .center
        label.numberOfLines = 2
        
        container.addSubview(iconContainer)
        iconContainer.addSubview(iconView)
        container.addSubview(label)
        
        iconContainer.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(56)
        }
        
        iconView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        label.snp.makeConstraints {
            $0.top.equalTo(iconContainer.snp.bottom).offset(8)
            $0.left.right.equalToSuperview()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toolTapped(_:)))
        container.addGestureRecognizer(tapGesture)
        container.isUserInteractionEnabled = true
        
        return container
    }
    
    @objc private func toolTapped(_ gesture: UITapGestureRecognizer) {
        guard let view = gesture.view,
              view.tag < PopularTool.allCases.count else { return }
        
        let tool = PopularTool.allCases[view.tag]
        delegate?.homeViewDidTapTool(tool)
    }
    
    func showEmptyState(_ show: Bool, type: EmptyStateType = .noDocuments) {
        emptyStateView.isHidden = !show
        
        guard show else { return }
        
        let labelOffset: CGFloat = isPad ? 20 : 16
        let searchNotFoundOffset: CGFloat = isPad ? 100 : 80
        
        switch type {
        case .noDocuments:
            emptyStateImageView.isHidden = false
            emptyStateImageView.image = .files
            emptyStateLabel.text = NSLocalizedString("main.no_documents", comment: "No Documents")
            emptyStateDescriptionLabel.text = NSLocalizedString("main.tap_to_add", comment: "Tap \"+\" to add a document.")
            emptyStateLabelTopConstraint?.update(offset: labelOffset)
            
        case .searchNotFound:
            emptyStateImageView.isHidden = true
            emptyStateLabel.text = NSLocalizedString("search.no_results", comment: "Documents Not Found")
            emptyStateDescriptionLabel.text = NSLocalizedString("search.no_results_description", comment: "Please check the document title or enter a different title.")
            emptyStateLabelTopConstraint?.update(offset: searchNotFoundOffset)
        }
    }
    
    func setSearchMode(_ isSearching: Bool) {
        titleLabel.isHidden = isSearching
        popularToolsLabel.isHidden = isSearching
        toolsGridView.isHidden = isSearching
        myDocumentsLabel.isHidden = isSearching
        segmentedControl.isHidden = isSearching
    }
    
    func showDocuments(_ documents: [Document]) {
        documentsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        documents.forEach { document in
            let cell = DocumentCell()
            cell.configure(with: document)
            documentsStackView.addArrangedSubview(cell)
        }
        
        documentsStackView.isHidden = documents.isEmpty
    }
    
    func clearSearch() {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}

extension HomeView: CustomSegmentedControlDelegate {
    func customSegmentedControl(_ control: CustomSegmentedControl, didSelectSegmentAt index: Int) {
        clearSearch()
        
        switch index {
        case 0:
            selectedTab = .allDocuments
            delegate?.homeViewDidTapAllDocuments()
        case 1:
            selectedTab = .favorites
            delegate?.homeViewDidTapFavorites()
        default:
            break
        }
    }
}

extension HomeView: CustomSearchBarDelegate {
    func searchBar(_ searchBar: CustomSearchBar, textDidChange searchText: String) {
        delegate?.homeViewDidChangeSearchText(searchText)
    }
    
    func searchBarDidBeginEditing(_ searchBar: CustomSearchBar) {
        delegate?.homeViewDidBeginSearch()
    }
    
    func searchBarDidEndEditing(_ searchBar: CustomSearchBar) {
        delegate?.homeViewDidEndSearch()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: CustomSearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: CustomSearchBar) {
        clearSearch()
        delegate?.homeViewDidChangeSearchText("")
    }
}

