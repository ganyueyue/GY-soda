//
//  UIView+Corner.m
//  eShop
//
//  Created by Kyle on 14/11/3.
//  Copyright (c) 2014年 yujiahui. All rights reserved.
//

#import "UIView+Corner.h"

@implementation UIView(Corner)


-(void)addShdowColor:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius shadowSide:(BNShadowSide)shadowSide{
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = shadowColor.CGColor;
    self.layer.shadowRadius = shadowRadius;
    self.layer.shadowOpacity = shadowOpacity;
    
    // 默认值 0 -3
    // 使用默认值即可，这个各个边都要设置阴影的，自己调反而效果不是很好。
    //    self.layer.shadowOffset = CGSizeMake(0, -3);
    
    CGRect bounds = self.layer.bounds;
    CGFloat maxX = CGRectGetMaxX(bounds);
    CGFloat maxY = CGRectGetMaxY(bounds);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    if (shadowSide & BNShadowSideTop) {
        // 上边
        [path moveToPoint:CGPointZero];
        [path addLineToPoint:CGPointMake(0, -shadowRadius)];
        [path addLineToPoint:CGPointMake(maxX, -shadowRadius)];
        [path addLineToPoint:CGPointMake(maxX, 0)];
    }
    
    if (shadowSide & BNShadowSideRight) {
        // 右边
        [path moveToPoint:CGPointMake(maxX, 0)];
        [path addLineToPoint:CGPointMake(maxX,maxY)];
        [path addLineToPoint:CGPointMake(maxX + shadowRadius, maxY)];
        [path addLineToPoint:CGPointMake(maxX + shadowRadius, 0)];
    }
    
    if (shadowSide & BNShadowSideBottom) {
        // 下边
        [path moveToPoint:CGPointMake(0, maxY)];
        [path addLineToPoint:CGPointMake(maxX,maxY)];
        [path addLineToPoint:CGPointMake(maxX, maxY + shadowRadius)];
        [path addLineToPoint:CGPointMake(0, maxY + shadowRadius)];
    }
    
    if (shadowSide & BNShadowSideLeft) {
        // 左边
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(-shadowRadius,0)];
        [path addLineToPoint:CGPointMake(-shadowRadius, maxY)];
        [path addLineToPoint:CGPointMake(0, maxY)];
    }
    
    self.layer.shadowPath = path.CGPath;
}

- (void)setCornerOnLeftTopRightBottomRadius:(CGFloat)radius {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomRight)
                                           cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
}


- (void)setCornerOnTopRadius:(CGFloat)radius{
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                           cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)setCornerOnBottomRadius:(CGFloat)radius {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                           cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
}

- (void)setCornerOnRightRadius:(CGFloat)radius {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight)
                                           cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
}

- (void)setAllCornerRadius:(CGFloat)radius {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                          cornerRadius:radius];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;

}

- (void)setSelfLayerCornerRadius:(CGFloat)radius
{
    self.layer.cornerRadius = radius;
    self.clipsToBounds = TRUE;
}


- (void)setLayerWithCornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    self.layer.cornerRadius = radius;
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = borderColor.CGColor;
    self.clipsToBounds = TRUE;
    
}


- (void)setNoneCorner{
    self.layer.mask = nil;
}

- (void)roundSide:(SMBSide)side cornerRadius:(CGFloat)radius
{
    UIBezierPath *maskPath;
    
    if (side == kSMBSideLeft)
        maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                         byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerBottomLeft)
                                               cornerRadii:CGSizeMake(radius, radius)];
    else if (side == kSMBSideRight)
        maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                         byRoundingCorners:(UIRectCornerTopRight|UIRectCornerBottomRight)
                                               cornerRadii:CGSizeMake(radius, radius)];
    else if (side == kSMBSideUp)
        maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                         byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
                                               cornerRadii:CGSizeMake(radius, radius)];
    else
        maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                         byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight)
                                               cornerRadii:CGSizeMake(radius, radius)];
    
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    
    // Set the newly created shape layer as the mask for the image view's layer
    self.layer.mask = maskLayer;
    
    [self.layer setMasksToBounds:YES];
}

@end
