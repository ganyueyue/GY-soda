//
//  STVersionManager.m
//  Swim
//
//  Created by YY on 2022/8/24.
//

#import "STVersionManager.h"
#import "STHTTPRequest.h"
#import "STVersion.h"
#import "ECSO-Swift.h"
static STVersionManager *_instance = nil;

@interface STVersionManager ()<STDiscoverVersionViewDelegate>
@property (nonatomic, strong)STHTTPRequest *request;
@property (nonatomic, strong)STDiscoverVersionView *versionView;
@property (nonatomic, weak) KYPopupViewController *popupViewController;
@property (nonatomic, strong)STVersion *versionInfo;
@end

@implementation STVersionManager

+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
    });
    return _instance;
}

- (STHTTPRequest *)request {
    if (_request == nil) {
        _request = [[STHTTPRequest alloc]init];
    }
    return _request;
}



- (void)appVersionUpdate {
    if (self.popupViewController != nil) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    //版本升级，如果获取接口返回的版本号高于info.plist中的版本号，说明有新版本可下载
    [self.request getVersionConfSuccess:^(id object) {
        weakSelf.versionInfo = (STVersion *)object;
    } fail:^(FAILCODE stateCode, NSString *error) {

    }];
}

- (NSString *)getAppVersion{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
}

- (void)setVersionInfo:(STVersion *)versionInfo {
    if (_versionInfo == versionInfo) {
        return;
    }
    _versionInfo = versionInfo;
    [self checkIfNeedPopUpdate];
}

-(void)checkIfNeedPopUpdate{
    dispatch_async(dispatch_get_main_queue(), ^{
        //强制更新
        if (self.popupViewController != nil) {
            return;
        }
        if ([self compareVersion:self.versionInfo.verStr to:[self getAppVersion]]) {
            NSString *text = [NSString stringWithFormat:@"%@：V%@",@"最新版本".string,self.versionInfo.verStr];
            NSString *size = [NSString stringWithFormat:@"%@：10M",@"安装包大小".string];
            self.versionView = [[STDiscoverVersionView alloc]initWithVersionString:text sizeString:size contentString:self.versionInfo.verDesc isForceUpdate:self.versionInfo.verForceUpgrade];
            self.versionView.delegate = self;
            self.popupViewController = [NoticeHelp showCustomPopViewController:self.versionView withController:NULL complete:^{
                
            }];
        }
    });
}

- (void)discoverVersionViewButtonWithNumber:(NSInteger)number {
    [self.popupViewController dismiss:^{
        if (number == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.versionInfo.iosUrl] options:@{} completionHandler:nil];
        }
    }];
}

/**
 比较两个版本号的大小
 
 @param v1 第一个版本号
 @param v2 第二个版本号
 @return 版本号相等,返回0; v1小于v2,返回-1; 否则返回1.
 */
- (BOOL)compareVersion:(NSString *)v1 to:(NSString *)v2 {
    // 都为空，相等，返回0
    if (!v1 && !v2) {
        return false;
    }
    
    // v1为空，v2不为空，返回-1
    if (!v1 && v2) {
        return false;
    }
    
    // v2为空，v1不为空，返回1
    if (v1 && !v2) {
        return true;
    }
    
    // 获取版本号字段
    NSArray *v1Array = [v1 componentsSeparatedByString:@"."];
    NSArray *v2Array = [v2 componentsSeparatedByString:@"."];
    // 取字段最少的，进行循环比较
    NSInteger smallCount = (v1Array.count > v2Array.count) ? v2Array.count : v1Array.count;
    
    for (int i = 0; i < smallCount; i++) {
        NSInteger value1 = [[v1Array objectAtIndex:i] integerValue];
        NSInteger value2 = [[v2Array objectAtIndex:i] integerValue];
        if (value1 > value2) {
            // v1版本字段大于v2版本字段，返回1
            return true;
        } else if (value1 < value2) {
            // v2版本字段大于v1版本字段，返回-1
            return false;
        }
        
        // 版本相等，继续循环。
    }
    
    // 版本可比较字段相等，则字段多的版本高于字段少的版本。
    if (v1Array.count > v2Array.count) {
        return true;
    } else if (v1Array.count < v2Array.count) {
        return false;
    } else {
        return false;
    }
    
    return false;
}

@end











