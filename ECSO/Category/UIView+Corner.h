//
//  UIView+Corner.h
//  eShop
//
//  Created by Kyle on 14/11/3.
//  Copyright (c) 2014年 yujiahui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SMBSide) {
    kSMBSideLeft,
    kSMBSideRight,
    kSMBSideUp,
    kSMBSideBottom,
};
typedef NS_OPTIONS(NSUInteger, BNShadowSide) {
    BNShadowSideNone   = 0,
    BNShadowSideTop    = 1 << 0,
    BNShadowSideLeft   = 1 << 1,
    BNShadowSideBottom = 1 << 2,
    BNShadowSideRight  = 1 << 3,
    BNShadowSideAll    = BNShadowSideTop | BNShadowSideLeft | BNShadowSideBottom | BNShadowSideRight
};

@interface UIView(Corner)


/// 使用位枚举指定圆角位置
/// 通过在各个边画矩形来实现shadowpath，真正实现指那儿打那儿
/// @param shadowColor 阴影颜色
/// @param shadowOpacity 阴影透明度
/// @param shadowRadius 阴影半径
/// @param shadowSide 阴影位置
-(void)addShdowColor:(UIColor *)shadowColor
       shadowOpacity:(CGFloat)shadowOpacity
        shadowRadius:(CGFloat)shadowRadius
          shadowSide:(BNShadowSide)shadowSide;

- (void)setCornerOnLeftTopRightBottomRadius:(CGFloat)radius;


- (void)setCornerOnTopRadius:(CGFloat)radius;

- (void)setCornerOnBottomRadius:(CGFloat)radius;

- (void)setCornerOnRightRadius:(CGFloat)radius;

- (void)setAllCornerRadius:(CGFloat)radius;

- (void)setSelfLayerCornerRadius:(CGFloat)radius;

- (void)setLayerWithCornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

- (void)setNoneCorner;

- (void)roundSide:(SMBSide)side cornerRadius:(CGFloat)radius;

@end
