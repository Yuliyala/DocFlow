import UIKit

class TextRowsView: UIView {
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var items: [String] = []
    private var onItemTapped: ((Int) -> Void)?
    
    init(items: [String], onItemTapped: @escaping (Int) -> Void) {
        super.init(frame: .zero)
        self.items = items
        self.onItemTapped = onItemTapped
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .backgroundSecondary
        layer.cornerRadius = 20
        layer.borderWidth = 1
        layer.borderColor = UIColor.strokePrimary.cgColor
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        setupRows()
    }
    
    private func setupRows() {
        for (index, item) in items.enumerated() {
            let row = TextRow(title: item)
            row.onTap = { [weak self] in
                self?.onItemTapped?(index)
            }
            stackView.addArrangedSubview(row)
            
            if index < items.count - 1 {
                let separator = UIView()
                separator.backgroundColor = .segmentBackground
                separator.translatesAutoresizingMaskIntoConstraints = false
                stackView.addArrangedSubview(separator)
                NSLayoutConstraint.activate([
                    separator.heightAnchor.constraint(equalToConstant: 1)
                ])
            }
        }
    }
}

