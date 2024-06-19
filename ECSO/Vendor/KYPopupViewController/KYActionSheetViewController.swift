//
//  KYActionSheetViewController.swift
//  lexiwed2
//
//  Created by Kyle on 2017/11/4.
//  Copyright © 2017年 乐喜网. All rights reserved.
//

import UIKit

final public class KYActionSheetViewController: KYPopupViewController {
    internal var titleString : String?
    internal var customView : UIView?
    internal var cancelButton : KYPopupActionButton!

    @objc public init(
        title: String? = nil,
        customView: UIView? = nil,
        transitionStyle: KYPopupViewTransitionStyle = .sheet,
        gestureDismissal: Bool = false,
        completion: (() -> Void)? = nil ){

        // Call designated initializer
        super.init(nibName: nil, bundle: nil)

        self.presentationManager.transitionStyle = transitionStyle

        self.titleString = title
        self.customView = customView
        self.completion = completion
        self.gestureDismissal = gestureDismissal
        self.cancelButton = KYPopupActionButton(title: "取消", height: 55, dismissOnTap: true, action: nil)
    }


    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc fileprivate func cancelTapped(_ button: KYPopupButton) {
        if button.dismissOnTap {
            dismiss() { button.buttonAction?() }
        } else {
            button.buttonAction?()
        }
    }

    override func setupViews(){
        super.setupViews()

        self.cancelButton.addTarget(self, action: #selector(cancelTapped(_:)), for: .touchUpInside)

        self.contentView = KYActionSheetContentView(title: self.titleString, customView: self.customView, buttons: self.buttons, cancelButton: self.cancelButton)
        self.view.addSubview(self.contentView)

        var constraints = [NSLayoutConstraint]()

        constraints.append(NSLayoutConstraint(item: self.contentView, attribute: .leading   , relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0))
        constraints.append(NSLayoutConstraint(item: self.contentView, attribute: .trailing   , relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0))
        self.contentYConstraint = NSLayoutConstraint(item: self.contentView, attribute: .bottom   , relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0)
        constraints.append(self.contentYConstraint)
        // Activate constraints
        NSLayoutConstraint.activate(constraints)

    }
}

