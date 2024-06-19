//
//  STAuthorization.swift
//  ECSO
//
//  Created by YY on 2024/5/31.
//

import UIKit

@objc public protocol STAuthorizationDelegate :NSObjectProtocol {
    func didSelectedAuthorization(reslut:Bool,appcode:String,blockchain:Int,wallet:String,balance:Int,attach:String,name:String)
}

class STAuthorization: KYBaseContentView {
    
    @objc public weak var delegate: STAuthorizationDelegate?

    lazy var iconView: UIImageView = {
        let iconView = UIImageView(frame: .zero)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.image = UIImage.init(named: "login_header")
        iconView.layer.cornerRadius = 22.5
        iconView.clipsToBounds = true
        return iconView
    }()
    
    internal lazy var titleLabel : UILabel = {
        let titleLabel = UILabel.init(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor(hex: 0x292F48)
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.text = "小小木屋";
        return titleLabel;
    }()
    
    internal lazy var closeButton :UIButton = {
        let closeButton = UIButton.init(frame: .zero)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(UIImage(named: "icon_close"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeAction(sender:)), for: .touchUpInside)
        closeButton.clipsToBounds = true
        return closeButton
    }()
    
    internal lazy var descLabel : UILabel = {
        let descLabel = UILabel.init(frame: .zero)
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.textColor = UIColor(hex: 0x292F48)
        descLabel.font = UIFont.systemFont(ofSize: 12)
        descLabel.numberOfLines = 0
        descLabel.text = "请求获取您的用户信息（昵称、头像、手机号码、钱包地址）";
        return descLabel;
    }()
    
    internal lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.bounces = false
        tableView.clipsToBounds = true
        tableView.register(STAuthorizationCell.classForCoder(), forCellReuseIdentifier: STAuthorizationCell.className())
        return tableView
    }()
    
    internal lazy var cancelButton :UIButton = {
        let cancelButton = UIButton.init(frame: .zero)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.backgroundColor = UIColor(hex: 0xEEEEF5)
        cancelButton.setTitleColor(UIColor.init(hex: 0x536EEB), for: .normal)
        cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        cancelButton.addTarget(self, action: #selector(closeAction(sender:)), for: .touchUpInside)
        cancelButton.layer.cornerRadius = 22
        cancelButton.clipsToBounds = true
        return cancelButton
    }()
    
    internal lazy var defineButton :UIButton = {
        let defineButton = UIButton.init(frame: .zero)
        defineButton.translatesAutoresizingMaskIntoConstraints = false
        defineButton.setTitle("确定", for: .normal)
        defineButton.tag = 101
        defineButton.backgroundColor = UIColor(hex: 0x536EEB)
        defineButton.setTitleColor(UIColor.init(hex: 0xFFFFFF), for: .normal)
        defineButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        defineButton.addTarget(self, action: #selector(closeAction(sender:)), for: .touchUpInside)
        defineButton.layer.cornerRadius = 22
        defineButton.clipsToBounds = true
        return defineButton
    }()
    
    internal var name : String
    internal var appcode : String
    internal var attach : String
    internal var blockchain : Int
    internal var wallers : Array<STWallet>
    
    @objc init(name : String,appcode : String,attach : String,blockchain : Int,wallers : Array<STWallet>){
        self.name = name
        self.appcode = appcode
        self.attach = attach
        self.blockchain = blockchain
        self.wallers = wallers
        super.init(frame:.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(closeButton)
        addSubview(descLabel)
        addSubview(tableView)
        addSubview(cancelButton)
        addSubview(defineButton)
        
        let icon = STUserDefault.objectValue(forKey: "portrait")
        let name = STUserDefault.objectValue(forKey: "displayName")
        iconView.sx_setImagePlacehold(withURL: icon as! String)
        titleLabel.text = name as? String
        
        iconView.mas_makeConstraints { (make) in
            make?.top.leading().equalTo()(self)?.offset()(20)
            make?.size.mas_equalTo()(CGSize(width: 45, height: 45))
        }
        
        titleLabel.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(iconView)
            make?.leading.equalTo()(iconView.mas_trailing)?.offset()(17)
            make?.trailing.equalTo()(self)?.offset()(-80)
        }
        
        closeButton.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(iconView)
            make?.trailing.equalTo()(self)?.offset()(-10)
            make?.size.mas_equalTo()(CGSize(width: 35, height: 35))
        }
        
        descLabel.mas_makeConstraints { (make) in
            make?.leading.equalTo()(self)?.offset()(20)
            make?.trailing.equalTo()(self)?.offset()(-20)
            make?.top.equalTo()(iconView.mas_bottom)?.offset()(16)
        }
        
        tableView.mas_makeConstraints { (make) in
            make?.top.equalTo()(descLabel.mas_bottom)?.offset()(20)
            make?.leading.trailing().equalTo()(descLabel)
            make?.height.mas_equalTo()(50)
        }
        
        cancelButton.mas_makeConstraints { (make) in
            make?.leading.equalTo()(descLabel)
            make?.trailing.equalTo()(self.mas_centerX)?.offset()(-10)
            make?.height.mas_equalTo()(44)
            make?.top.equalTo()(tableView.mas_bottom)?.offset()(20)
            make?.bottom.equalTo()(self)?.offset()(-20)
        }
        
        defineButton.mas_makeConstraints { (make) in
            make?.leading.equalTo()(self.mas_centerX)?.offset()(10)
            make?.trailing.equalTo()(descLabel.mas_trailing)
            make?.height.mas_equalTo()(44)
            make?.centerY.equalTo()(cancelButton)
        }
    }
    
    @objc public func closeAction(sender : UIButton?) {
        if (self.delegate?.responds(to: #selector(STAuthorizationDelegate.didSelectedAuthorization(reslut:appcode:blockchain:wallet:balance:attach:name:))))! {
            let info = wallers.first
            self.delegate?.didSelectedAuthorization(reslut: (sender?.tag == 101 ? true : false), appcode: self.appcode, blockchain: self.blockchain, wallet: info?.contractAddress ?? "", balance: 0, attach: self.attach, name: self.name)
        }
        
    }
}

extension STAuthorization : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wallers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : STAuthorizationCell = tableView.dequeueReusableCell(withIdentifier: STAuthorizationCell.className(), for: indexPath) as! STAuthorizationCell
        cell.info = wallers[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
}
