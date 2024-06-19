//
//  STStatus.h
//  Swim
//
//  Created by YY on 2022/6/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FAILCODE)
{
    NetFail = 1,
    NetSuccess = 0
};

@interface STStatus : NSObject
@property (nonatomic, assign) BOOL status;
@property (nonatomic, assign) FAILCODE code;
@property (nonatomic, copy) NSString *msg;

+(instancetype)shareStatus;
+(instancetype)parseDictionary:(NSDictionary *)dic;

@end


NS_ASSUME_NONNULL_END
