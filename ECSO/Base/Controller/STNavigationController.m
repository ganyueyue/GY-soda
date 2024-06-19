//
//  STNavigationController.m
//  Swim
//
//  Created by YY on 2022/3/10.
//

#import "STNavigationController.h"
#import "UIViewController+Extension.h"

@interface STNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation STNavigationController

-(void)dealloc
{
    self.delegate = nil;
}

-(id)initWithRootViewController:(UIViewController *)rootViewController{
    if (self = [super initWithRootViewController:rootViewController]){
        
        self.delegate = self;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 13.0, *))  {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = [UIColor whiteColor];
        //设置标题字体颜色
        [appearance setTitleTextAttributes:@{NSForegroundColorAttributeName:HexRGB(0x292F48), NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}];
        appearance.shadowColor= [UIColor clearColor];
        self.navigationBar.standardAppearance = appearance;
        self.navigationBar.scrollEdgeAppearance = self.navigationBar.standardAppearance;
    } else {
            [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(ScreenWidth, 64)] forBarMetrics:UIBarMetricsDefault];
            self.navigationBar.shadowImage = [UIImage new];
            self.navigationBar.translucent = false;
            [self.navigationBar setTitleTextAttributes:
             @{NSFontAttributeName:[STFont fontStatus:medium fontSize:18],NSForegroundColorAttributeName:SXColor3}];
        }
    
   
}


- (void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated {

    if (self.viewControllers.count > 0) {
        [viewController setHidesBottomBarWhenPushed:YES];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)pushViewController:(UIViewController *)viewController completion:(void (^)(void))completion {
    if (self.viewControllers.count > 0) {
        [viewController setHidesBottomBarWhenPushed:YES];
    }
    [super pushViewController:viewController animate:YES completion:completion];
}

-(BOOL)hidesBottomBarWhenPushed{
    return [[self lx_topMostController] hidesBottomBarWhenPushed];
}

-(BOOL)prefersStatusBarHidden{
    return [[self lx_topMostController] prefersStatusBarHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    
    if ([self respondsToSelector:@selector(preferredStatusBarStyle)]) {
        return [self.topViewController preferredStatusBarStyle];
    }
    
    return UIStatusBarStyleDefault;
}

// New Autorotation support.
- (BOOL)shouldAutorotate{
    
    if ([self respondsToSelector:@selector(shouldAutorotate)]) {
        
        return [self.topViewController shouldAutorotate];
    }
    
    return NO;
    
}


#pragma mark transition

//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    if ([self respondsToSelector:@selector(supportedInterfaceOrientations)]) {
//        return [self.topViewController supportedInterfaceOrientations];
//    }
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//
//    if ([self respondsToSelector:@selector(preferredInterfaceOrientationForPresentation)]) {
//
//        return [self.topViewController preferredInterfaceOrientationForPresentation];
//
//    }
//    return UIInterfaceOrientationPortrait;
//}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return false;
}
@end
