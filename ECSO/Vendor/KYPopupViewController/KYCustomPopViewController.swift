//
//  KYCustomPopViewController.swift
//  Pods
//
//  Created by Kyle on 2017/9/12.
//
//

import UIKit

final public class KYCustomPopViewController: KYPopupViewController {

    @objc public init(
        contentView : KYBaseContentView,
        transitionStyle: KYPopupViewTransitionStyle = .zoomIn,
        gestureDismissal: Bool = false,
        offset: Bool = false,
        completion: (() -> Void)? = nil ){
        // Call designated initializer
        super.init(nibName: nil, bundle: nil)
        self.contentView = contentView
        self.presentationManager.transitionStyle = transitionStyle
        self.gestureDismissal = gestureDismissal
        self.offset = offset
        self.completion = completion
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func setupViews(){
        super.setupViews()

        self.view.addSubview(self.contentView)

        var constraints = [NSLayoutConstraint]()

        constraints.append(NSLayoutConstraint(item: self.contentView, attribute: .centerX   , relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0))
        if (self.offset) {
            self.contentYConstraint = NSLayoutConstraint(item: self.contentView, attribute: .bottom   , relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: -40)
        } else {
            self.contentYConstraint = NSLayoutConstraint(item: self.contentView, attribute: .centerY   , relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0)
        }
        
        constraints.append(self.contentYConstraint)
        // Activate constraints
        NSLayoutConstraint.activate(constraints)
        
    }


}
