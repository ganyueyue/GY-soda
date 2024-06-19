//
//  STBaseViewController.m
//  Swim
//
//  Created by YY on 2022/3/10.
//

#import "STBaseViewController.h"
#import "AppDelegate.h"
@interface STBaseViewController ()<STErrorViewDelegate>

@end

@implementation STBaseViewController


@synthesize backButtonItem = _backButtonItem;

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        [self setup];
    }
    return self;
}

-(instancetype)init{
    return [self initWithNibName:nil bundle:nil];
}

-(void)setup{
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [SVProgressHelper dismissHUD];
    NSLog(@"dealloc %@",self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    self.view.backgroundColor = HexRGB(0xF3F5F9);
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(ScreenWidth, 64)] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];

    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[STFont fontStatus:medium fontSize:18],NSForegroundColorAttributeName:SXColor3}];
    self.navigationController.navigationBar.translucent = false;
    self.isShowLoadView = false;
    self.isLoadData = false;
    self.enterCount = 0;
    
    [self setCustomNavigationBackButton];
    
}

- (void)setCustomNavigationBackButton
{
    UINavigationController *navi = self.navigationController;
    if (navi != nil && navi.viewControllers.count > 1){
        self.navigationItem.leftBarButtonItems = @[self.backButtonItem];
    }
}

- (UIBarButtonItem *)backButtonItem
{
    
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(0, 0, 40, 40);
    [button setImage:[UIImage imageNamed:@"common_back"] forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.imageEdgeInsets = UIEdgeInsetsZero;
    [button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)) {
        button.contentEdgeInsets =UIEdgeInsetsMake(0, 0,0, 0);
        button.imageEdgeInsets =UIEdgeInsetsMake(0, 0,0, 0);
    }
    _backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return _backButtonItem;
}


- (STErrorView *)errorView {
    if (_errorView == nil) {
        _errorView = [[STErrorView alloc]initWithFrame:self.view.bounds];
        _errorView.delegate = self;
        [self.view addSubview:_errorView];
    }
    return _errorView;
}

- (STLoadingView *)loadingView {
    if (_loadingView == nil) {
        _loadingView = [[STLoadingView alloc]initWithFrame:self.view.bounds];
        _loadingView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_loadingView];
        
        [_loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.top.equalTo(self.view);
        }];
        
    }
    return _loadingView;
}

- (void)setBackButtonItem:(UIBarButtonItem *)backButtonItem
{
    if (_backButtonItem == backButtonItem) {
        return;
    }
    
    _backButtonItem = backButtonItem;
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

-(void)backAction:(id)sender{
    [self.view endEditing:true];
    if (self.navigationController != nil && self.navigationController.viewControllers.count <= 1){
        [self dismiss:^{
            
        }];
    } else {
        [self popViewController:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:false animated:false];
    if (self.isShowLoadView && self.enterCount == 0) {
        [self showLoadingView];
    }else if (self.isLoadData && self.enterCount == 0) {
        [self contentRefresh];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.enterCount += 1;
}

#pragma makr instance
- (void)contentRefresh
{
    
}

- (void)contentLoadMore
{
    
}

- (void)showLoadingView
{
    [self.view addSubview:self.loadingView];
    [self.view bringSubviewToFront:self.loadingView];
    [self.errorView removeFromSuperview];
    if (self.isLoadData) {
        [self contentRefresh];
    }
}


- (void)hiddenLoadingView
{
    [self.errorView removeFromSuperview];
    [self.loadingView removeFromSuperview];
}

- (void)networkErrorNotice
{
    if (self.errorView != nil){
        [self.errorView removeFromSuperview];
        self.errorView = nil;
    }
    
    [self.view addSubview:self.errorView];
    [self.view bringSubviewToFront:self.errorView];
    [self.loadingView removeFromSuperview];
    self.loadingView = nil;
}

#pragma mark - SXErrorViewDelegate
- (void)touchErrorView:(STErrorView *)view {
    [self showLoadingView];
    [self.errorView removeFromSuperview];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    }
    return  UIStatusBarStyleDefault;
}

-(BOOL)prefersStatusBarHidden
{
    return FALSE;
}
@end
