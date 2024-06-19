//
//  STMainTabbarController.h
//  SXTraining
//
//  Created by YY on 2019/11/15.
//  Copyright © 2019 YY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface STMainTabbarController : UITabBarController

+ (instancetype) shareInstance;

- (void)createSubViewControllers;

@end

NS_ASSUME_NONNULL_END
