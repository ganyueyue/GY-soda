//
//  KYPopupDefaultButton.swift
//  lexiwed2
//
//  Created by Kyle on 2017/9/15.
//  Copyright © 2017年 乐喜网. All rights reserved.
//

import UIKit

// MARK: Default button

/// Represents the default button for the popup dialog
public final class KYPopupDefaultButton: KYPopupButton {}

// MARK: Cancel button

/// Represents a cancel button for the popup dialog
public final class KYPopupCancelButton: KYPopupButton {

    override public func setupView() {
        defaultTitleColor = UIColor(hex: 0x999999)
        defaultButtonBackgroundImage = UIImage(named: "alert_cancel")
        super.setupView()
    }
}

// MARK: destructive button

/// Represents a destructive button for the popup dialog
public final class KYPopupDestructiveButton: KYPopupButton {

    override public func setupView() {
        defaultTitleColor = UIColor(hex: 0xe94653)
        super.setupView()
    }
}


/// Represents a cancel button for the popup dialog
public final class LXPopupCancelButton: KYPopupButton {
    
    override public func setupView() {
        defaultTitleColor = UIColor(hex: 0x9b9b9b)
        defaultButtonBackgroundImage = UIImage(named: "button_delete")
        setBackgroundImage(UIImage(named: "button_delete"), for: .highlighted)
        super.setupView()
    }
}

// MARK: destructive button

/// Represents a destructive button for the popup dialog
public final class LXPopupDestructiveButton: KYPopupButton {
    
    override public func setupView() {
        defaultTitleColor = UIColor(hex: 0xffffff)
        
        super.setupView()
    }
}
