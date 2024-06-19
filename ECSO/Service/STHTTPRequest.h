//
//  STHTTPRequest.h
//  Swim
//
//  Created by YY on 2022/6/28.
//

#import <Foundation/Foundation.h>
#import "SXBaseSessionManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface STHTTPRequest : NSObject
- (SXBaseSessionManager *)AFHttpJsonRequestManager;

- (NSURLSessionDataTask *)uploadPortrait:(UIImage *)image success:(SXObjectSuccess)success fail:(SXNetworkFail)fail;

- (NSURLSessionDataTask *)getAppConfSuccess:(SXObjectSuccess)success fail:(SXNetworkFail)fail;

- (NSURLSessionDataTask *)changePortrait:(NSString *)portrait success:(SXObjectSuccess)success fail:(SXNetworkFail)fail;

- (NSURLSessionDataTask *)changeDisplayname:(NSString *)name success:(SXObjectSuccess)success fail:(SXNetworkFail)fail;

- (NSURLSessionDataTask *)registerUser:(NSString *)userName password:(NSString *)password displayName:(NSString *)displayName portrait:(NSString *)portrait clientId:(NSString *)clientId success:(SXObjectSuccess)success fail:(SXNetworkFail)fail;

- (NSURLSessionDataTask *)loginUser:(NSString *)userName password:(NSString *)password clientId:(NSString *)clientId success:(SXObjectSuccess)success fail:(SXNetworkFail)fail;

- (NSURLSessionDataTask *)complaint:(NSString *)url type:(NSInteger)type description:(NSString *)description success:(SXObjectSuccess)success fail:(SXNetworkFail)fail;

- (NSURLSessionDataTask *)getSodaConfSuccess:(SXObjectSuccess)success fail:(SXNetworkFail)fail;
@end

NS_ASSUME_NONNULL_END
