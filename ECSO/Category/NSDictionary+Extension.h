//
//  NSDictionary+Extension.h
//  SXTraining
//
//  Created by YY on 2019/11/26.
//  Copyright © 2019 YY. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (Extension)
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+ (NSDictionary *)jwtDecodeWithJwtString:(NSString *)jwtStr;
@end

NS_ASSUME_NONNULL_END
