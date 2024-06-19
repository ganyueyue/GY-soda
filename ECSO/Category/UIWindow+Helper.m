//
//  UIWindow+Helper.m
//  lexiwed2
//
//  Created by Kyle on 2017/4/6.
//  Copyright © 2017年 乐喜网. All rights reserved.
//

#import "UIWindow+Helper.h"
#import "UIViewController+Extension.h"

@implementation UIWindow(Helper)

+ (UIViewController*)lx_topMostController
{
    //  getting rootViewController
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;


    UIViewController *topController =  [rootViewController lx_topViewControllerWithRootViewController];
    return topController;
}

@end
