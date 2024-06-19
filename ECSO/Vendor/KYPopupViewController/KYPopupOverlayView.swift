//
//  KYPopupOverlayView.swift
//  Pods
//
//  Created by Kyle on 2017/8/30.
//
//

import UIKit

class KYPopupOverlayView: UIView {

    // MARK: - Appearance
    /// The background color of the overlay view
    @objc public dynamic var color: UIColor? {
        get { return overlay.backgroundColor }
        set { overlay.backgroundColor = newValue }
    }

    /// The opacity of the overay view
    @objc public dynamic var opacity: Float {
        get { return Float(overlay.alpha) }
        set { overlay.alpha = CGFloat(newValue) }
    }


    internal lazy var overlay: UIView = {
        let overlay = UIView(frame: .zero)
        overlay.backgroundColor = UIColor.black
        overlay.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        overlay.alpha = 0.7
        return overlay
    }()

    // MARK: - Inititalizers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View setup

    fileprivate func setupView() {

        // Self appearance
        self.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.backgroundColor = UIColor.clear
        self.alpha = 0

        // Add subview
        addSubview(overlay)
    }
    
}
