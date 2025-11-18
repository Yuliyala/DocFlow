import UIKit

class CheckedView: UIView {

    private let cellSize: CGFloat = 24.0
    private let borderWidth: CGFloat = 1.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = UIColor.background
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.setLineWidth(borderWidth)
        context.setStrokeColor(UIColor.strokePrimary.cgColor)

        let numberOfHorizontalCells = Int(ceil(rect.width / cellSize))
        let numberOfVerticalCells = Int(ceil(rect.height / cellSize))

        for i in 0...numberOfHorizontalCells {
            let x = CGFloat(i) * cellSize
            context.move(to: CGPoint(x: x, y: 0))
            context.addLine(to: CGPoint(x: x, y: rect.height))
        }

        for i in 0...numberOfVerticalCells {
            let y = CGFloat(i) * cellSize
            context.move(to: CGPoint(x: 0, y: y))
            context.addLine(to: CGPoint(x: rect.width, y: y))
        }

        context.strokePath()
    }
}
