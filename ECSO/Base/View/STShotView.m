//
//  STShotView.m
//  Swim
//
//  Created by YY on 2022/8/23.
//

#import "STShotView.h"

@interface STShotView ()
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *dropView;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIImageView *codeView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@end


@implementation STShotView

- (void)setup {
    [super setup];
        
    [self addSubview:self.backgroundView];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self);
        make.height.mas_offset(140 + [STAppEnvs shareInstance].safeAreaBottomHeight);
    }];
    
    [self addSubview:self.dropView];
    [self.dropView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(60);
        make.trailing.equalTo(self).offset(-60);
        make.top.equalTo(self).offset(30);
        make.bottom.equalTo(self.backgroundView.mas_top).offset(-30);
    }];
    
    [self.dropView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.dropView);
        make.bottom.equalTo(self.dropView.mas_bottom).offset(-100);
    }];
    
    self.codeView = [[UIImageView alloc]init];
    [self.dropView addSubview:self.codeView];
    [self.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.bottom.equalTo(self.dropView).offset(-20);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textAlignment = NSTextAlignmentRight;
    self.titleLabel.font = [STFont fontStatus:medium fontSize:13];
    self.titleLabel.textColor = HexRGB(0x333333);
    self.titleLabel.numberOfLines = 2;
    [self.dropView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.dropView.mas_leading).offset(20);
        make.trailing.equalTo(self.codeView.mas_leading).offset(-20);
        make.bottom.equalTo(self.codeView.mas_centerY).offset(-3);
    }];
    
    self.descLabel = [[UILabel alloc]init];
    self.descLabel.font = [STFont fontSize:12];
    self.descLabel.textAlignment = NSTextAlignmentRight;
    self.descLabel.numberOfLines = 2;
    self.descLabel.textColor = HexRGB(0x333333);
    [self.dropView addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.dropView.mas_leading).offset(20);
        make.trailing.equalTo(self.codeView.mas_leading).offset(-20);
        make.top.equalTo(self.codeView.mas_centerY).offset(3);
    }];
    
    UITapGestureRecognizer *closeBtn = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidden)];
    [self addGestureRecognizer:closeBtn];

}

- (UIView *)backgroundView {
    if (_backgroundView == nil) {
        _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 140 + [STAppEnvs shareInstance].safeAreaBottomHeight)];
        _backgroundView.backgroundColor = HexRGB(0xF8F8F8);
        [_backgroundView setCornerOnTopRadius:30];
    }
    return _backgroundView;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]init];
    }
    return _imageView;
}

- (UIView *)dropView {
    if (_dropView == nil) {
        _dropView = [[UIView alloc]init];
        _dropView.backgroundColor = [UIColor whiteColor];
        _dropView.layer.cornerRadius = 30;
        _dropView.clipsToBounds = true;
    }
    return _dropView;
}

- (void)createSubViewPlatform:(STSharePlatform *)info withShowView:(UIView *)view withTitle:(NSString *)title withDesc:(NSString *)desc withUrlString:(NSString *)urlString {
    
    self.titleLabel.text = title;
    self.descLabel.text = desc;
    
    self.codeView.image = [UIImage createQRCodeWithTargetString:urlString];
    
    UIButton *copyBtn = [[UIButton alloc]init];
    [copyBtn setTitle:@"复制口令发送给好友" forState:UIControlStateNormal];
    [copyBtn setTitleColor:HexRGB(0x292F48) forState:UIControlStateNormal];
    copyBtn.titleLabel.font = [STFont fontSize:16];
    copyBtn.layer.cornerRadius = 4;
    copyBtn.layer.borderColor = HexRGB(0x999999).CGColor;
    copyBtn.layer.borderWidth = 1;
    copyBtn.tag = 101;
    [copyBtn addTarget:self action:@selector(copyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView addSubview:copyBtn];
    
    UIButton *imageBtn = [[UIButton alloc]init];
    imageBtn.backgroundColor = [UIColor colorWithRed:59/255.0 green:190/255.0 blue:94/255.0 alpha:1];
    [imageBtn setTitle:[NSString stringWithFormat:@"发送图片到%@",info.name] forState:UIControlStateNormal];
    [imageBtn setTitleColor:HexRGB(0xffffff) forState:UIControlStateNormal];
    imageBtn.titleLabel.font = [STFont fontSize:16];
    imageBtn.layer.cornerRadius = 4;
    imageBtn.clipsToBounds = true;
    imageBtn.tag = 100;
    [imageBtn addTarget:self action:@selector(copyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView addSubview:imageBtn];
    [imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundView).offset(20);
        make.leading.equalTo(self.backgroundView).offset(20);
        make.height.mas_offset(44);
        make.centerX.equalTo(self.backgroundView);
    }];
    [copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageBtn.mas_bottom).offset(20);
        make.centerX.equalTo(self.backgroundView);
        make.leading.equalTo(self.backgroundView).offset(20);
        make.height.mas_offset(44);
    }];
    UIImage *image = [self screenCaptureShotView:view];
    self.imageView.image = image;
        
}

/**
 * 截屏-
 * view         截图的view
 */
- (UIImage *)screenCaptureShotView:(UIView *)view
{
    // 判断是否为retina屏, 即retina屏绘图时有放大因子
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]){
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    } else {
        UIGraphicsBeginImageContext(view.bounds.size);
    }
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
      
    UIGraphicsEndImageContext();

    return image;
}

- (void)copyBtnAction:(UIButton *)btn {
    NSInteger index = btn.tag - 100;
    UIImage *image = [self screenCaptureShotView:self.dropView];
    if (self.clickBlock) {
        self.clickBlock(index,image);
    }
    [self hidden];
}

-(void)show {

    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo([UIApplication sharedApplication].keyWindow);
    }];
    self.hidden = NO;
    self.dropView.alpha = 0;
    [self.backgroundView setCornerOnTopRadius:30];
    self.backgroundView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 140 + [STAppEnvs shareInstance].safeAreaBottomHeight);
    [UIView animateWithDuration:0.35 animations:^{
        self.dropView.alpha = 1;
        self.backgroundView.frame = CGRectMake(0, ScreenHeight - 140 - [STAppEnvs shareInstance].safeAreaBottomHeight , ScreenWidth, 140 + [STAppEnvs shareInstance].safeAreaBottomHeight);
        self.backgroundColor = HexRGBA(0x000000, 0.3);
    }];
}

-(void)hidden{
    
    [UIView animateWithDuration:0.35 animations:^{
        self.backgroundView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 140 + [STAppEnvs shareInstance].safeAreaBottomHeight);
        self.backgroundColor = [UIColor clearColor];
        self.dropView.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
    
}

@end
