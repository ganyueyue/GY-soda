//
//  NoticeHelp.h
//  eShop
//
//  Created by Kyle on 14/10/22.
//  Copyright (c) 2014年 yujiahui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIAlertController+Blocks.h"
#import "UIAlertView+Blocks.h"

@class KYBaseContentView;

@interface NoticeHelp : NSObject

+ (id)showChoiceAlertInViewController:(UIViewController *)viewController
                                title:(NSString *)title
                              message:(NSString *)message
                             tapBlock:(void (^)(NSInteger buttonIndex))tapBlock;

+ (id)showSureAlertInViewController:(UIViewController *)viewController
                            message:(NSString *)message;

+ (id)showSureAlertInViewController:(UIViewController *)viewController
                              title:(NSString *)title
                            message:(NSString *)message
                           tapBlock:(void (^)(NSInteger buttonIndex))tapBlock;

+ (id)showAlertInViewController:(UIViewController *)viewController
                        withTitle:(NSString *)title
                          message:(NSString *)message
                          style:(NSInteger)style
                cancelButtonTitle:(NSString *)cancelButtonTitle
           destructiveButtonTitle:(NSString *)destructiveButtonTitle
                         tapBlock:(void (^)(NSInteger buttonIndex))tapBlock;

+ (id)showAlertInViewController:(UIViewController *)viewController
                       withIcon:(NSString *)icon
                      withTitle:(NSString *)title
                        message:(NSString *)message
              cancelButtonTitle:(NSString *)cancelButtonTitle
         destructiveButtonTitle:(NSString *)destructiveButtonTitle
                       tapBlock:(void (^)(NSInteger buttonIndex))tapBlock;


+(id)showCustomPopViewController:(KYBaseContentView *)contentView complete:(void (^)())tapBlock;
+(id)showCustomPopViewController:(KYBaseContentView *)contentView withGestureDismissal:(BOOL)gestureDismissal complete:(void (^)())tapBlock;
+(id)showCustomPopViewController:(KYBaseContentView *)contentView withController:(UIViewController *)controller complete:(void (^)())tapBlock;
+(id)showCustomPopViewController:(KYBaseContentView *)contentView duration:(NSTimeInterval)time  complete:(void (^)())tapBlock;

+(id)showActionSheetViewControllerTitle:(NSString *)title customView:(UIView *)contentView duration:(NSTimeInterval)time buttonTitles:(NSArray *)otherButtonTitles
                               tapBlock:(void (^)(NSInteger buttonIndex))tapBlock  complete:(void (^)())complete;

+(id)showActionSheetViewControllerTwoLinesTitle:(NSString *)title customView:(UIView *)contentView duration:(NSTimeInterval)time twoLineTitles:(NSArray *)twoLines buttonTitles:(NSArray *)otherButtonTitles
                                       tapBlock:(void (^)(NSInteger buttonIndex))tapBlock  complete:(void (^)())complete;

+ (id)showStyleChoiceAlertInViewController:(UIViewController *)viewController
                                     title:(NSString *)title
                                   message:(NSString *)message
                                  tapBlock:(void (^)(NSInteger buttonIndex))tapBlock;

+ (id)showStyleAlertInViewController:(UIViewController *)viewController
                           withTitle:(NSString *)title
                             message:(NSString *)message
                   cancelButtonTitle:(NSString *)cancelButtonTitle
              destructiveButtonTitle:(NSString *)destructiveButtonTitle
                            tapBlock:(void (^)(NSInteger buttonIndex))tapBlock;


+ (id)showStyleSureAlertInViewController:(UIViewController *)viewController
                                   title:(NSString *)title
                                 message:(NSString *)message;
@end
