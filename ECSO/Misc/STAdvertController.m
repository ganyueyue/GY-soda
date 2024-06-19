//
//  STAdvertController.m
//  ECSO
//
//  Created by YY on 2024/6/5.
//

#import "STAdvertController.h"

@interface STAdvertController ()

@property (nonatomic, strong) UIImageView *adView;

@end

@implementation STAdvertController


- (void)setup {
    [super setup];
    self.backgroundColor = HexRGB(0xffffff);
    
    _adView = [[UIImageView alloc] init];
    [_adView sx_setImagePlaceholdWithURL:[[STCacheManager shareInstance] getAPPInfo].appStartImage];
    _adView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_adView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    _adView.userInteractionEnabled = true;
    [_adView addGestureRecognizer:tap];
    
    [_adView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.top.equalTo(self);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 0.1;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    });
}

-(void)tapAction:(UIGestureRecognizer *)recognizer{
    STAPPInfo *info = [[STCacheManager shareInstance] getAPPInfo];
    if (info.appStartUrl.length <= 0) {
        return;
    }
    STWebViewController *vc = [[STWebViewController alloc] init];
    vc.urlString = info.appStartUrl;
    [[UIWindow lx_topMostController] pushViewController:vc completion:^{
        [self removeFromSuperview];
    }];
}

@end
