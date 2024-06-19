//
//  UIImage+Extension.h
//  lexiwed2
//
//  Created by Kyle on 2017/3/21.
//  Copyright © 2017年 乐喜网. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GradientType) {
    GradientTypeTopToBottom = 0,//从上到下
    GradientTypeLeftToRight = 1,//从左到右
    GradientTypeUpleftToLowright = 2,//左上到右下
    GradientTypeUprightToLowleft = 3,//右上到左下
};

@interface UIImage(Extension)

- (UIImage *)image:(UIImage *)image withColor:(UIColor *)color;
+(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+(UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)resizableImageWithName:(NSString *)imageName;
+ (UIImage *)getScreenShotImageFromVideoPath:(NSString *)filePath;
- (UIImage *)circleImage;

+(UIImage *)getTheLaunchImage;
- (NSData *)compressQualityWithMaxLength:(NSInteger)maxLength;

//类方法  图片 转换为二进制
+(NSData *)imageTransFormData:(UIImage *)image;

+ (UIImage*)gradientImageWithSize:(CGSize)size andColors:(NSArray*)colors;

+(UIImage *)scaledImageFormImage:(UIImage *)image toSize:(CGSize)size;

+ (UIImage *)imageWithRightOrientation:(UIImage *)aImage;

// 通过文字生成图片
+ (UIImage *)imageWithTextStr:(NSString *)string font:(UIFont *)font width:(CGFloat)width textAlignment:(NSTextAlignment)textAlignment;

+ (UIImage *)createQRCodeWithTargetString:(NSString *)targetString;

+ (UIImage *)gradientColorImageFromColors:(NSArray *)colors gradientType:(GradientType)gradientType imgSize:(CGSize)imgSize;

@end
