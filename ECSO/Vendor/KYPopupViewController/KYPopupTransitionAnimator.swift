//
//  KYPopupTransitionAnimator.swift
//  Pods
//
//  Created by Kyle on 2017/8/29.
//
//
import Foundation
import UIKit

internal class KYPopupTransitionAnimator: NSObject ,UIViewControllerAnimatedTransitioning{

    var to: UIViewController!
    var from: UIViewController!
    let inDuration: TimeInterval
    let outDuration: TimeInterval
    let direction: KYPopupAnimationDirection

    init(inDuration: TimeInterval, outDuration: TimeInterval, direction: KYPopupAnimationDirection) {
        self.inDuration = inDuration
        self.outDuration = outDuration
        self.direction = direction
        super.init()
    }

    internal func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return direction == .in ? inDuration : outDuration
    }

    internal func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch direction {
        case .in:
            to = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
            from = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
            let container = transitionContext.containerView
            container.addSubview(to.view)
        case .out:
            to = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
            from = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        }
    }


}
