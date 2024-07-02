//
//  KYAlertContentView.swift
//  Pods
//
//  Created by Kyle on 2017/8/29.
//
//

import UIKit
import CoreData

final public class KYAlertContentView: KYBaseContentView {

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

    /// The font and size of the body label
    @objc public dynamic var messageFont: UIFont {
        get { return messageLabel.font! }
        set { messageLabel.font = newValue }
    }

    /// The color of the message label
    @objc public dynamic var messageColor: UIColor? {
        get { return messageLabel.textColor }
        set { messageLabel.textColor = newValue}
    }

    /// The text alignment of the message label
    @objc public dynamic var messageTextAlignment: NSTextAlignment {
        get { return messageLabel.textAlignment }
        set { messageLabel.textAlignment = newValue }
    }

    // MARK: - Views

    /// The view that will contain the image, if set
    ///
    internal lazy var iconView: UIImageView = {
        let iconView = UIImageView(frame: .zero)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.contentMode = .scaleAspectFit
        iconView.clipsToBounds = true
        iconView.image = UIImage(named: "common_logo")
        return iconView
    }()

    /// The title label of the dialog
    internal lazy var titleLabel: UILabel = {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor(hex: 0x000000)
        titleLabel.font = STFont.fontStatus(medium, fontSize: 19)
        return titleLabel
    }()

    /// The message label of the dialog
    internal lazy var messageLabel: UITextView = {
        let messageLabel = UITextView(frame: .zero)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.isEditable = false
        messageLabel.bounces = false
        messageLabel.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        messageLabel.textColor = UIColor(hex: 0x888888)
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        messageLabel.backgroundColor = UIColor.white
        return messageLabel
    }()

    internal var actionbuttons : [KYPopupButton]
    internal var title : String?
    internal var message : String?
    internal var icon : String?

    init( title: String?,
          message: String?,
          icon: String?,
          buttons:[KYPopupButton]){
        self.title = title
        self.message = message
        self.icon = icon
        self.actionbuttons = buttons
        super.init(frame:.zero)


    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View setup

    internal override func setupViews() {
        // Self setup
        translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 15.0
        self.clipsToBounds = true

        // Add views
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(messageLabel)
        
        if self.icon != nil && self.icon!.count > 0 {
           iconView.sd_setImage(with: URL(string: self.icon!), completed: nil)
        }
        titleLabel.text = self.title
        
        if self.message == nil {
            self.message = ""
        }
        
        guard let news = self.message?.removingPercentEncoding,let data = news.data(using: .unicode) else{return}
        let att = [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html]
        guard let attStr = try? NSMutableAttributedString(data: data, options: att, documentAttributes: nil) else{return}
        messageLabel.attributedText = attStr
        
        let height: CGFloat = attStr.boundingRect(with:  CGSize(width: 260, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions(rawValue: NSStringDrawingOptions.usesLineFragmentOrigin.rawValue), context: nil).height + 10

        iconView.mas_makeConstraints { (make) in
            make?.leading.equalTo()(self)?.offset()(22)
            make?.top.equalTo()(self)?.offset()(22)
            make?.size.mas_equalTo()(CGSize(width: 20, height: 20))
        }
        
        titleLabel.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(iconView)
            make?.leading.equalTo()(iconView.mas_trailing)?.offset()(8)
        }
        
        if height > 100 {
            messageLabel.mas_makeConstraints { make in
                make?.leading.equalTo()(self)?.offset()(20)
                make?.centerX.equalTo()(self)
                make?.top.equalTo()(iconView.mas_bottom)?.offset()(12)
                make?.height.mas_equalTo()(100)
            }
        } else {
            messageLabel.mas_makeConstraints { make in
                make?.leading.equalTo()(self)?.offset()(20)
                make?.centerX.equalTo()(self)
                make?.top.equalTo()(iconView.mas_bottom)?.offset()(12)
                make?.height.mas_equalTo()(height)
            }
        }
        
        if self.actionbuttons.count == 1 {

            let button = self.actionbuttons[0]
            button.setTitleColor(UIColor(hex: 0xFFFFFF), for: .normal)
            button.titleFont = STFont.fontSize(12)
            button.backgroundColor = UIColor.init(hex: 0x536EEB)
            button.layer.cornerRadius = 17
            button.clipsToBounds = true
            button.translatesAutoresizingMaskIntoConstraints = false;
            addSubview(button);
            button.mas_makeConstraints { (make) in
                make?.top.equalTo()(messageLabel.mas_bottom)?.offset()(20)
                make?.centerX.equalTo()(self)
                make?.size.mas_equalTo()(CGSize.init(width: 100, height: 34))
                make?.bottom.equalTo()(self.mas_bottom)?.offset()(-21)
            }

        }else if self.actionbuttons.count == 2{

            let buttonOne = self.actionbuttons[0]
            let buttonTwo = self.actionbuttons[1]
            buttonOne.setTitleColor(UIColor(hex: 0x292F48), for: .normal)
            buttonOne.titleFont = STFont.fontSize(12)
            buttonOne.layer.cornerRadius = 17
            buttonOne.clipsToBounds = true
            buttonOne.layer.borderColor = UIColor(hex: 0xE3E3E3).cgColor
            buttonOne.layer.borderWidth = 1
            buttonOne.translatesAutoresizingMaskIntoConstraints = false;
            addSubview(buttonOne);
            
            buttonTwo.setTitleColor(UIColor(hex: 0xFFFFFF), for: .normal)
            buttonTwo.titleFont = STFont.fontSize(12)
            buttonTwo.backgroundColor = UIColor.init(hex: 0x536EEB)
            buttonTwo.layer.cornerRadius = 17
            buttonTwo.clipsToBounds = true
            buttonTwo.translatesAutoresizingMaskIntoConstraints = false;
            addSubview(buttonTwo);

            buttonOne.mas_makeConstraints { (make) in
                make?.top.equalTo()(messageLabel.mas_bottom)?.offset()(20)
                make?.trailing.equalTo()(self.mas_centerX)?.offset()(-8)
                make?.size.mas_equalTo()(CGSize.init(width: 100, height: 34))
            }


            buttonTwo.mas_makeConstraints { (make) in
                make?.top.equalTo()(messageLabel.mas_bottom)?.offset()(20)
                make?.leading.equalTo()(self.mas_centerX)?.offset()(8)
                make?.size.mas_equalTo()(CGSize.init(width: 100, height: 34))
                make?.bottom.equalTo()(self.mas_bottom)?.offset()(-20)
            }


        }else{
            fatalError("not support this number of button")
        }

    }
}
