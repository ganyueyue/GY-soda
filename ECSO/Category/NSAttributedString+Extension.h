//
//  NSAttributedString+Extension.h
//  Swim
//
//  Created by YY on 2022/3/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (Extension)
// 实现图文混排的方法
+ (NSAttributedString *) creatAttrStringWithText:(NSString *) text withColor:(UIColor *)color image:(UIImage *) image;

+ (NSAttributedString *) creatAttrStringWithPag:(NSString *)pag withText:(NSString *)text withColor:(UIColor *)color image:(UIImage *) image;

@end

NS_ASSUME_NONNULL_END
