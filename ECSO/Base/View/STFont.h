//
//  STFont.h
//  Swim
//
//  Created by YY on 2022/3/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    regular,
    medium,
    light,
    black,
    semibold
} SSFontType;

@interface STFont : NSObject

+ (UIFont *)fontSize:(CGFloat)size;

+ (UIFont *)fontStatus:(SSFontType)status fontSize:(CGFloat)size;

@end

NS_ASSUME_NONNULL_END
