//
//  UINavigationController+Extension.m
//  SXTraining
//
//  Created by YY on 2019/11/15.
//  Copyright © 2019 YY. All rights reserved.
//

#import "UINavigationController+Extension.h"
#import <objc/runtime.h>

@implementation UINavigationController (Extension)

-(void)deleteViewControllerClass:(Class)viewControllerClass{
    NSMutableArray *subControllers = [NSMutableArray arrayWithArray:self.viewControllers];

    BOOL isDeleted = false;
    for (NSInteger i = subControllers.count - 1; i>=0; i--) {
        UIViewController *controller = subControllers[i];
        if ([controller isKindOfClass:viewControllerClass]){
            [subControllers removeObjectAtIndex:i];
            isDeleted = true;
        }
    }
    if (isDeleted){
        self.viewControllers = subControllers;
    }
}


-(void)deleteViewControllers:(NSArray<UIViewController *>*)array{

    NSMutableArray *subControllers = [NSMutableArray arrayWithArray:self.viewControllers];

    BOOL isDeleted = false;

    for (UIViewController *viewController in array) {
        for (NSInteger i = subControllers.count - 1; i>=0; i--) {
            UIViewController *controller = subControllers[i];
            if (controller == viewController){
                [subControllers removeObjectAtIndex:i];
                isDeleted = true;
                break;
            }
        }

    }

    if (isDeleted){
        self.viewControllers = subControllers;
    }

}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion: (void (^ __nullable)(void))completion {
    [CATransaction setCompletionBlock:completion];
    [CATransaction begin];
    [self pushViewController:viewController animated:animated];
    [CATransaction commit];
}

- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated completion: (void (^ __nullable)(void))completion {
    UIViewController *poppedViewController;
    [CATransaction setCompletionBlock:completion];
    [CATransaction begin];
    poppedViewController = [self popViewControllerAnimated:animated];
    [CATransaction commit];
    return poppedViewController;
}

- (nullable NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController * _Nonnull)viewController animated:(BOOL)animated  completion: (void (^ __nullable)(void))completion{
    NSArray<UIViewController*>* viewControllers;
    [CATransaction setCompletionBlock:completion];
    [CATransaction begin];
    viewControllers = [self popToViewController:viewController animated:animated];
    [CATransaction commit];
    return viewControllers;
}

- (nullable NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated   completion: (void (^ __nullable)(void))completion {
    NSArray<UIViewController*>* viewControllers;
    [CATransaction setCompletionBlock:completion];
    [CATransaction begin];
    viewControllers = [self popToRootViewControllerAnimated:animated];
    [CATransaction commit];
    return viewControllers;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.visibleViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden{
    return self.visibleViewController;
}

@end
