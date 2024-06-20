//
//  STAuthorizationCell.swift
//  ECSO
//
//  Created by YY on 2024/6/3.
//

import UIKit

class STAuthorizationCell: UITableViewCell {
    
    @objc public var info : STWallet?  {
        didSet {
            iconView.sx_setImagePlacehold(withURL: info?.tokenIcon ?? "", placeholderImage: UIImage(named: "icon_eth_logo")!)
            nameLabel.text = info?.tokenName
            tipsLabel.text = info?.contractAddress
            optionsButton.isSelected = info!.isSelected
        }
    }
    
    internal lazy var iconView : UIImageView = {
        let iconView = UIImageView.init(frame: .zero)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.layer.cornerRadius = 20
        iconView.clipsToBounds = true
        return iconView;
    }()
    
    internal lazy var nameLabel : UILabel = {
        let nameLabel = UILabel.init(frame: .zero)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = UIColor(hex: 0x292F48)
        nameLabel.font = STFont.fontStatus(medium, fontSize: 13)
        return nameLabel;
    }()
    
    internal lazy var tipsLabel : UILabel = {
        let tipsLabel = UILabel.init(frame: .zero)
        tipsLabel.translatesAutoresizingMaskIntoConstraints = false
        tipsLabel.textColor = UIColor(hex: 0x909090)
        tipsLabel.font = STFont.fontSize(10)
        return tipsLabel;
    }()
    
    internal lazy var optionsButton: UIButton = {
        let optionsButton = UIButton(frame: .zero)
        optionsButton.translatesAutoresizingMaskIntoConstraints = false
        optionsButton.setImage(UIImage(named: "icon_auth_nor"), for: .normal)
        optionsButton.setImage(UIImage(named: "icon_auth_sel"), for: .selected)
        optionsButton.isUserInteractionEnabled = false
        return optionsButton
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    convenience init() {
        self.init()
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    open func setup() {
        
        self.backgroundColor = UIColor.white
        self.selectionStyle = .none
        
        self.contentView.addSubview(iconView)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(tipsLabel)
        self.contentView.addSubview(optionsButton)
        
        iconView.mas_makeConstraints { (make) in
            make?.leading.equalTo()(self.contentView)
            make?.top.equalTo()(self.contentView)?.offset()(5)
            make?.centerY.equalTo()(self.contentView)
            make?.width.height().mas_equalTo()(40)
        }
        
        self.contentView.addSubview(self.optionsButton)
        self.optionsButton.mas_makeConstraints { (make) in
            make?.trailing.equalTo()(self.contentView)?.offset()(-2)
            make?.centerY.equalTo()(self.contentView)
            make?.width.height().mas_equalTo()(35)
        }
        
        nameLabel.mas_makeConstraints { (make) in
            make?.leading.equalTo()(iconView.mas_trailing)?.offset()(11)
            make?.bottom.equalTo()(iconView.mas_centerY)?.offset()(-1)
            make?.trailing.equalTo()(self.optionsButton.mas_leading)?.offset()(-10)
        }
        
        tipsLabel.mas_makeConstraints { (make) in
            make?.leading.trailing().equalTo()(nameLabel)
            make?.top.equalTo()(iconView.mas_centerY)?.offset()(1)
        }
        
    }

}
