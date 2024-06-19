//
//  STUserDefault.h
//  Swim
//
//  Created by YY on 2022/3/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface STUserDefault : NSObject
+(NSInteger)integerValueForKey:(NSString *)key;
+(void)setintegerValue:(NSInteger)value forKey:(NSString *)key;

+(double)doubleValueForKey:(NSString *)key;
+(void)setDoubleValue:(double)value forKey:(NSString *)key;

+(CGFloat)floatValueForKey:(NSString *)key;
+(void)setFloatVaule:(CGFloat)value forKey:(NSString *)key;

+(BOOL)BoolValueForKey:(NSString *)key;
+(void)setBoolVaule:(BOOL)value forKey:(NSString *)key;

+(id)objectValueForKey:(NSString *)key;
+(void)setObjectValue:(id)value forKey:(NSString *)key;

+ (void)removeObjectKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
