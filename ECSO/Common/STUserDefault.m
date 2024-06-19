//
//  STUserDefault.m
//  Swim
//
//  Created by YY on 2022/3/10.
//

#import "STUserDefault.h"

@implementation STUserDefault

+(NSInteger)integerValueForKey:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}
+(void)setintegerValue:(NSInteger)value forKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(double)doubleValueForKey:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:key];
}
+(void)setDoubleValue:(double)value forKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setDouble:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(CGFloat)floatValueForKey:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults] floatForKey:key];
}
+(void)setFloatVaule:(CGFloat)value forKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setFloat:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)BoolValueForKey:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
    
}
+(void)setBoolVaule:(BOOL)value forKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+(id)objectValueForKey:(NSString *)key{
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (value == nil){
        return @"";
    }
    return value;
}
+(void)setObjectValue:(id)value forKey:(NSString *)key{
    if (!key) {
        return;
    }
    if ([value isKindOfClass:[NSNull class]]) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeObjectKey:(NSString *)key {
    if (!key) {
        return;
    }
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
