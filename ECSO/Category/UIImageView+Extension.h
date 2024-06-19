//
//  UIImageView+Extension.h
//  SXTraining
//
//  Created by YY on 2019/11/26.
//  Copyright © 2019 YY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (Extension)
-(void)sx_setImagePlaceholdWithURL:(NSString *)urlString;
- (void)sx_setImagePlaceholdWithURL:(NSString *)urlString placeholderImage:(UIImage *)placeImage;
@end

NS_ASSUME_NONNULL_END
