//
//  STFont.m
//  Swim
//
//  Created by YY on 2022/3/10.
//

#import "STFont.h"

@implementation STFont

+ (UIFont *)fontSize:(CGFloat)size {
    
    return [self fontStatus:regular fontSize:size];
}

+ (UIFont *)fontStatus:(SSFontType)status fontSize:(CGFloat)size {
    
    if (status == medium) {
        return [UIFont fontWithName:@"PingFangSC-Medium" size:size];
    } else if (status == light) {
        return [UIFont fontWithName:@"PingFangSC-Light" size:size];
    } else if (status == semibold) {
        return [UIFont fontWithName:@"PingFangSC-Semibold" size:size];
    } else if (status == black) {
        return [UIFont fontWithName:@"PingFangSC-Black" size:size];
    }
    return [UIFont fontWithName:@"PingFangSC-Regular" size:size];
}

@end
