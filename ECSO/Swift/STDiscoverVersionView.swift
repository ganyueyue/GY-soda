//
//  STDiscoverVersionView.swift
//  Swim
//
//  Created by YY on 2023/1/10.
//

import UIKit

@objc public protocol STDiscoverVersionViewDelegate:NSObjectProtocol {
    func discoverVersionViewButton(number:Int)
}

class STDiscoverVersionView: KYBaseContentView {

    @objc public weak var delegate: STDiscoverVersionViewDelegate?

    internal lazy var backgroundView: UIView = {
        let backgroundView = UIView(frame: .zero)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        return backgroundView
    }()
    
    internal lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "version_update_bg")
        return imageView
    }()
    
    internal lazy var nameLabel: UILabel = {
        let nameLabel = UILabel(frame: .zero)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = UIColor(hex: 0xffffff)
        nameLabel.text = "版本更新提示！"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        return nameLabel
    }()
    
    internal lazy var versionLabel: UILabel = {
        let versionLabel = UILabel(frame: .zero)
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        versionLabel.textColor = UIColor(hex: 0xEAF7FF)
        versionLabel.font = UIFont.systemFont(ofSize: 12)
        return versionLabel
    }()
    
    internal lazy var sizeLabel: UILabel = {
        let sizeLabel = UILabel(frame: .zero)
        sizeLabel.translatesAutoresizingMaskIntoConstraints = false
        sizeLabel.textColor = UIColor(hex: 0xEAF7FF)
        sizeLabel.font = UIFont.systemFont(ofSize: 12)
        return sizeLabel
    }()
    
    internal lazy var titleLabel: UILabel = {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "更新内容:"
        titleLabel.textColor = UIColor(hex: 0x333333)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        return titleLabel
    }()
    
    internal lazy var textView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor.clear
        textView.textColor = UIColor(hex: 0x666666)
        textView.font = UIFont.systemFont(ofSize: 12)
        textView.isEditable = false
        textView.isSelectable = false;
        return textView
    }()
    
    internal lazy var okButton: UIButton = {
        let okButton = UIButton(frame: .zero)
        okButton.translatesAutoresizingMaskIntoConstraints = false
        okButton.setTitleColor(UIColor(hex: 0xffffff), for: .normal)
        okButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        okButton.layer.cornerRadius = 18
        okButton.setTitle("立即更新", for: .normal)
        okButton.backgroundColor = UIColor(hex: 0x4D88FF)
        okButton.tag = 1000
        okButton.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
        return okButton
    }()
    
    internal lazy var lineView: UIView = {
        let lineView = UIView(frame: .zero)
        lineView.backgroundColor = UIColor(hex: 0xffffff, alpha: 0.73)
        return lineView
    }()
    
    internal lazy var closeButton: UIButton = {
        let closeButton = UIButton(frame: .zero)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(UIImage(named: "version_update_close"), for: .normal)
        closeButton.tag = 1001
        closeButton.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
        return closeButton
    }()
    
    internal var versionString : String?
    internal var sizeString : String?
    internal var contentString : String?
    internal var isForceUpdate : Int?
    
    @objc init( versionString:String? ,sizeString:String? ,contentString : String?, isForceUpdate:Int){
        self.versionString = versionString
        self.sizeString = sizeString
        self.contentString = contentString
        self.isForceUpdate = isForceUpdate
        super.init(frame:.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal override func setupViews() {
        // Self setup
        translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.clear
        self.clipsToBounds = true
    
        addSubview(backgroundView)
        addSubview(imageView)
        imageView.addSubview(nameLabel)
        imageView.addSubview(versionLabel)
        imageView.addSubview(sizeLabel)
        imageView.addSubview(titleLabel)
        imageView.addSubview(textView)
        imageView.addSubview(okButton)
        addSubview(lineView)
        addSubview(closeButton)
        
        versionLabel.text = self.versionString
        sizeLabel.text = self.sizeString
        textView.text = self.contentString
        
        backgroundView.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)
            make?.top.equalTo()(self)
            make?.right.equalTo()(self)
            make?.width.mas_equalTo()(UIScreen.main.bounds.width - 110)
            make?.bottom.equalTo()(self)
        };
        
        imageView.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)
            make?.right.equalTo()(self)
            make?.top.equalTo()(self)
            make?.bottom.equalTo()(self.mas_bottom)?.offset()(-100)
        };
        
        nameLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(imageView)?.offset()(29)
            make?.top.equalTo()(imageView)?.offset()(29)
        }
        
        versionLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(nameLabel)
            make?.top.equalTo()(nameLabel.mas_bottom)?.offset()(10)
        }
        
        sizeLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(nameLabel)
            make?.top.equalTo()(versionLabel.mas_bottom)?.offset()(10)
        }
        
        titleLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(imageView)?.offset()(30)
            make?.centerY.equalTo()(imageView)?.offset()(-5)
        }
        
        textView.mas_makeConstraints { (make) in
            make?.top.equalTo()(titleLabel.mas_bottom)?.offset()(8)
            make?.leading.equalTo()(imageView)?.offset()(30)
            make?.trailing.equalTo()(imageView.mas_trailing)?.offset()(-30)
            make?.height.mas_equalTo()(80)
        }
        
        okButton.mas_makeConstraints { (make) in
            make?.left.equalTo()(imageView)?.offset()(30)
            make?.trailing.equalTo()(imageView.mas_trailing)?.offset()(-30)
            make?.top.equalTo()(textView.mas_bottom)?.offset()(20)
            make?.height.mas_equalTo()(36)
            make?.bottom.equalTo()(imageView.mas_bottom)?.offset()(-30)
        }
        
        if self.isForceUpdate == 1 {
            lineView.isHidden = true
            closeButton.isHidden = true
        }
        
        lineView.mas_makeConstraints { (make) in
            make?.top.equalTo()(imageView.mas_bottom)
            make?.size.mas_equalTo()(CGSize(width: 1, height: 30))
            make?.centerX.equalTo()(self)
        }
        
        closeButton.mas_makeConstraints { (make) in
            make?.size.mas_equalTo()(CGSize(width: 38, height: 38))
            make?.top.equalTo()(lineView.mas_bottom)?.offset()(0)
            make?.centerX.equalTo()(self)
        }
    }
    
    @objc public func btnClick(sender:UIButton?) {
        self.delegate?.discoverVersionViewButton(number: sender!.tag - 1000)
    }
}
