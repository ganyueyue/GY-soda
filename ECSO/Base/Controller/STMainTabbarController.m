//
//  STMainTabbarController.m
//  SXTraining
//
//  Created by YY on 2019/11/15.
//  Copyright © 2019 YY. All rights reserved.
//

#import "STMainTabbarController.h"
#import "STNavigationController.h"
#import "STFindController.h"
#import "STUserInfoController.h"
@interface STMainTabbarController ()<UITabBarControllerDelegate>

@property (nonatomic, strong)NSMutableArray *controllers;

@end

@implementation STMainTabbarController

static STMainTabbarController* _instance = nil;

+ (instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    }) ;
    
    return _instance ;
}

- (void)dealloc
{
    NSLog(@"SXMainTabbarController 释放内存");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.tabBar.translucent = NO;
    [self createSubViewControllers];
}

- (NSMutableArray *)controllers {
    if (_controllers == nil) {
        _controllers = [NSMutableArray array];
    }
    return _controllers;
}

- (void)createSubViewControllers {
    [self.controllers removeAllObjects];
    STFindController *findVc = [[STFindController alloc]init];
    STNavigationController *nav = [[STNavigationController alloc] initWithRootViewController:findVc];
    [self.controllers addObject:nav];
    STUserInfoController *vc = [[STUserInfoController alloc] init];
    STNavigationController *nav1 = [[STNavigationController alloc] initWithRootViewController:vc];
    [self.controllers addObject:nav1];
    self.viewControllers = self.controllers;
    self.selectedIndex = 0;
    [self createSystemTabbar];
}

- (void)createSystemTabbar {
    
    self.tabBar.backgroundColor = HexRGB(0xFFFFFF);
    
    //去除标签栏的顶部分割线
    [self.tabBar setShadowImage:[[UIImage alloc]init]];
    [self.tabBar setBackgroundImage:[[UIImage alloc]init]];
    
    //改变标签栏的顶部分割线颜色
    CGRect rect = CGRectMake(0, 0, ScreenWidth, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, HexRGB(0xF4F4F4).CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBar setShadowImage:img];
    [self.tabBar setBackgroundImage:[[UIImage alloc]init]];
    
    //2.创建按钮图片及标题数组
    NSMutableArray *imgNameNor = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *imgNameSel = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *titleName = [NSMutableArray arrayWithCapacity:0];
        
    [imgNameNor addObject:@"icon_home_nor"];
    [imgNameSel addObject:@"icon_home_sel"];
    [titleName addObject:@"首页"];

//    [imgNameNor addObject:@"icon_tabbar_discover_nor"];
//    [imgNameSel addObject:@"icon_tabbar_discover_sel"];
//    [titleName addObject:@"发现"];

    [imgNameNor addObject:@"icon_me_nor"];
    [imgNameSel addObject:@"icon_me_sel"];
    [titleName addObject:@"我的"];
    
    for (NSInteger i = 0; i < self.controllers.count; i++) {
        UIViewController *vc = self.controllers[i];
        vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:titleName[i] image:[[UIImage imageNamed:imgNameNor[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:imgNameSel[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [vc.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[STFont fontSize:11],NSForegroundColorAttributeName:HexRGB(0x292F48)} forState:UIControlStateNormal];
        [vc.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[STFont fontStatus:medium fontSize:11],NSForegroundColorAttributeName:HexRGB(0x536EEB)} forState:UIControlStateSelected];
        self.tabBar.tintColor = HexRGB(0x536EEB);
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    UIViewController *subViewController = self.viewControllers[self.selectedIndex];
    return [subViewController preferredStatusBarStyle];
}

-(BOOL)prefersStatusBarHidden
{
    UIViewController *subViewController = self.viewControllers[self.selectedIndex];
    return [subViewController prefersStatusBarHidden];
}

//  是否支持自动转屏
- (BOOL)shouldAutorotate
{
    // 调用ZFPlayerSingleton单例记录播放状态是否锁定屏幕方向
    UIViewController *subViewController = self.viewControllers[self.selectedIndex];
    return [subViewController shouldAutorotate];
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    return YES;
}

@end
