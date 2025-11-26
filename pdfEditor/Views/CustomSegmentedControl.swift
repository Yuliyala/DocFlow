import UIKit
import SnapKit

protocol CustomSegmentedControlDelegate: AnyObject {
    func customSegmentedControl(_ control: CustomSegmentedControl, didSelectSegmentAt index: Int)
}

final class CustomSegmentedControl: UIView {
    
    weak var delegate: CustomSegmentedControlDelegate?
    
    private(set) var selectedSegmentIndex: Int = 0
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundTertiary
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    private let segmentButtons: [UIButton]
    private let titles: [String]
    
    init(items: [String]) {
        self.titles = items
        self.segmentButtons = items.enumerated().map { index, title in
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = .zalandoSans(.medium, size: 16)
            button.layer.cornerRadius = 12
            button.tag = index
            return button
        }
        
        super.init(frame: .zero)
        setupView()
        updateSegmentAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(containerView)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let stackView = UIStackView(arrangedSubviews: segmentButtons)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        
        containerView.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
        }
        
        segmentButtons.forEach { button in
            button.addTarget(self, action: #selector(segmentTapped(_:)), for: .touchUpInside)
        }
    }
    
    @objc private func segmentTapped(_ sender: UIButton) {
        let newIndex = sender.tag
        guard newIndex != selectedSegmentIndex else { return }
        
        selectedSegmentIndex = newIndex
        updateSegmentAppearance()
        delegate?.customSegmentedControl(self, didSelectSegmentAt: newIndex)
    }
    
    private func updateSegmentAppearance() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
            self.segmentButtons.enumerated().forEach { index, button in
                let isSelected = index == self.selectedSegmentIndex
                button.backgroundColor = isSelected ? .white : .clear
                button.setTitleColor(UIColor.textPrimary, for: .normal)
            }
        }
    }
    
    func setSelectedSegmentIndex(_ index: Int, animated: Bool = false) {
        guard index >= 0, index < segmentButtons.count, index != selectedSegmentIndex else { return }
        
        selectedSegmentIndex = index
        
        if animated {
            updateSegmentAppearance()
        } else {
            UIView.performWithoutAnimation {
                segmentButtons.enumerated().forEach { idx, button in
                    let isSelected = idx == selectedSegmentIndex
                    button.backgroundColor = isSelected ? .white : .clear
                    button.setTitleColor(UIColor.textPrimary, for: .normal)
                }
            }
        }
    }
}

