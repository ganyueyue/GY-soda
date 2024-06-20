//
//  NoticeHelp.m
//  eShop
//
//  Created by Kyle on 14/10/22.
//  Copyright (c) 2014年 yujiahui. All rights reserved.
//

#import "NoticeHelp.h"
#import "ECSO-Swift.h"
#import "UIWindow+Helper.h"

#define kErrMsgKey @"msg"

static NSInteger const ESAlertControllerBlocksCancelButtonIndex = 0;
static NSInteger const ESAlertControllerBlocksDestructiveButtonIndex = 1;
static NSInteger const ESAlertControllerBlocksFirstOtherButtonIndex = 2;

@implementation NoticeHelp

+ (id)showChoiceAlertInViewController:(UIViewController *)viewController
                              message:(NSString *)message
                             tapBlock:(void (^)(NSInteger buttonIndex))tapBlock{
    return  [NoticeHelp showAlertInViewController:viewController withIcon:@"" withTitle:@"提示".string message:message cancelButtonTitle:@"取消".string destructiveButtonTitle:@"确定".string tapBlock:tapBlock];
}

+ (id)showChoiceAlertInViewController:(UIViewController *)viewController
                                title:(NSString *)title
                                message:(NSString *)message
                               tapBlock:(void (^)(NSInteger buttonIndex))tapBlock
{
   return  [NoticeHelp showAlertInViewController:viewController withIcon:@"" withTitle:title message:message cancelButtonTitle:@"取消".string destructiveButtonTitle:@"确定".string tapBlock:tapBlock];
}


+ (id)showSureAlertInViewController:(UIViewController *)viewController
                            message:(NSString *)message
{
    return  [NoticeHelp showSureAlertInViewController:viewController title:@"提示".string message:message tapBlock:nil];
}

+ (id)showSureAlertInViewController:(UIViewController *)viewController
                              title:(NSString *)title
                            message:(NSString *)message
                           tapBlock:(void (^)(NSInteger buttonIndex))tapBlock
{
    return  [self showAlertInViewController:viewController withIcon:@"" withTitle:title message:message cancelButtonTitle:nil destructiveButtonTitle:@"确定".string tapBlock:tapBlock];
}



+ (id)showAlertInViewController:(UIViewController *)viewController
                       withIcon:(NSString *)icon
                        withTitle:(NSString *)title
                          message:(NSString *)message
                cancelButtonTitle:(NSString *)cancelButtonTitle
           destructiveButtonTitle:(NSString *)destructiveButtonTitle
                         tapBlock:(void (^)(NSInteger buttonIndex))tapBlock
{

    KYAlertViewController *alert = [[KYAlertViewController alloc] initWithTitle:title message:message icon:icon transitionStyle:KYPopupViewTransitionStyleZoomIn gestureDismissal:false completion:^{

    }];

    CGFloat index = 0;

    NSString *cancelString = cancelButtonTitle;
    NSString *destructiveString = destructiveButtonTitle;

    if (destructiveButtonTitle == nil){
        destructiveString = cancelButtonTitle;
        cancelString = nil;
    }


    if (cancelString != nil){

        [alert addButton:[[KYPopupButton alloc] initWithTitle:cancelButtonTitle height:34 dismissOnTap:true action:^{
            if (tapBlock != nil){
                tapBlock(index);
            }
        }]];
        index = index + 1;
    }

    if (destructiveString != nil){

        [alert addButton:[[KYPopupDestructiveButton alloc] initWithTitle:destructiveButtonTitle height:34 dismissOnTap:true action:^{
            if (tapBlock != nil){
                tapBlock(index);
            }
        }]];
        index = index + 1;
    }

    [alert bePresentedWithViewcontroller:viewController animated:true completion:^{

    }];

    return alert;
}

+ (id)showAlertInViewController:(UIViewController *)viewController
                        withTitle:(NSString *)title
                          message:(NSString *)message
                          style:(NSInteger)style
                cancelButtonTitle:(NSString *)cancelButtonTitle
           destructiveButtonTitle:(NSString *)destructiveButtonTitle
                         tapBlock:(void (^)(NSInteger buttonIndex))tapBlock
{

    STAlertViewController *alert = [[STAlertViewController alloc] initWithTitle:title message:message style:style transitionStyle:KYPopupViewTransitionStyleZoomIn gestureDismissal:false completion:^{

    }];
    
    CGFloat index = 0;

    NSString *cancelString = cancelButtonTitle;
    NSString *destructiveString = destructiveButtonTitle;

    if (destructiveButtonTitle == nil){
        destructiveString = cancelButtonTitle;
        cancelString = nil;
    }


    if (cancelString != nil){

        [alert addButton:[[KYPopupButton alloc] initWithTitle:cancelButtonTitle height:38 dismissOnTap:true action:^{
            if (tapBlock != nil){
                tapBlock(index);
            }
        }]];
        index = index + 1;
    }

    if (destructiveString != nil){

        [alert addButton:[[KYPopupDestructiveButton alloc] initWithTitle:destructiveButtonTitle height:38 dismissOnTap:true action:^{
            if (tapBlock != nil){
                tapBlock(index);
            }
        }]];
        index = index + 1;
    }

    [alert bePresentedWithViewcontroller:viewController animated:true completion:^{

    }];

    return alert;
}


+(id)showCustomPopViewController:(KYBaseContentView *)contentView complete:(void (^)())tapBlock {
    KYCustomPopViewController *alert = [[KYCustomPopViewController alloc] initWithContentView:contentView transitionStyle:KYPopupViewTransitionStyleSheet gestureDismissal:false offset:false completion:^{
    }];

    [alert bePresentedWithViewcontroller:nil animated:true completion:^{
        if (tapBlock){
            tapBlock();
        }
    }];
    return alert;

}

+(id)showCustomPopViewController:(KYBaseContentView *)contentView withGestureDismissal:(BOOL)gestureDismissal complete:(void (^)())tapBlock {
    KYCustomPopViewController *alert = [[KYCustomPopViewController alloc] initWithContentView:contentView transitionStyle:KYPopupViewTransitionStyleSheet gestureDismissal:gestureDismissal offset:true completion:^{
    }];

    [alert bePresentedWithViewcontroller:nil animated:true completion:^{
        if (tapBlock){
            tapBlock();
        }
    }];
    return alert;

}

+(id)showCustomPopViewController:(KYBaseContentView *)contentView withController:(UIViewController *)controller complete:(void (^)())tapBlock {
    KYCustomPopViewController *alert = [[KYCustomPopViewController alloc] initWithContentView:contentView transitionStyle:KYPopupViewTransitionStyleZoomIn gestureDismissal:false offset:false completion:^{
    }];
    
    [alert bePresentedWithViewcontroller:controller animated:true completion:^{
        if (tapBlock){
            tapBlock();
        }
    }];
    return alert;
    
}
+(id)showCustomPopViewController:(KYBaseContentView *)contentView duration:(NSTimeInterval)time  complete:(void (^)())tapBlock {
    KYCustomPopViewController *alert = [[KYCustomPopViewController alloc] initWithContentView:contentView transitionStyle:KYPopupViewTransitionStyleZoomIn gestureDismissal:false offset:false completion:^{
    }];
    alert.timeDuration = time;
    alert.dismissCompletion = ^{
        if (tapBlock != nil){
            tapBlock();
        }
    };
    [alert bePresentedWithViewcontroller:nil animated:true completion:^{
    }];
    return alert;

}


+(id)showActionSheetViewControllerTitle:(NSString *)title customView:(UIView *)contentView duration:(NSTimeInterval)time buttonTitles:(NSArray *)otherButtonTitles
                               tapBlock:(void (^)(NSInteger buttonIndex))tapBlock  complete:(void (^)())complete {

    KYActionSheetViewController *actionSheet = [[KYActionSheetViewController alloc] initWithTitle:title customView:contentView transitionStyle:KYPopupViewTransitionStyleSheet gestureDismissal:true completion:^{

    }];

    CGFloat index = 0;

    for (NSString *string in otherButtonTitles) {

        [actionSheet addButton:[[KYPopupActionButton alloc] initWithTitle:string height:55 dismissOnTap:true action:^{
            if (tapBlock != nil){
                tapBlock(index);
            }
        }]];
        index = index + 1;
    }

    [actionSheet bePresentedWithViewcontroller:nil animated:true completion:^{

    }];


    return actionSheet;

}

+(id)showActionSheetViewControllerTwoLinesTitle:(NSString *)title customView:(UIView *)contentView duration:(NSTimeInterval)time twoLineTitles:(NSArray *)twoLines buttonTitles:(NSArray *)otherButtonTitles
                               tapBlock:(void (^)(NSInteger buttonIndex))tapBlock  complete:(void (^)())complete {
    
    KYActionSheetViewController *actionSheet = [[KYActionSheetViewController alloc] initWithTitle:title customView:contentView transitionStyle:KYPopupViewTransitionStyleSheet gestureDismissal:true completion:^{
        
    }];
    
    CGFloat index = 0;
    
    if (twoLines.count != 0) {
        [actionSheet addButton:[[KYPopupTwoLineButton alloc]initWithTopLabelStr:twoLines.firstObject bottomLabelStr:twoLines.lastObject action:^{
            if (tapBlock != nil){
                tapBlock(index);
            }
        }]];
        index = index + 1;
    }
    
    for (NSString *string in otherButtonTitles) {
        
        [actionSheet addButton:[[KYPopupActionButton alloc] initWithTitle:string height:55 dismissOnTap:true action:^{
            if (tapBlock != nil){
                tapBlock(index);
            }
        }]];
        index = index + 1;
    }
    
    [actionSheet bePresentedWithViewcontroller:nil animated:true completion:^{
        
    }];
    
    
    return actionSheet;
    
}


#pragma mark - LXAlertViewController

+ (id)showStyleChoiceAlertInViewController:(UIViewController *)viewController
                                title:(NSString *)title
                              message:(NSString *)message
                             tapBlock:(void (^)(NSInteger buttonIndex))tapBlock
{
    return  [NoticeHelp showStyleAlertInViewController:viewController withTitle:title message:message cancelButtonTitle:@"取消".string destructiveButtonTitle:@"确定".string tapBlock:tapBlock];
}

+ (id)showStyleAlertInViewController:(UIViewController *)viewController
                      withTitle:(NSString *)title
                        message:(NSString *)message
              cancelButtonTitle:(NSString *)cancelButtonTitle
         destructiveButtonTitle:(NSString *)destructiveButtonTitle
                       tapBlock:(void (^)(NSInteger buttonIndex))tapBlock
{
    
    LXAlertViewController *alert = [[LXAlertViewController alloc] initWithTitle:title message:message transitionStyle:KYPopupViewTransitionStyleZoomIn gestureDismissal:false completion:^{
        
    }];
    
    CGFloat index = 0;
    
    NSString *cancelString = cancelButtonTitle;
    NSString *destructiveString = destructiveButtonTitle;
    
    if (destructiveButtonTitle == nil){
        destructiveString = cancelButtonTitle;
        cancelString = nil;
    }
    
    
    if (cancelString != nil){
        
        [alert addButton:[[LXPopupCancelButton alloc] initWithTitle:cancelButtonTitle height:27 dismissOnTap:true action:^{
            if (tapBlock != nil){
                tapBlock(index);
            }
        }]];
        index = index + 1;
    }
    
    if (destructiveString != nil){
        
        [alert addButton:[[LXPopupDestructiveButton alloc] initWithTitle:destructiveString height:27 dismissOnTap:true action:^{
            if (tapBlock != nil){
                tapBlock(index);
            }
        }]];
        index = index + 1;
    }
    
    [alert bePresentedWithViewcontroller:viewController animated:true completion:^{
        
    }];
    
    return alert;
}


+ (id)showStyleSureAlertInViewController:(UIViewController *)viewController
                                   title:(NSString *)title
                                 message:(NSString *)message
{
    return  [NoticeHelp showStyleSureAlertInViewController:viewController title:title message:message tapBlock:nil];
}

+ (id)showStyleSureAlertInViewController:(UIViewController *)viewController
                              title:(NSString *)title
                            message:(NSString *)message
                           tapBlock:(void (^)(NSInteger buttonIndex))tapBlock
{
    return  [self showStyleAlertInViewController:viewController withTitle:title message:message cancelButtonTitle:nil destructiveButtonTitle:@"确定" tapBlock:tapBlock];
}
@end
