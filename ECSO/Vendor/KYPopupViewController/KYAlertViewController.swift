//
//  KYAlertViewController.swift
//  Pods
//
//  Created by Kyle on 2017/8/28.
//
//

import UIKit

final public class KYAlertViewController: KYPopupViewController {

    internal var titleString : String?
    internal var messageString : String?
    internal var iconString : String?

    @objc public init(
        title: String? = nil,
        message: String? = nil,
        icon: String? = nil,
        transitionStyle: KYPopupViewTransitionStyle = .zoomIn,
        gestureDismissal: Bool = false,
        completion: (() -> Void)? = nil ){

        // Call designated initializer
        super.init(nibName: nil, bundle: nil)

        self.presentationManager.transitionStyle = transitionStyle

        self.titleString = title
        self.messageString = message
        self.iconString = icon
        self.completion = completion
    }

    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func setupViews(){
        super.setupViews()

        self.contentView = KYAlertContentView(title: self.titleString, message: self.messageString,icon: self.iconString, buttons: self.buttons)
        self.view.addSubview(self.contentView)

        var constraints = [NSLayoutConstraint]()

        constraints.append(NSLayoutConstraint(item: self.contentView, attribute: .centerX   , relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0))
        constraints.append(NSLayoutConstraint(item: self.contentView, attribute: .width   , relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 0.0, constant: 300))
        self.contentYConstraint = NSLayoutConstraint(item: self.contentView, attribute: .centerY   , relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0)
        constraints.append(self.contentYConstraint)
        // Activate constraints
        NSLayoutConstraint.activate(constraints)

    }
}
