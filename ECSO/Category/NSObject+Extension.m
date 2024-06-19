//
//  NSObject+Extension.m
//  SXTraining
//
//  Created by YY on 2019/11/15.
//  Copyright © 2019 YY. All rights reserved.
//

#import "NSObject+Extension.h"

@implementation NSObject (Extension)

+ (NSString*)className {
    return NSStringFromClass([self class]);
}

@end
