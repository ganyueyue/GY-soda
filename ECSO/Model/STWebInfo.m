//
//  STWebInfo.m
//  ECSO
//
//  Created by YY on 2024/5/30.
//

#import "STWebInfo.h"

@implementation STWebInfo
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"title" : @[@"name",@"title"],
             @"url" : @[@"url",@"herf"]
             };
}
@end
