//
//  KYActionSheetContentView.swift
//  lexiwed2
//
//  Created by Kyle on 2017/11/4.
//  Copyright © 2017年 乐喜网. All rights reserved.
//

import UIKit

final public class KYActionSheetContentView: KYBaseContentView {

    // MARK: - Appearance

    /// The font and size of the title label
    @objc public dynamic var titleFont: UIFont {
        get { return titleLabel.font }
        set { titleLabel.font = newValue }
    }

    /// The color of the title label
    @objc public dynamic var titleColor: UIColor? {
        get { return titleLabel.textColor }
        set { titleLabel.textColor = newValue }
    }

    /// The text alignment of the title label
    @objc public dynamic var titleTextAlignment: NSTextAlignment {
        get { return titleLabel.textAlignment }
        set { titleLabel.textAlignment = newValue }
    }

    // MARK: - Views

    /// The view that will contain the image, if set

    /// The title label of the dialog
    internal lazy var titleLabel: UILabel = {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor(hex: 0x000000)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        return titleLabel
    }()

    /// The message label of the dialog

    /// The height constraint of the image view, 0 by default
    internal var titleLabelTopConstraint: NSLayoutConstraint?
    internal var messageLabelTopConstraint: NSLayoutConstraint?
    internal var messageLabelBottomConstraint: NSLayoutConstraint?
    internal var buttonTopConstraint: NSLayoutConstraint?

    internal var actionbuttons : [KYPopupButton]
    internal var title : String?
    internal var message : String?
    internal var customView : UIView?
    internal var cancelButton : UIButton!

    init( title: String?,
          customView: UIView?,
          buttons:[KYPopupButton],
          cancelButton:UIButton){
        self.title = title
        self.customView = customView
        self.actionbuttons = buttons
        self.cancelButton = cancelButton
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false

    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View setup

    internal override func setupViews() {
        // Self setup
        self.backgroundColor = UIColor.white

        // Add views
        var constraints = [NSLayoutConstraint]()
        var topAnchor : UIView?
        if let text = self.title {
            addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.text = text
            topAnchor = titleLabel

            let views = ["titleLabel": titleLabel] as [String : Any]

            constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[titleLabel]|", options: [], metrics: nil, views: views)
            constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[titleLabel(20)]", options: [], metrics: nil, views: views)
        }

        if let view = self.customView {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)

            if let top = topAnchor {

                let lineView = KYPopupLine()
                lineView.translatesAutoresizingMaskIntoConstraints = false;
                lineView.lineColor = UIColor(hex: 0xb2b2b2, alpha: 1)
                self.addSubview(lineView)

                let views = ["view": view,"lineView":lineView] as [String : Any]

                constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: views)
                constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(1)][view]", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: views)
                constraints.append(NSLayoutConstraint(item: lineView, attribute: .top, relatedBy: .equal, toItem: top, attribute: .bottom, multiplier: 1.0, constant: 0))

            }else{

                let views = ["view": view] as [String : Any]
                constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: views)
                constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]", options: [], metrics: nil, views: views)

            }
            topAnchor = view
        }

        for i in 0..<self.actionbuttons.count {

            let button = self.actionbuttons[i]
            button.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(button)

            if let top = topAnchor {

                let lineView = KYPopupLine()
                lineView.translatesAutoresizingMaskIntoConstraints = false;
                lineView.lineColor = UIColor(hex: 0xb2b2b2, alpha: 1)
                self.addSubview(lineView)

                let views = ["view": button,"lineView":lineView] as [String : Any]

                constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: views)
                constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(1)][view]", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: views)
                constraints.append(NSLayoutConstraint(item: lineView, attribute: .top, relatedBy: .equal, toItem: top, attribute: .bottom, multiplier: 1.0, constant: 0))

            }else{

                let views = ["view": button] as [String : Any]
                constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: views)
                constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]", options: [], metrics: nil, views: views)

            }
            topAnchor = button
        }

        self.cancelButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.cancelButton)
        if let top = topAnchor {

            let lineView = UIView()
            lineView.translatesAutoresizingMaskIntoConstraints = false
            lineView.backgroundColor = UIColor(hex: 0xb2b2b2, alpha: 1)
            self.addSubview(lineView)
            let views = ["view": self.cancelButton,"lineView":lineView] as [String : Any]

            constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: views)
            constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(5)][view]", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: views)
            constraints.append(NSLayoutConstraint(item: lineView, attribute: .top, relatedBy: .equal, toItem: top, attribute: .bottom, multiplier: 1.0, constant: 0))

        }else{

            let views = ["view": self.cancelButton] as [String : Any]
            constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: views)
            constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]", options: [], metrics: nil, views: views)

        }
        constraints.append(NSLayoutConstraint(item: self.cancelButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))

        // Activate constraints
        NSLayoutConstraint.activate(constraints)
    }
}


open class KYPopupLine : UIView {


    open var lineColor : UIColor = UIColor(hex: 0xeeeeee){
        didSet{
            self.setNeedsDisplay()
        }
    }

    convenience init() {
        self.init(frame: .zero)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setup(){
        self.backgroundColor = UIColor.white
    }

    open override func draw(_ rect: CGRect) {

        guard let context = UIGraphicsGetCurrentContext() else{
            return
        }

        context.beginPath()

        context.move(to: CGPoint(x: 0, y: 0))
        context.addLine(to:  CGPoint(x: self.bounds.size.width, y: 0))
        context.setLineWidth(1)

        context.setStrokeColor(self.lineColor.cgColor)
        context.strokePath()

    }

}
