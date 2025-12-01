import UIKit

final class CustomBottomSheetTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    private let heightPercentage: CGFloat
    
    init(heightPercentage: CGFloat = 0.36) {
        self.heightPercentage = heightPercentage
        super.init()
    }
    
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        return CustomBottomSheetPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            heightPercentage: heightPercentage
        )
    }
    
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return CustomBottomSheetAnimator(isPresenting: true)
    }
    
    func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return CustomBottomSheetAnimator(isPresenting: false)
    }
}

final class CustomBottomSheetPresentationController: UIPresentationController {
    
    private let heightPercentage: CGFloat
    
    private lazy var dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.alpha = 0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    private lazy var grabberView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray3
        view.layer.cornerRadius = 2.5
        return view
    }()
    
    init(presentedViewController: UIViewController,
         presenting presentingViewController: UIViewController?,
         heightPercentage: CGFloat = 0.36) {
        self.heightPercentage = heightPercentage
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        
        let height = containerView.bounds.height * heightPercentage
        let y = containerView.bounds.height - height
        
        return CGRect(
            x: 0,
            y: y,
            width: containerView.bounds.width,
            height: height
        )
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        
        dimmingView.frame = containerView.bounds
        containerView.insertSubview(dimmingView, at: 0)
        
        presentedViewController.view.addSubview(grabberView)
        grabberView.frame = CGRect(
            x: (containerView.bounds.width - 36) / 2,
            y: 8,
            width: 36,
            height: 5
        )
        
        presentedViewController.view.layer.cornerRadius = 24
        presentedViewController.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        presentedViewController.view.clipsToBounds = true
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1
        })
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0
        })
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
            grabberView.removeFromSuperview()
        }
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        dimmingView.frame = containerView?.bounds ?? .zero
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    @objc private func dimmingViewTapped() {
        presentedViewController.dismiss(animated: true)
    }
}

final class CustomBottomSheetAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let isPresenting: Bool
    
    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let duration = transitionDuration(using: transitionContext)
        
        if isPresenting {
            guard let toVC = transitionContext.viewController(forKey: .to) else {
                transitionContext.completeTransition(false)
                return
            }
            
            let toView = toVC.view!
            containerView.addSubview(toView)
            
            let finalFrame = transitionContext.finalFrame(for: toVC)
            let startFrame = finalFrame.offsetBy(dx: 0, dy: finalFrame.height)
            toView.frame = startFrame
            
            UIView.animate(
                withDuration: duration,
                delay: 0,
                usingSpringWithDamping: 0.85,
                initialSpringVelocity: 0,
                options: .curveEaseOut,
                animations: {
                    toView.frame = finalFrame
                },
                completion: { finished in
                    transitionContext.completeTransition(finished)
                }
            )
        } else {
            guard let fromVC = transitionContext.viewController(forKey: .from) else {
                transitionContext.completeTransition(false)
                return
            }
            
            let fromView = fromVC.view!
            let finalFrame = fromView.frame.offsetBy(dx: 0, dy: fromView.frame.height)
            
            UIView.animate(
                withDuration: duration,
                delay: 0,
                options: .curveEaseIn,
                animations: {
                    fromView.frame = finalFrame
                },
                completion: { finished in
                    fromView.removeFromSuperview()
                    transitionContext.completeTransition(finished)
                }
            )
        }
    }
}

