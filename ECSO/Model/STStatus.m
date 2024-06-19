//
//  STStatus.m
//  Swim
//
//  Created by YY on 2022/6/28.
//

#import "STStatus.h"

@implementation STStatus

- (NSString *)description
{
    return [NSString stringWithFormat:@"[Status code:%ld, message:%@]",self.code,self.msg];
}

+(instancetype)shareStatus
{
    STStatus *status = [[STStatus alloc] init];
    status.status = FALSE;
    status.code = NetFail;
    status.msg = @"";
    return status;
}

+(instancetype)parseDictionary:(NSDictionary *)dic
{
    STStatus *status = [STStatus shareStatus];
    status.status = [[dic objectForKey:@"code"] integerValue] == NetSuccess ? TRUE:FALSE;
    status.code = [[dic objectForKey:@"code"] integerValue];
    status.msg = [dic objectForKey:@"message"];
    
    return status;
}
@end
