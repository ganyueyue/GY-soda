//
//  STScanViewController.swift
//  Swim
//
//  Created by YY on 2022/6/1.
//

import UIKit
import AVFoundation

class STScanViewController: LBXScanViewController {
    
    /**
    @brief  扫码区域上方提示文字
    */
    var topTitle: UILabel?
    /**
     @brief  闪关灯开启状态
     */
    var isOpenedFlash: Bool = false

// MARK: - 底部几个功能：开启闪光灯、相册

    //底部显示的功能项
    var bottomItemsView: UIView?

    //相册
    var btnPhoto: UIButton = UIButton()

    //闪光灯
    var btnFlash: UIButton = UIButton()
    
    
    var navView:STCustomNavView = STCustomNavView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navView.frame = CGRectMake(0, 0, UIScreen.main.bounds.width, CGFloat(STAppEnvs.shareInstance().statusBarHeight) + 50)
        navView.titleLabel.text = "扫一扫"
        navView.saveBtn.setTitle("相册", for: .normal)
        navView.backgroundColor = .white
        self.view.addSubview(navView)
        
        weak var weakSelf = self
        navView.clickBlock = { (index: Int) in
            if (index == 0) {
                weakSelf?.navigationController?.popViewController(animated: true)
            } else {
                weakSelf?.openPhotoAlbum()
            }
        }
        
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if status == AVAuthorizationStatus.restricted || status == AVAuthorizationStatus.denied {
            NoticeHelp.showChoiceAlert(in: self, title: "无法使用相机", message: "请在iPhone的\"设置-隐私-相机\"中允许访问相机") {(buttonIndex) in
                if buttonIndex == 1 {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                }
            }
            return;
        }else{
            //需要识别后的图像
            setNeedCodeImage(needCodeImg: true)

            //框向上移动10个像素
            scanStyle?.centerUpOffset += 10
            
            scanStyle?.animationImage = UIImage(named: "qrcode_scan_light_green")

            // Do any additional setup after loading the view.
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)

//        drawBottomItems()
    }

    override func handleCodeResult(arrayResult: [LBXScanResult]) {

        for result: LBXScanResult in arrayResult {
            if let str = result.strScanned {
                print(str)
            }
        }

        let result: LBXScanResult = arrayResult[0]
        guard let string = result.strScanned else {
            return
        }
        let vc = STWebViewController()
        vc.urlString = string
        self.navigationController?.pushViewController(vc, animated: true,completion: {
            var controllers : [UIViewController] = NSMutableArray() as! [UIViewController]
            let list : [UIViewController] = self.navigationController!.viewControllers
            for(_, element) in list.enumerated() {
                if (element != self) {
                    controllers.append(element)
                }
            }
            self.navigationController?.viewControllers = controllers
        })
    }

    func drawBottomItems() {
        if (bottomItemsView != nil) {
            return
        }

        let yMax = self.view.frame.maxY - self.view.frame.minY

        bottomItemsView = UIView(frame: CGRect(x: 0.0, y: yMax-100, width: self.view.frame.size.width, height: 100 ) )

        bottomItemsView!.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)

        self.view .addSubview(bottomItemsView!)

        let size = CGSize(width: 65, height: 87)

        self.btnFlash = UIButton()
        btnFlash.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        btnFlash.center = CGPoint(x: bottomItemsView!.frame.width/2 + 70, y: bottomItemsView!.frame.height/2)

        btnFlash.setImage(UIImage(named: "qrcode_scan_btn_flash_nor"), for:UIControl.State.normal)
        btnFlash.addTarget(self, action: #selector(openOrCloseFlash), for: UIControl.Event.touchUpInside)
        

        self.btnPhoto = UIButton()
        btnPhoto.bounds = btnFlash.bounds
        btnPhoto.center = CGPoint(x: bottomItemsView!.frame.width/2 - 70, y: bottomItemsView!.frame.height/2)
        btnPhoto.setImage(UIImage(named: "qrcode_scan_btn_photo_nor"), for: UIControl.State.normal)
        btnPhoto.setImage(UIImage(named: "qrcode_scan_btn_photo_down"), for: UIControl.State.highlighted)
        btnPhoto.addTarget(self, action: #selector(openPhotoAlbum), for: UIControl.Event.touchUpInside)

        bottomItemsView?.addSubview(btnFlash)
        bottomItemsView?.addSubview(btnPhoto)

        view.addSubview(bottomItemsView!)
    }
    
    //开关闪光灯
    @objc func openOrCloseFlash() {
        scanObj?.changeTorch()

        isOpenedFlash = !isOpenedFlash
        
        if isOpenedFlash
        {
            btnFlash.setImage(UIImage(named: "qrcode_scan_btn_flash_down"), for:UIControl.State.normal)
        }
        else
        {
            btnFlash.setImage(UIImage(named: "qrcode_scan_btn_flash_nor"), for:UIControl.State.normal)

        }
    
    }

}
