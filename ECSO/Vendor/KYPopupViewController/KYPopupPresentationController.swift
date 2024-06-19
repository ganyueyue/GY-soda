//
//  KYPopupPresentationController.swift
//  Pods
//
//  Created by Kyle on 2017/8/30.
//
//

import UIKit

@objc class KYPopupPresentationController: UIPresentationController {

    @objc internal lazy var overlay: KYPopupOverlayView = {
        return KYPopupOverlayView(frame: .zero)
    }()

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        overlay.frame = (presentingViewController?.view.bounds)!
    }

    override func presentationTransitionWillBegin() {
        overlay.frame = containerView!.bounds
        containerView!.insertSubview(overlay, at: 0)

        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (coordinatorContext) -> Void in
            self.overlay.alpha = 1.0
        }, completion: nil)
    }

    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (coordinatorContext) -> Void in
            self.overlay.alpha = 0.0
        }, completion: nil)
    }

    override func containerViewWillLayoutSubviews() {
        presentedView!.frame = frameOfPresentedViewInContainerView
    }
    
}
