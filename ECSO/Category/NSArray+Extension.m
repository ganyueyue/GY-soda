//
//  NSArray+Extension.m
//  SXTraining
//
//  Created by YY on 2020/2/16.
//  Copyright © 2020 YY. All rights reserved.
//

#import "NSArray+Extension.h"

@implementation NSArray (Extension)

#pragma mark - set方法
+ (void)removeRepeatWithNSSetFunc:(NSArray *)array {
    NSMutableSet *set = [NSMutableSet set];
    for (NSString *str in array) {
        [set addObject:str];
    }
}

@end
