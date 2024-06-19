//
//  STShare.m
//  Swim
//
//  Created by YY on 2022/3/14.
//

#import "STShare.h"

@implementation STSharePlatform

+ (STSharePlatform *)createShareName:(NSString *)name withShareIcon:(NSString *)icon withScheme:(NSString *)scheme {
    STSharePlatform *info = [[STSharePlatform alloc]init];
    info.name = name;
    info.icon = icon;
    info.scheme = scheme;
    return info;
}

@end

@implementation STShareInfo

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"desc" : @"description"
             };
}

@end

@implementation STShare

+ (NSDictionary *)mj_objectClassInArray {
    
// 表明你products数组存放的将是FKGoodsModelInOrder类的模型
    return @{
             @"list" : @"STSharePlatform"
             };
}



@end
