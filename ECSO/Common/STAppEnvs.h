//
//  STAppEnvs.h
//  Swim
//
//  Created by YY on 2022/3/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface STAppEnvs : NSObject
#pragma mark - 相关变量值
@property(nonatomic, assign) int screenWidth;   // 屏幕宽度
@property(nonatomic, assign) int screenHeight;  // 屏幕高度
@property(nonatomic, assign) int statusBarHeight; // 系统状态栏高度
@property(nonatomic, assign) int tabBarHeight; // 系统TabBar高度 + 安全距离
@property(nonatomic, assign) int safeAreaBottomHeight; //iPhone X 安全距离
@property(nonatomic, assign) int navBarHeight;  // 导航栏高度
@property(nonatomic, assign) int navHeight; // 状态栏 + 导航栏
@property(nonatomic, assign) int screenHeightTabBar; // 屏幕高度 - 状态栏 - 导航栏 - tabBar - 安全距离
@property(nonatomic, assign) int screenHeightTabBarNoNavBar;    // 屏高 - 状态栏高度 - tabBar - 安全距离
@property(nonatomic, assign) int screenHeightNoNavBar;  // 屏高 - 状态栏 - 导航栏 - 安全距离
@property(nonatomic, assign) int screenHeightBar;  // 屏高 - 导航栏
@property(nonatomic, assign) int screenHeightNoStatusBar;   // 屏幕高度 - 状态栏

#pragma mark - 机型
@property(nonatomic, assign) bool isIPhone4;
@property(nonatomic, assign) bool isIPhone5;
@property(nonatomic, assign) bool isIPhone6;
@property(nonatomic, assign) bool isIPhone6Plus;
@property(nonatomic, assign) bool isIphoneX;

+(instancetype) shareInstance;
- (NSString *)getDeviceModelName;
@end

NS_ASSUME_NONNULL_END
