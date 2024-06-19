//
//  KYBaseContentView.swift
//  Pods
//
//  Created by Kyle on 2017/8/29.
//
//

import UIKit

open class KYBaseContentView: UIView {


    @objc override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal func setupViews(){

    }

}
