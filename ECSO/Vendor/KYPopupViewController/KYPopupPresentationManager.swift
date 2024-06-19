//
//  KYPopupPresentationManager.swift
//  Pods
//
//  Created by Kyle on 2017/8/30.
//
//

import UIKit

@objc class KYPopupPresentationManager: NSObject,UIViewControllerTransitioningDelegate {

    var transitionStyle: KYPopupViewTransitionStyle
    var interactor: KYPopupInteractiveTransition

    init(transitionStyle: KYPopupViewTransitionStyle, interactor: KYPopupInteractiveTransition) {
        self.transitionStyle = transitionStyle
        self.interactor = interactor
        super.init()
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = KYPopupPresentationController(presentedViewController: presented, presenting: source)
        return presentationController
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        var transition: KYPopupTransitionAnimator
        switch transitionStyle {
        case .bounceUp:
            transition = KYBounceUpTransition(direction: .in)
        case .bounceDown:
            transition = KYBounceDownTransition(direction: .in)
        case .zoomIn:
            transition = KYZoomTransition(direction: .in)
        case .fadeIn:
            transition = KYFadeTransition(direction: .in)
        case .sheet:
            transition = KYSheetTransition(direction: .in)
        }



        return transition
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        if interactor.hasStarted || interactor.shouldFinish {
            return KYDismissInteractiveTransition()
        }

        var transition: KYPopupTransitionAnimator
        switch transitionStyle {
        case .bounceUp:
            transition = KYBounceUpTransition(direction: .out)
        case .bounceDown:
            transition = KYBounceDownTransition(direction: .out)
        case .zoomIn:
            transition = KYZoomTransition(direction: .out)
        case .fadeIn:
            transition = KYFadeTransition(direction: .out)
        case .sheet:
            transition = KYSheetTransition(direction: .out)
        }

        return transition
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}
