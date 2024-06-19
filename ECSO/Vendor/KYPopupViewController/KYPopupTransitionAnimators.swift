//
//  KYPopupTransitionAnimators.swift
//  Pods
//
//  Created by Kyle on 2017/8/29.
//
//

import UIKit

@objc public enum KYPopupViewTransitionStyle: Int {
    case bounceUp
    case bounceDown
    case zoomIn
    case fadeIn
    case sheet
}

/// Dialog bounces in from bottom and is dismissed to bottom
final internal class KYBounceUpTransition: KYPopupTransitionAnimator {

    init(direction: KYPopupAnimationDirection) {
        super.init(inDuration: 0.22, outDuration: 0.2, direction: direction)
    }

    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        super.animateTransition(using: transitionContext)

        switch direction {
        case .in:
            to.view.bounds.origin = CGPoint(x: 0, y: -from.view.bounds.size.height)
            UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.curveEaseOut], animations: {
                self.to.view.bounds = self.from.view.bounds
            }) { (completed) in
                transitionContext.completeTransition(completed)
            }
        case .out:
            UIView.animate(withDuration: outDuration, delay: 0.0, options: [.curveEaseIn], animations: {
                self.from.view.bounds.origin = CGPoint(x: 0, y: -self.from.view.bounds.size.height)
                self.from.view.alpha = 0.0
            }) { (completed) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
}


/// Dialog bounces in from top and is dismissed to top
final internal class KYBounceDownTransition: KYPopupTransitionAnimator {

    init(direction: KYPopupAnimationDirection) {
        super.init(inDuration: 0.22, outDuration: 0.2, direction: direction)
    }

    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        super.animateTransition(using: transitionContext)

        switch direction {
        case .in:
            to.view.bounds.origin = CGPoint(x: 0, y: from.view.bounds.size.height)
            UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.curveEaseOut], animations: {
                self.to.view.bounds = self.from.view.bounds
            }) { (completed) in
                transitionContext.completeTransition(completed)
            }
        case .out:
            UIView.animate(withDuration: outDuration, delay: 0.0, options: [.curveEaseIn], animations: {
                self.from.view.bounds.origin = CGPoint(x: 0, y: self.from.view.bounds.size.height)
                self.from.view.alpha = 0.0
            }) { (completed) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
}

/// Dialog zooms in and is dismissed by zooming out
final internal class KYZoomTransition: KYPopupTransitionAnimator {

    init(direction: KYPopupAnimationDirection) {
        super.init(inDuration: 0.22, outDuration: 0.2, direction: direction)
    }

    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        super.animateTransition(using: transitionContext)

        switch direction {
        case .in:
            to.view.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [.curveEaseOut], animations: {
                self.to.view.transform = CGAffineTransform(scaleX: 1, y: 1)
            }) { (completed) in
                transitionContext.completeTransition(completed)
            }
        case .out:
            UIView.animate(withDuration: outDuration, delay: 0.0, options: [.curveEaseIn], animations: {
                self.from.view.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                self.from.view.alpha = 0.0
            }) { (completed) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
}

/// Dialog fades in and is dismissed by fading out
final internal class KYFadeTransition: KYPopupTransitionAnimator {

    init(direction: KYPopupAnimationDirection) {
        super.init(inDuration: 0.22, outDuration: 0.2, direction: direction)
    }

    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        super.animateTransition(using: transitionContext)

        switch direction {
        case .in:
            to.view.alpha = 0
            UIView.animate(withDuration: 0.6, delay: 0.0, options: [.curveEaseOut],
                           animations: {
                            self.to.view.alpha = 1
            }) { (completed) in
                transitionContext.completeTransition(completed)
            }
        case .out:
            UIView.animate(withDuration: outDuration, delay: 0.0, options: [.curveEaseIn], animations: {
                self.from.view.alpha = 0.0
            }) { (completed) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
}

final internal class KYSheetTransition: KYPopupTransitionAnimator {

    init(direction: KYPopupAnimationDirection) {
        super.init(inDuration: 0.22, outDuration: 0.2, direction: direction)
    }

    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        super.animateTransition(using: transitionContext)

        switch direction {
        case .in:
            to.view.bounds.origin = CGPoint(x: 0, y: -from.view.bounds.size.height)
            UIView.animate(withDuration: 0.45, delay: 0.0, options: [.curveEaseInOut], animations: {
                 self.to.view.bounds = self.from.view.bounds
            }, completion: { (completed) in
                transitionContext.completeTransition(completed)
            })
        case .out:
            UIView.animate(withDuration: outDuration, delay: 0.0, options: [.curveEaseIn], animations: {
                self.from.view.bounds.origin = CGPoint(x: 0, y: -self.from.view.bounds.size.height)
                self.from.view.alpha = 0.0
            }) { (completed) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
}

/// Used for the always drop out animation with pan gesture dismissal
final internal class KYDismissInteractiveTransition: KYPopupTransitionAnimator {

    init() {
        super.init(inDuration: 0.22, outDuration: 0.32, direction: .out)
    }

    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        super.animateTransition(using: transitionContext)
        UIView.animate(withDuration: outDuration, delay: 0.0, options: [.beginFromCurrentState], animations: {
            self.from.view.bounds.origin = CGPoint(x: 0, y: -self.from.view.bounds.size.height)
            self.from.view.alpha = 0.0
        }) { (completed) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

