//
//  NSDate+Extension.m
//  SXTraining
//
//  Created by YY on 2019/11/26.
//  Copyright © 2019 YY. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

//格式转换
+ (NSString *)dateFormatConversion:(NSString *)date withDateFormatter:(NSString*)mat withFormat:(NSString *)str {
    if (mat.length <= 0) {
        mat = @"yyyy-MM-dd HH:mm:ss";
    }
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
    dateFormatter.dateFormat= mat;
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *tempDate = [dateFormatter dateFromString:date];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:str];
    [format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSString *dateString = [format stringFromDate:tempDate];
    return dateString;
    
}

//格式转换(不需要秒)
+ (NSString *)dateNOSecondFormatConversion:(NSString *)date {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
    dateFormatter.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *tempDate = [dateFormatter dateFromString:date];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm"];
    [format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSString *dateString = [format stringFromDate:tempDate];
    return dateString;
    
}

//格式转换(需要秒)
+ (NSString *)dateSecondFormatConversion:(NSString *)date {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
    dateFormatter.dateFormat=@"yyyy-MM-dd HH:mm";
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *tempDate = [dateFormatter dateFromString:date];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSString *dateString = [format stringFromDate:tempDate];
    return dateString;
    
}

+ (NSString *)dateFormatConversion:(NSDate *)date withFormat:(NSString *)text {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:text];
    [format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSInteger interval = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:date];
    NSDate *localeDate = [date dateByAddingTimeInterval:interval];
    NSString *dateString = [format stringFromDate:localeDate];
    return dateString;
    
}

+ (NSInteger)numberOfDaysWithFromDate:(NSDate *)from toDate:(NSDate *)to {

    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    NSDateComponents *comp = [calendar components:NSCalendarUnitHour fromDate:from toDate:to options:NSCalendarWrapComponents];
    
    NSInteger hour = comp.hour;

    return hour;

}

+ (BOOL)verifyWithFromDate:(NSString *)dataStr {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    dateFormatter.dateFormat=@"yyyy-MM-dd";
    NSDate *form = [dateFormatter dateFromString:dataStr];
    BOOL result = [[NSCalendar currentCalendar] isDateInToday:form];
    return result;

}


+ (NSDate *)oss_dateFromString:(NSString *)string {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    return [dateFormatter dateFromString:string];
}

//格式转换
+ (NSDate *)getDateStyle:(NSString *)date {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
    dateFormatter.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *tempDate = [dateFormatter dateFromString:date];
    return tempDate;
}

@end
