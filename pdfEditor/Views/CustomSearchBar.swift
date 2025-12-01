import UIKit
import SnapKit

protocol CustomSearchBarDelegate: AnyObject {
    func searchBar(_ searchBar: CustomSearchBar, textDidChange searchText: String)
    func searchBarDidBeginEditing(_ searchBar: CustomSearchBar)
    func searchBarDidEndEditing(_ searchBar: CustomSearchBar)
    func searchBarSearchButtonClicked(_ searchBar: CustomSearchBar)
    func searchBarCancelButtonClicked(_ searchBar: CustomSearchBar)
}

final class CustomSearchBar: UIView {
    
    weak var delegate: CustomSearchBarDelegate?
    
    var placeholder: String = "" {
        didSet {
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [.foregroundColor: UIColor.textSecondary]
            )
        }
    }
    
    var text: String {
        get { textField.text ?? "" }
        set { textField.text = newValue }
    }
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundSecondary
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.strokePrimary.cgColor
        return view
    }()
    
    private let searchIconView: UIImageView = {
        let imageView = UIImageView(image: .search)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.textSecondary
        return imageView
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = .zalandoSans(.regular, size: isPad ? 20 : 16)
        textField.textColor = UIColor.textPrimary
        textField.tintColor = UIColor.accent
        textField.returnKeyType = .search
        textField.clearButtonMode = .never
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var clearButton: UIButton = {
        let button = UIButton(type: .system)
        let iconSize: CGFloat = isPad ? 18 : 14
        let config = UIImage.SymbolConfiguration(pointSize: iconSize, weight: .medium)
        button.setImage(UIImage(systemName: "xmark.circle.fill", withConfiguration: config), for: .normal)
        button.tintColor = UIColor.textSecondary
        button.isHidden = true
        button.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("search.cancel", comment: "Cancel"), for: .normal)
        button.setTitleColor(UIColor.textSecondary, for: .normal)
        button.titleLabel?.font = .zalandoSans(.regular, size: isPad ? 20 : 16)
        button.isHidden = true
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var cancelButtonWidthConstraint: Constraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(containerView)
        containerView.addSubview(searchIconView)
        containerView.addSubview(textField)
        containerView.addSubview(clearButton)
        addSubview(cancelButton)
        
        let iconSize: CGFloat = isPad ? 24 : 20
        let horizontalInset: CGFloat = isPad ? 16 : 12
        let spacing: CGFloat = isPad ? 12 : 8
        
        containerView.snp.makeConstraints {
            $0.top.bottom.left.equalToSuperview()
            $0.right.equalTo(cancelButton.snp.left).offset(-spacing)
        }
        
        searchIconView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(horizontalInset)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(iconSize)
        }
        
        textField.snp.makeConstraints {
            $0.left.equalTo(searchIconView.snp.right).offset(spacing)
            $0.centerY.equalToSuperview()
            $0.right.equalTo(clearButton.snp.left).offset(-spacing)
        }
        
        clearButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-horizontalInset)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(iconSize)
        }
        
        cancelButton.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.centerY.equalToSuperview()
            cancelButtonWidthConstraint = $0.width.equalTo(0).constraint
        }
    }
    
    @objc private func textFieldDidChange() {
        let hasText = !text.isEmpty
        clearButton.isHidden = !hasText
        delegate?.searchBar(self, textDidChange: text)
    }
    
    @objc private func clearButtonTapped() {
        textField.text = ""
        clearButton.isHidden = true
        delegate?.searchBar(self, textDidChange: "")
    }
    
    @objc private func cancelButtonTapped() {
        textField.text = ""
        textField.resignFirstResponder()
        clearButton.isHidden = true
        delegate?.searchBarCancelButtonClicked(self)
    }
    
    private func setFocused(_ focused: Bool, animated: Bool) {
        let duration = animated ? 0.3 : 0
        let cancelButtonWidth: CGFloat = isPad ? 90 : 70
        
        UIView.animate(withDuration: duration) {
            self.containerView.layer.borderColor = focused ? UIColor.accent.cgColor : UIColor.strokePrimary.cgColor
            self.cancelButton.isHidden = !focused
            self.cancelButtonWidthConstraint?.update(offset: focused ? cancelButtonWidth : 0)
            self.layoutIfNeeded()
        }
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }
}

extension CustomSearchBar: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setFocused(true, animated: true)
        delegate?.searchBarDidBeginEditing(self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setFocused(false, animated: true)
        delegate?.searchBarDidEndEditing(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        delegate?.searchBarSearchButtonClicked(self)
        return true
    }
}

