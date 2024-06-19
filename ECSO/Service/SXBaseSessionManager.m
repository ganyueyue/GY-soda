//
//  SXBaseSessionManager.m
//  Swim
//
//  Created by YY on 2022/6/28.
//

#import "SXBaseSessionManager.h"

@implementation SXBaseSessionManager

+(SXBaseSessionManager *)shareJsonRequestManager {
    
    static SXBaseSessionManager *_shareHTTPRequest;
    
    static dispatch_once_t requestToken;
    dispatch_once(&requestToken, ^{
        NSURLSessionConfiguration *configration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configration.connectionProxyDictionary = @{};
        _shareHTTPRequest = [[SXBaseSessionManager alloc] initWithBaseURL:[NSURL URLWithString:KOpenWebPortUrl] sessionConfiguration:configration];
        _shareHTTPRequest.requestSerializer = [AFHTTPRequestSerializer serializer];
        AFJSONResponseSerializer *serializer =  [AFJSONResponseSerializer serializer];
        serializer.removesKeysWithNullValues = YES;
        _shareHTTPRequest.responseSerializer = serializer;
        _shareHTTPRequest.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    });
    
    return _shareHTTPRequest;
}

+(SXBaseSessionManager *)shareSodaJsonRequestManager {
    
    static SXBaseSessionManager *_shareHTTPRequest;
    
    static dispatch_once_t requestToken;
    dispatch_once(&requestToken, ^{
        NSURLSessionConfiguration *configration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configration.connectionProxyDictionary = @{};
        _shareHTTPRequest = [[SXBaseSessionManager alloc] initWithBaseURL:[NSURL URLWithString:KOpenSodaPortUrl] sessionConfiguration:configration];
        _shareHTTPRequest.requestSerializer = [AFHTTPRequestSerializer serializer];
        AFJSONResponseSerializer *serializer =  [AFJSONResponseSerializer serializer];
        serializer.removesKeysWithNullValues = YES;
        _shareHTTPRequest.responseSerializer = serializer;
        _shareHTTPRequest.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    });
    
    return _shareHTTPRequest;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                      progress:(void (^)(NSProgress * _Nonnull))uploadProgress
                       success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                          fail:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    
    return [super POST:URLString parameters:parameters headers:nil progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {

            NSDictionary *responseDictionary = (NSDictionary *)responseObject;
            success(task, responseDictionary);
        }

    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task, error);
        }
    }];
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress * _Nonnull))downloadProgress success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success fail:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    return [super GET:URLString parameters:parameters headers:nil progress:downloadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            NSDictionary *responseDictionary = (NSDictionary *)responseObject;
            success(task, responseDictionary);
        }
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task, error);
        }
    }];
}



@end
