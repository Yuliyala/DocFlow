import UIKit

func animateButton(_ button: UIButton, completion: @escaping () -> Void) {
    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    impactFeedback.impactOccurred()
    UIView.animate(
        withDuration: 0.1,
        animations: {
            button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    ) { _ in
        UIView.animate(
            withDuration: 0.1,
            animations: {
                button.transform = .identity
            }
        ) { _ in
            completion()
        }
    }
}

