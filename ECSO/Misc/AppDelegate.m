//
//  AppDelegate.m
//  ECSO
//
//  Created by YY on 2024/5/22.
//

#import "AppDelegate.h"
#import "STNavigationController.h"
#import "STNickAvatarController.h"
#import "STMainTabbarController.h"
#import "STFindController.h"
#import "STLoginController.h"
#import "UIWindow+Helper.h"
#import <AFNetworkReachabilityManager.h>
#import "STHTTPRequest.h"
#import "STAPPInfo.h"
#import "STAdvertController.h"
@interface AppDelegate ()
@property (nonatomic, strong)STHTTPRequest *request;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[STWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSString *token = [STUserDefault objectValueForKey:@"token"];
    NSString *userId = [STUserDefault objectValueForKey:@"userId"];
    if (token.length > 0) {
        STNavigationController *nav = [[STNavigationController alloc] initWithRootViewController:[[STFindController alloc] init]];
        self.window.rootViewController = nav;
    } else if (userId.length > 0) {
        STNavigationController *nav = [[STNavigationController alloc] initWithRootViewController:[[STLoginController alloc] init]];
        self.window.rootViewController = nav;
    } else {
        STNavigationController *nav = [[STNavigationController alloc] initWithRootViewController:[[STNickAvatarController alloc] init]];
        self.window.rootViewController = nav;
    }
    
    if ([[STCacheManager shareInstance] getAPPInfo].appStartImage.length > 0) {
        STAdvertController *adView = [[STAdvertController alloc] init];
        self.window.hidden = false;
        self.window.splitView = adView;
        [self.window addSubview:adView];
        [adView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.bottom.equalTo(self.window);
        }];
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self loadNetworkReachability];
//        [self getAppConflgure];
        [self getSodaConflgure];
    });
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (STHTTPRequest *)request {
    if (_request == nil) {
        _request = [[STHTTPRequest alloc]init];
    }
    return _request;
}

- (void)loadNetworkReachability {
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr startMonitoring];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status != AFNetworkReachabilityStatusReachableViaWiFi && status != AFNetworkReachabilityStatusReachableViaWWAN) {
            [SVProgressHelper dismissWithMsg:@"当前网络不可用"];
            return;
        }
    }];
}

- (void)getAppConflgure {
    [self.request getAppConfSuccess:^(id object) {
    } fail:^(FAILCODE stateCode, NSString *error) {
        
    }];
}

- (void)getSodaConflgure {
    [self.request getSodaConfSuccess:^(id object) {
        STConfigure *info = object;
        [[STCacheManager shareInstance] saveAPPInfo:info.appConf];
        [[STCacheManager shareInstance] saveWallers:info.tokenConfList];
        [[STCacheManager shareInstance] saveBlockChain:info.blockchainConfList];
    } fail:^(FAILCODE stateCode, NSString *error) {
        
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    NSString *token = [STUserDefault objectValueForKey:@"token"];
    if (token.length > 0 && [[UIWindow lx_topMostController] isKindOfClass:[STFindController class]]) {
        [self getPasswordAddress];
    }
}

- (void)getPasswordAddress {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];//获取系统等剪切板
    if (pasteboard.string.length > 0 && pasteboard.strings.count == 1) {
        NSString *string = pasteboard.string;
        if ([NSString isCheckUrl:string.lowercaseString]) {
            STWebViewController *vc = [[STWebViewController alloc] init];
            vc.urlString = string;
            UIViewController *topMost = [UIWindow lx_topMostController];
            [topMost pushViewController:vc completion:^{
                pasteboard.string = @"";
            }];
        }
    }
}

-(BOOL)application:(UIApplication*)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id>*)options {
//6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    if ([url.absoluteString hasPrefix:@"sodato://dc?"]) {
        NSString *key = [NSString getParamByName:@"key" URLString:url.absoluteString];
        NSString *decodeKey = [key stringByRemovingPercentEncoding];
        STWebViewController *controller = [[STWebViewController alloc]init];
        controller.urlString = decodeKey.length > 0 ? decodeKey : key;
        UIViewController *topMost = [UIWindow lx_topMostController];
        [topMost pushViewController:controller completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSMutableArray *controllers = [NSMutableArray array];
                for (UIViewController *vc in topMost.navigationController.viewControllers) {
                    if (vc == controller || ![vc isKindOfClass:[STWebViewController class]]) {
                        [controllers addObject:vc];
                    }
                }
                topMost.navigationController.viewControllers = controllers;
            });
        }];
    }
    return true;
}

@end
