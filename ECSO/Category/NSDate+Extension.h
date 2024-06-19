//
//  NSDate+Extension.h
//  SXTraining
//
//  Created by YY on 2019/11/26.
//  Copyright © 2019 YY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Extension)

+ (NSString *)dateFormatConversion:(NSString *)date withDateFormatter:(NSString*)mat withFormat:(NSString *)str;

//格式转换(不需要秒)
+ (NSString *)dateNOSecondFormatConversion:(NSString *)date;

//格式转换(需要秒)
+ (NSString *)dateSecondFormatConversion:(NSString *)date;

+ (NSInteger)numberOfDaysWithFromDate:(NSDate *)from toDate:(NSDate *)to;

+ (BOOL)verifyWithFromDate:(NSString *)dataStr ;

//格式转换
+ (NSDate *)getDateStyle:(NSString *)date;

+ (NSString *)dateFormatConversion:(NSDate *)date withFormat:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
