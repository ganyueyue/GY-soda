//
//  STAlertViewController.swift
//  Swim
//
//  Created by YY on 2023/5/17.
//

import UIKit

class STAlertViewController: KYPopupViewController {

    internal var titleString : String?
    internal var messageString : String?
    internal var style : Int?

    @objc public init(
        title: String? = nil,
        message: String? = nil,
        style: Int = 0,
        transitionStyle: KYPopupViewTransitionStyle = .zoomIn,
        gestureDismissal: Bool = false,
        completion: (() -> Void)? = nil ){

        // Call designated initializer
        super.init(nibName: nil, bundle: nil)

        self.presentationManager.transitionStyle = transitionStyle
        self.style = style
        self.titleString = title
        self.messageString = message
        self.completion = completion
    }

    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func setupViews(){
        super.setupViews()

        self.contentView = STAlertContentView(title: self.titleString, message: self.messageString,style: self.style ?? 0, buttons: self.buttons)
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
