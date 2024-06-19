//
//  STPageViewController.m
//  Swim
//
//  Created by YY on 2022/3/23.
//

#import "STPageViewController.h"

@interface STPageViewController ()<WMPageControllerDataSource,WMPageControllerDelegate>

@end

@implementation STPageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showOnNavigationBar = false;
    self.menuViewStyle = WMMenuViewStyleLine;
    self.titleSizeSelected = 16;
    self.titleSizeNormal = 16;
    self.titleFontName = @"PingFangSC-Regular";
    self.titleSelecteFontName = @"PingFangSC-Medium";
    self.automaticallyCalculatesItemWidths = YES;
    self.titleColorNormal = HexRGB(0x292F48);
    self.titleColorSelected = HexRGB(0x292F48);
    self.progressColor = HexRGB(0x292F48);
    self.progressViewCornerRadius = 2;
    self.progressWidth = 22;
    self.progressHeight = 4;
    self.progressViewBottomSpace = 2;
    self.delegate = self;
    self.dataSource = self;
    self.pageAnimatable = YES;
    
}

#pragma mark
#pragma mark set viewcontroller

-(void)setSubViewControllers:(NSArray *)subViewControllers{
    
    _subViewControllers = subViewControllers;
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    [_subViewControllers enumerateObjectsUsingBlock:^(UIViewController *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.title != nil){
            [array addObject:obj.title];
        }else{
            [array addObject:@""];
        }
        
    }];
    
    self.titles = [array copy];
    
    [self reloadData];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    
    CGFloat tempOriginY = 0;
    if (self.edgesForExtendedLayout != UIRectEdgeNone && self.extendedLayoutIncludesOpaqueBars == true && self.navigationController.navigationBar != nil){
        tempOriginY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    }else{
        tempOriginY = 0;
    }
    
    CGFloat leftMargin = self.showOnNavigationBar ? 0 : 0;
    CGFloat originY = self.showOnNavigationBar ? 0 : tempOriginY;
    return CGRectMake(leftMargin, originY, self.view.frame.size.width - 2*leftMargin, 44);
}


- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return [_subViewControllers count];
}

-(UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    return _subViewControllers[index];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    if ([self.subViewControllers count] <= self.currentPageIndex ) {
        if (@available(iOS 13.0, *)) {
            return UIStatusBarStyleDarkContent;
        }
        return UIStatusBarStyleDefault;
        
    }else{
        UIViewController *controller = [self.subViewControllers objectAtIndex:self.currentPageIndex];
        if ([controller respondsToSelector:@selector(preferredStatusBarStyle)]) {
            return [controller preferredStatusBarStyle];
        }
    }
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    }
    return UIStatusBarStyleDefault;
}
@end
