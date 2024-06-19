//
//  STAlertContentView.swift
//  Swim
//
//  Created by YY on 2023/5/17.
//

import UIKit

class STAlertContentView: KYBaseContentView {

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
    
    /// The title label of the dialog
    internal lazy var titleLabel: UILabel = {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor(hex: 0x292F48)
        titleLabel.font = STFont.fontStatus(medium, fontSize: 18)
        return titleLabel
    }()

    /// The message label of the dialog
    internal lazy var messageLabel: UILabel = {
        let messageLabel = UILabel(frame: .zero)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = UIColor(hex: 0x888888)
        messageLabel.numberOfLines = 0;
        messageLabel.font = UIFont.systemFont(ofSize: 13)
        messageLabel.backgroundColor = UIColor.white
        return messageLabel
    }()

    internal var actionbuttons : [KYPopupButton]
    internal var title : String?
    internal var message : String?
    internal var style : Int = 0

    init( title: String?,
          message: String?,
          style: Int = 0,
          buttons:[KYPopupButton]){
        self.title = title
        self.message = message
        self.style = style
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

        addSubview(titleLabel)
        addSubview(messageLabel)
        
        titleLabel.text = self.title
        
        if self.message == nil {
            self.message = ""
        }
        
        guard let news = self.message?.removingPercentEncoding else{return}
        //通过富文本来设置行间距
        let  paraph =  NSMutableParagraphStyle ()
        //将行间距设置为28
        paraph.lineSpacing = 10
        if self.style == 0 {
            paraph.alignment = NSTextAlignment.left
        } else if (self.style == 1) {
            paraph.alignment = NSTextAlignment.center
        } else {
            paraph.alignment = NSTextAlignment.right
        }
         //样式属性集合
        let  attributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13),
                           NSAttributedString.Key.foregroundColor : UIColor(hex: 0x888888),
                             NSAttributedString.Key.paragraphStyle : paraph]
        messageLabel.attributedText =  NSAttributedString (string: news, attributes: attributes)

        titleLabel.mas_makeConstraints { (make) in
            make?.trailing.equalTo()(self)?.offset()(-22)
            make?.leading.equalTo()(self)?.offset()(22)
            make?.top.equalTo()(self)?.offset()(22)
        }
        
        messageLabel.mas_makeConstraints { make in
            make?.leading.equalTo()(self)?.offset()(20)
            make?.centerX.equalTo()(self)
            make?.top.equalTo()(titleLabel.mas_bottom)?.offset()(22)
        }
        
        
        if self.actionbuttons.count == 1 {

            let button = self.actionbuttons[0]
            button.setTitleColor(UIColor(hex: 0xFFFFFF), for: .normal)
            button.titleFont = STFont.fontSize(15)
            button.backgroundColor = UIColor.init(hex: 0x536EEB)
            button.layer.cornerRadius = 19
            button.clipsToBounds = true
            button.translatesAutoresizingMaskIntoConstraints = false;
            addSubview(button);
            button.mas_makeConstraints { (make) in
                make?.top.equalTo()(messageLabel.mas_bottom)?.offset()(25)
                make?.centerX.equalTo()(self)
                make?.size.mas_equalTo()(CGSize.init(width: 120, height: 38))
                make?.bottom.equalTo()(self.mas_bottom)?.offset()(-23)
            }

        }else if self.actionbuttons.count == 2{

            let buttonOne = self.actionbuttons[0]
            let buttonTwo = self.actionbuttons[1]
            buttonOne.setTitleColor(UIColor(hex: 0x292F48), for: .normal)
            buttonOne.titleFont = STFont.fontSize(15)
            buttonOne.layer.cornerRadius = 19
            buttonOne.clipsToBounds = true
            buttonOne.layer.borderColor = UIColor(hex: 0xE3E3E3).cgColor
            buttonOne.layer.borderWidth = 1
            buttonOne.translatesAutoresizingMaskIntoConstraints = false;
            addSubview(buttonOne);
            
            buttonTwo.setTitleColor(UIColor(hex: 0xFFFFFF), for: .normal)
            buttonTwo.titleFont = STFont.fontSize(15)
            buttonTwo.backgroundColor = UIColor.init(hex: 0x536EEB)
            buttonTwo.layer.cornerRadius = 19
            buttonTwo.clipsToBounds = true
            buttonTwo.translatesAutoresizingMaskIntoConstraints = false;
            addSubview(buttonTwo);

            buttonOne.mas_makeConstraints { (make) in
                make?.top.equalTo()(messageLabel.mas_bottom)?.offset()(25)
                make?.trailing.equalTo()(self.mas_centerX)?.offset()(-8)
                make?.size.mas_equalTo()(CGSize.init(width: 120, height: 38))
            }


            buttonTwo.mas_makeConstraints { (make) in
                make?.top.equalTo()(messageLabel.mas_bottom)?.offset()(25)
                make?.leading.equalTo()(self.mas_centerX)?.offset()(8)
                make?.size.mas_equalTo()(CGSize.init(width: 120, height: 38))
                make?.bottom.equalTo()(self.mas_bottom)?.offset()(-23)
            }


        }else{
            fatalError("not support this number of button")
        }

    }

}
