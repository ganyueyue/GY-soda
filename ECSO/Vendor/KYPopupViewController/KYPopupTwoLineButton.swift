//
//  KYPopupTwoLineButton.swift
//  lexiwed2
//
//  Created by ganyue on 2017/11/6.
//  Copyright © 2017年 乐喜网. All rights reserved.
//

import UIKit

class KYPopupTwoLineButton: KYPopupButton {

    public typealias buttonClosure = () -> Void
    
    internal lazy var topLabel: UILabel = {
        let topLabel = UILabel(frame: .zero)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.textAlignment = .center
        topLabel.textColor = UIColor(hex: 0x333333)
        topLabel.font = UIFont.systemFont(ofSize: 17)
        topLabel.backgroundColor = UIColor.clear
        return topLabel
    }()

    internal lazy var bottomLabel: UILabel = {
        let bottomLabel = UILabel(frame: .zero)
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomLabel.textAlignment = .center
        bottomLabel.textColor = UIColor(hex: 0x666666)
        bottomLabel.font = UIFont.systemFont(ofSize: 12)
        bottomLabel.backgroundColor = UIColor.clear
        return bottomLabel
    }()
    internal var topLabelStr : String?
    internal var bottomLabelStr : String?
    
    @objc init( topLabelStr: String? ,bottomLabelStr:String? ,action: buttonClosure?){
        self.topLabelStr = topLabelStr
        self.bottomLabelStr = bottomLabelStr
        super.init(title: "", action: action)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.clear
        self.clipsToBounds = true
        
        topLabel.text = self.topLabelStr
        bottomLabel.text = self.bottomLabelStr
        
        addSubview(topLabel)
        addSubview(bottomLabel)
        topLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)?.setOffset(0)
            make?.top.equalTo()(self)?.setOffset(10)
            make?.right.equalTo()(self)?.setOffset(0)
            make?.height.equalTo()(18)
        }

        bottomLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)?.setOffset(0)
            make?.top.equalTo()(topLabel.mas_bottom)?.setOffset(5)
            make?.right.equalTo()(self)?.setOffset(0)
            make?.height.equalTo()(12)
            make?.bottom.equalTo()(self)?.setOffset(-10)
        }
    }
}
