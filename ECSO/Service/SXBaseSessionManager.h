//
//  SXBaseSessionManager.h
//  Swim
//
//  Created by YY on 2022/6/28.
//

#import <AFNetworking/AFHTTPSessionManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXBaseSessionManager : AFHTTPSessionManager

+(SXBaseSessionManager *)shareJsonRequestManager;

+(SXBaseSessionManager *)shareSodaJsonRequestManager;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                      progress:(void (^)(NSProgress * _Nonnull))uploadProgress
                       success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                          fail:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure;

- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress * _Nonnull))downloadProgress success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success fail:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure;


@end

NS_ASSUME_NONNULL_END
