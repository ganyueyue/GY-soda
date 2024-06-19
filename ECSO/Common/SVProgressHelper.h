//
//  SVProgressHelper.h
//  eShop
//
//  Created by Kyle on 15/1/5.
//  Copyright (c) 2015年 yujiahui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SVProgressHUD/SVProgressHUD.h>
@interface SVProgressHelper : NSObject

+ (void)showHUD;
+ (void)showHUDWithStatus:(NSString *)msg;
+ (void)showAllHUDStatus:(NSString *)msg;
+ (void)showHUDImage:(UIImage *)image status:(NSString *)msg;
+ (void)showAllHUDNotClick;

+ (void)dismissHUD;
+ (void)dismissWithMsg:(NSString *)msg;
+ (void)dismissWithImage:(UIImage *)image msg:(NSString *)msg;
+ (void)dismissHUDSuccess:(NSString *)msg;
+ (void)dismissHUDError:(NSString *)msg;

+(void)setHUDTitleFont:(UIFont *)font TitleColor:(UIColor *)titleColor backGroundColor:(UIColor *)backGroundColor;
+ (void)dismissWithCustomMessage:(NSString *)msg;
+(void)customDismiss:(BOOL)isCorrect message:(NSString *)msg;
+(void)customDismiss:(BOOL)isCorrect message:(NSString *)msg complete:(void (^)(void))complete;
@end
