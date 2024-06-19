//
//  KYPopupActionButton.swift
//  lexiwed2
//
//  Created by Kyle on 2017/11/4.
//  Copyright © 2017年 乐喜网. All rights reserved.
//

import UIKit

open class KYPopupActionButton: KYPopupButton {


    // MARK: View setup

    open override func setupView() {

        // Default appearance

        setTitleColor(UIColor(hex: 0x333333), for: UIControl.State())
        titleLabel?.font              = UIFont.systemFont(ofSize: 17)
        backgroundColor               = defaultButtonColor
        setBackgroundImage(defaultButtonBackgroundImage, for: .normal)

        let views = ["button": self]
        let metrics = ["buttonHeight": buttonHeight]
        var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[button(buttonHeight)]", options: [], metrics: metrics, views: views)
        NSLayoutConstraint.activate(constraints)
    }

}
