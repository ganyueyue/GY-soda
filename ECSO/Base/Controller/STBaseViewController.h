//
//  STBaseViewController.h
//  Swim
//
//  Created by YY on 2022/3/10.
//

#import <UIKit/UIKit.h>
#import "STErrorView.h"
#import "STLoadingView.h"
NS_ASSUME_NONNULL_BEGIN

@interface STBaseViewController : UIViewController

@property (nonatomic, strong) UIBarButtonItem *backButtonItem;
@property (nonatomic, assign) NSInteger enterCount;
@property (nonatomic, assign) BOOL isLoadData;
@property (nonatomic, assign) BOOL isShowLoadView;

@property (nonatomic, strong) STErrorView *errorView;
@property (nonatomic, strong) STLoadingView *loadingView;

//初始化方法  会在viewDidLoad 之前
- (void)setup;

- (void)showLoadingView;
- (void)hiddenLoadingView;

- (void)contentRefresh;
- (void)contentLoadMore;

- (void)networkErrorNotice;

- (void)backAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
