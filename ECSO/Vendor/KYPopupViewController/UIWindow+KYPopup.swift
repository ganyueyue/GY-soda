//
//  UIWindow+KYPopup.swift
//  Pods
//
//  Created by Kyle on 2017/8/29.
//
//

import UIKit


public extension UIWindow{

    public func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(vc: rootViewController)
        }
        return nil
    }

    public class func getVisibleViewControllerFrom(vc:UIViewController) -> UIViewController {

        if let navigationController = vc as? UINavigationController{
            let subViewController = navigationController.viewControllers
            let viewcontroller = subViewController.last!
            return UIWindow.getVisibleViewControllerFrom( vc: viewcontroller)
        }else if let tabBarController = vc as? UITabBarController{
            return UIWindow.getVisibleViewControllerFrom(vc: tabBarController.selectedViewController!)
        }else if let presentedViewController = vc.presentedViewController {
            return UIWindow.getVisibleViewControllerFrom(vc: presentedViewController)
        }else{
            return vc
        }
    }


    public class func topViewController()->UIViewController?{
        guard let windows = UIApplication.shared.keyWindow else{
            return nil;
        }
        return windows.visibleViewController()

    }

}
