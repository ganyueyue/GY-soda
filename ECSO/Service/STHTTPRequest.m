//
//  STHTTPRequest.m
//  Swim
//
//  Created by YY on 2022/6/28.
//

#import "STHTTPRequest.h"
#import "NSDictionary+Extension.h"
#import "STStatus.h"
#import "STUser.h"
#import "STAPPInfo.h"
@interface STHTTPRequest()
@property (nonatomic, strong)NSURLSessionDataTask *appConfOp;
@property (nonatomic, strong)NSURLSessionDataTask *uploadPortraitOp;
@property (nonatomic, strong)NSURLSessionDataTask *changePortraitOp;
@property (nonatomic, strong)NSURLSessionDataTask *changeDisplaynameOp;
@property (nonatomic, strong)NSURLSessionDataTask *loginUserOp;
@property (nonatomic, strong)NSURLSessionDataTask *registerOp;
@property (nonatomic, strong)NSURLSessionDataTask *complaintOp;
@property (nonatomic, strong)NSURLSessionDataTask *sodaConfOp;
@end

@implementation STHTTPRequest

- (SXBaseSessionManager *)AFHttpJsonRequestManager {
    
    SXBaseSessionManager *manager =  [SXBaseSessionManager shareJsonRequestManager];
    
    manager.requestSerializer.timeoutInterval = 20.0f;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"1.0" forHTTPHeaderField:@"api-version"];
    
    AFSecurityPolicy *securityPolicy=[AFSecurityPolicy defaultPolicy];
    // 客户端是否信任非法证书
    securityPolicy.allowInvalidCertificates = YES;
    // 是否在证书域字段中验证域名
    securityPolicy.validatesDomainName = NO;
    manager.securityPolicy = securityPolicy;
    
    NSString *token = [STUserDefault objectValueForKey:@"token"];
    if (token.length > 0) {
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
        NSLog(@"token=%@",token);
    }
    
    return manager;
}

- (SXBaseSessionManager *)AFHttpJsonSodaRequestManager {
    
    SXBaseSessionManager *manager =  [SXBaseSessionManager shareSodaJsonRequestManager];
    
    manager.requestSerializer.timeoutInterval = 20.0f;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"1.0" forHTTPHeaderField:@"api-version"];
    
    AFSecurityPolicy *securityPolicy=[AFSecurityPolicy defaultPolicy];
    // 客户端是否信任非法证书
    securityPolicy.allowInvalidCertificates = YES;
    // 是否在证书域字段中验证域名
    securityPolicy.validatesDomainName = NO;
    manager.securityPolicy = securityPolicy;
    
    NSString *token = [STUserDefault objectValueForKey:@"token"];
    if (token.length > 0) {
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
        NSLog(@"token=%@",token);
    }
    return manager;
}

- (NSURLSessionDataTask *)getSodaConfSuccess:(SXObjectSuccess)success fail:(SXNetworkFail)fail {

    if (_sodaConfOp!=nil){
        return _sodaConfOp;
    }
    
    SXBaseSessionManager *manager = [self AFHttpJsonSodaRequestManager];
    
    _sodaConfOp = [manager GET:@"/soda_conf.json" parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.sodaConfOp = nil;

        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        STStatus *status = [STStatus parseDictionary:responseDictionary];
        if (!status.status) {
            fail(status.code,status.msg);
            return;
        }
        STConfigure * info = [STConfigure mj_objectWithKeyValues:responseDictionary[@"result"]];
        success(info);
        
    } fail:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.sodaConfOp = nil;
        fail(NetFail,[error localizedDescription]);
    }];
    
    return _sodaConfOp;
}



- (NSURLSessionDataTask *)uploadPortrait:(UIImage *)image success:(SXObjectSuccess)success fail:(SXNetworkFail)fail {

    if (_uploadPortraitOp!=nil){
        return _uploadPortraitOp;
    }
    SXBaseSessionManager *manager = [self AFHttpJsonRequestManager];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    _uploadPortraitOp = [manager POST:kURLUploadPortrait parameters:nil headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"image.jpg" mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.uploadPortraitOp = nil;

        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        STStatus *status = [STStatus parseDictionary:responseDictionary];
        if (!status.status) {
            fail(status.code,status.msg);
            return;
        }
        success(responseDictionary[@"result"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.uploadPortraitOp = nil;
        fail(NetFail,[error localizedDescription]);
    }];
    return _uploadPortraitOp;
}


- (NSURLSessionDataTask *)getAppConfSuccess:(SXObjectSuccess)success fail:(SXNetworkFail)fail {

    if (_appConfOp!=nil){
        return _appConfOp;
    }
    SXBaseSessionManager *manager = [self AFHttpJsonRequestManager];
    NSString *preferredLanguage = @"zh-cn";
    if ([[NSLocale preferredLanguages][0] hasPrefix:@"en"]) {
        preferredLanguage = @"en-us";
    }
    NSString *url = [NSString stringWithFormat:@"%@?language=%@&verNo=%@",kURLGetAppConf,preferredLanguage,[NSString getBundleVersion]];
    _appConfOp = [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.appConfOp = nil;

        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        STStatus *status = [STStatus parseDictionary:responseDictionary];
        if (!status.status) {
            fail(status.code,status.msg);
            return;
        }
        success(responseDictionary[@"result"]);
        
    } fail:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.appConfOp = nil;
        fail(NetFail,[error localizedDescription]);
    }];
    
    return _appConfOp;
}

- (NSURLSessionDataTask *)changeDisplayname:(NSString *)name success:(SXObjectSuccess)success fail:(SXNetworkFail)fail {

    if (_changeDisplaynameOp !=nil){
        return _changeDisplaynameOp;
    }
    SXBaseSessionManager *manager = [self AFHttpJsonRequestManager];
    
    _changeDisplaynameOp = [manager POST:kURLChangeDisplayname parameters:@{@"displayName":name} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.changeDisplaynameOp = nil;

        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        STStatus *status = [STStatus parseDictionary:responseDictionary];
        if (!status.status) {
            fail(status.code,status.msg);
            return;
        }
        success(responseDictionary);
        
    } fail:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.changeDisplaynameOp = nil;
        fail(NetFail,[error localizedDescription]);
    }];
    
    return _changeDisplaynameOp;
}

- (NSURLSessionDataTask *)changePortrait:(NSString *)portrait success:(SXObjectSuccess)success fail:(SXNetworkFail)fail {

    if (_changePortraitOp !=nil){
        return _changePortraitOp;
    }
    SXBaseSessionManager *manager = [self AFHttpJsonRequestManager];
    
    _changePortraitOp = [manager POST:kURLChangePortrait parameters:@{@"portrait":portrait} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.changePortraitOp = nil;

        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        STStatus *status = [STStatus parseDictionary:responseDictionary];
        if (!status.status) {
            fail(status.code,status.msg);
            return;
        }
        success(responseDictionary);
        
    } fail:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.changePortraitOp = nil;
        fail(NetFail,[error localizedDescription]);
    }];
    
    return _changeDisplaynameOp;
}

- (NSURLSessionDataTask *)registerUser:(NSString *)userName password:(NSString *)password displayName:(NSString *)displayName portrait:(NSString *)portrait clientId:(NSString *)clientId success:(SXObjectSuccess)success fail:(SXNetworkFail)fail {

    if (_registerOp !=nil){
        return _registerOp;
    }
    SXBaseSessionManager *manager = [self AFHttpJsonRequestManager];
    
    NSDictionary *parameters = @{
        @"userName":userName,
        @"password":password,
        @"displayName":displayName,
        @"portrait":portrait,
        @"clientId":clientId
    };
    
    _registerOp = [manager POST:kURLRegister parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.registerOp = nil;

        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        STStatus *status = [STStatus parseDictionary:responseDictionary];
        if (!status.status) {
            fail(status.code,status.msg);
            return;
        }
        STUser *user = [STUser mj_objectWithKeyValues:responseDictionary[@"result"]];
        success(user);
        
    } fail:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.registerOp = nil;
        fail(NetFail,[error localizedDescription]);
    }];
    
    return _registerOp;
}

- (NSURLSessionDataTask *)loginUser:(NSString *)userName password:(NSString *)password clientId:(NSString *)clientId success:(SXObjectSuccess)success fail:(SXNetworkFail)fail {

    if (_loginUserOp !=nil){
        return _loginUserOp;
    }
    SXBaseSessionManager *manager = [self AFHttpJsonRequestManager];
    
    NSDictionary *parameters = @{
        @"userName":userName,
        @"password":password,
        @"clientId":clientId
    };
    
    _loginUserOp = [manager POST:kURLLoginUserpwd parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.loginUserOp = nil;

        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        STStatus *status = [STStatus parseDictionary:responseDictionary];
        if (!status.status) {
            fail(status.code,status.msg);
            return;
        }
        STUser *user = [STUser mj_objectWithKeyValues:responseDictionary[@"result"]];
        success(user);
        
    } fail:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.loginUserOp = nil;
        fail(NetFail,[error localizedDescription]);
    }];
    
    return _loginUserOp;
}

- (NSURLSessionDataTask *)complaint:(NSString *)url type:(NSInteger)type description:(NSString *)description success:(SXObjectSuccess)success fail:(SXNetworkFail)fail {

    if (_complaintOp !=nil){
        return _complaintOp;
    }
    SXBaseSessionManager *manager = [self AFHttpJsonRequestManager];
    
    NSDictionary *parameters = @{
        @"url":url,
        @"description":description,
        @"type":@(type)
    };
    NSLog(@"%@",parameters);
    _complaintOp = [manager POST:kURLComplaint parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.complaintOp = nil;

        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        STStatus *status = [STStatus parseDictionary:responseDictionary];
        if (!status.status) {
            fail(status.code,status.msg);
            return;
        }
        success(responseDictionary[@"result"]);
        
    } fail:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.complaintOp = nil;
        fail(NetFail,[error localizedDescription]);
    }];
    
    return _complaintOp;
}

@end
