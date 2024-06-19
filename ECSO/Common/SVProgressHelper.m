//
//  SVProgressHelper.m
//  eShop
//
//  Created by Kyle on 15/1/5.
//  Copyright (c) 2015年 yujiahui. All rights reserved.
//

#import "SVProgressHelper.h"
#import "NoticeHelp.h"
#import "ECSO-Swift.h"

@implementation SVProgressHelper


#pragma mark
#pragma mark SVProgressHUD method
+ (void)showHUD
{
    [SVProgressHUD showProgress:-1 status:nil];
}
+ (void)showHUDWithStatus:(NSString *)msg
{
    [SVProgressHUD showProgress:-1 status:msg];
}

+ (void)showAllHUDStatus:(NSString *)msg{
//    [SVProgressHUD showProgress:-1 status:msg maskType:SVProgressHUDMaskTypeClear];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showProgress:-1 status:msg];
}

+ (void)showAllHUDNotClick{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD show];
}

+ (void)showHUDImage:(UIImage *)image status:(NSString *)msg
{
    [SVProgressHUD showImage:image status:msg];
}

+ (void)dismissHUD
{
    [SVProgressHUD dismiss];
}

+ (void)dismissWithMsg:(NSString *)msg
{
    if (msg == nil || [msg isKindOfClass:[NSNull class]]) {
        return;
    }
    if ([msg isEqualToString:@"The Internet connection appears to be offline."] || [msg isEqualToString:@"似乎已断开与互联网的连接。"]) {
        msg = @"网络异常，请稍后重试";
    }
    [SVProgressHUD setMinimumDismissTimeInterval:0.5];
    [SVProgressHUD setBackgroundColor:HexRGBA(0x000000, 0.49)];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setBackgroundLayerColor:HexRGBA(0x000000, 0.49)];
    [SVProgressHUD setCornerRadius:4];
    [self dismissWithImage:nil msg:msg];
}


+ (void)dismissWithImage:(UIImage *)image msg:(NSString *)msg
{
    
    [SVProgressHUD showImage:image status:msg];
}

+ (void)dismissHUDSuccess:(NSString *)msg
{
    [SVProgressHUD showSuccessWithStatus:msg];
}
+ (void)dismissHUDError:(NSString *)msg
{
    [SVProgressHUD setMinimumDismissTimeInterval:0.5];
    [SVProgressHUD setBackgroundColor:HexRGBA(0x000000, 0.49)];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setCornerRadius:4];
    [SVProgressHUD showErrorWithStatus:msg];
}

+(void)setHUDTitleFont:(UIFont *)font TitleColor:(UIColor *)titleColor backGroundColor:(UIColor *)backGroundColor{
   
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    if (font != nil) {
        [SVProgressHUD setFont:font];
    }
    if (titleColor != nil) {
        [SVProgressHUD setForegroundColor:titleColor];
    }
    if (titleColor != nil) {
        [SVProgressHUD setBackgroundColor:backGroundColor];
    }
    
}

+ (void)dismissWithCustomMessage:(NSString *)msg{
    [self customDismiss:true message:msg];
}

+(void)customDismiss:(BOOL)isCorrect message:(NSString *)msg{
    [self customDismiss:isCorrect message:msg complete:nil];
}

+(void)customDismiss:(BOOL)isCorrect message:(NSString *)msg complete:(void (^)(void))complete{
    [SVProgressHUD dismiss];
    
    UIImage *image = nil;
    if(isCorrect){
        image = [UIImage imageNamed:@"common_success"];
    }else{
        image = [UIImage imageNamed:@"common_success"];;
    }
    
    SXMessageHUDView *hud = [[SXMessageHUDView alloc] initWithImage:image message:msg];
    [NoticeHelp showCustomPopViewController:hud duration:1.0 complete:^{
        if (complete != nil){
            complete();
        }
    }];
    
}



@end
