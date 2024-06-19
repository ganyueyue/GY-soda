//
//  STPwdPopupView.m
//  Swim
//
//  Created by YY on 2022/3/30.
//

#import "STPwdPopupView.h"

@interface STPwdPopupView ()
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation STPwdPopupView

- (void)setup {
    [super setup];
        
    [self addSubview:self.backgroundView];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self);
        make.height.mas_offset(140 + [STAppEnvs shareInstance].safeAreaBottomHeight);
    }];
    
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(40);
        make.top.equalTo(self).offset([STAppEnvs shareInstance].statusBarHeight);
        make.trailing.equalTo(self).offset(-40);
        make.bottom.equalTo(self.backgroundView.mas_top);
    }];
    
    [self.scrollView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.width.equalTo(self.scrollView);
    }];
    
    UITapGestureRecognizer *closeBtn = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidden)];
    [self addGestureRecognizer:closeBtn];

}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.hidden = true;
        _scrollView.bounces = false;
        _scrollView.userInteractionEnabled = true;
        _scrollView.showsVerticalScrollIndicator = false;
        _scrollView.clipsToBounds = true;
    }
    return _scrollView;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]init];
        _imageView.hidden = true;
        _imageView.userInteractionEnabled = false;
        _imageView.clipsToBounds = true;
    }
    return _imageView;
}

- (void)createSubViewPlatform:(STSharePlatform *)info withImageUrl:(NSString *)imageUrl withTextHidden:(BOOL)isHidden {
    
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
    
    if (!isHidden) {
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
        [copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageBtn.mas_bottom).offset(20);
            make.centerX.equalTo(self.backgroundView);
            make.leading.equalTo(self.backgroundView).offset(20);
            make.height.mas_offset(44);
        }];
    }
    
    [SVProgressHelper showHUD];
    [self getImageUrl:imageUrl];
}


- (void)getImageUrl:(NSString *)imageUrl {
    if ([NSString checkUrlWithString:imageUrl] == false) {
        [SVProgressHelper dismissHUD];
        [SVProgressHelper dismissWithMsg:@"分享链接有误"];
        [self hidden];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil options:SDWebImageRetryFailed|SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image != nil){
            [SVProgressHelper dismissHUD];
            weakSelf.imageView.backgroundColor = [UIColor clearColor];
            weakSelf.imageView.image = image;
            CGSize size = CGSizeMake(ScreenWidth - 80, floor(image.size.height / (image.size.width / (ScreenWidth - 80))));
            weakSelf.scrollView.contentSize = size;
            if (size.height >= ScreenHeight - 140 - [STAppEnvs shareInstance].safeAreaBottomHeight - [STAppEnvs shareInstance].statusBarHeight) {
                weakSelf.imageView.contentMode = UIViewContentModeScaleAspectFill;
                [weakSelf.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(weakSelf.scrollView);
                    make.size.mas_equalTo(size);
                }];
            } else {
                weakSelf.imageView.contentMode = UIViewContentModeScaleAspectFit;
                [weakSelf.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.leading.trailing.centerY.equalTo(weakSelf.scrollView);
                    make.size.mas_equalTo(size);
                }];
            }
        } else {
            [self getImageUrl:imageUrl];
        }
    }];
}

- (UIView *)backgroundView {
    if (_backgroundView == nil) {
        _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 140 + [STAppEnvs shareInstance].safeAreaBottomHeight)];
        _backgroundView.backgroundColor = HexRGB(0xF8F8F8);
        [_backgroundView setCornerOnTopRadius:20];
    }
    return _backgroundView;
}

- (void)copyBtnAction:(UIButton *)btn {
    NSInteger index = btn.tag - 100;
    if (self.clickBlock) {
        self.clickBlock(index);
    }
    [self hidden];
}

-(void)show {

    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo([UIApplication sharedApplication].keyWindow);
    }];
    self.hidden = NO;
    self.scrollView.hidden = true;
    self.imageView.hidden = true;
    [self.backgroundView setCornerOnTopRadius:30];
    self.backgroundView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 140 + [STAppEnvs shareInstance].safeAreaBottomHeight);
    [UIView animateWithDuration:0.35 animations:^{
        self.imageView.hidden = false;
        self.scrollView.hidden = false;
        self.backgroundView.frame = CGRectMake(0, ScreenHeight - 140 - [STAppEnvs shareInstance].safeAreaBottomHeight , ScreenWidth, 140 + [STAppEnvs shareInstance].safeAreaBottomHeight);
        self.backgroundColor = HexRGBA(0x000000, 0.3);
    }];
}


-(void)hidden{
    [SVProgressHelper dismissHUD];
    [UIView animateWithDuration:0.35 animations:^{
        self.backgroundView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 140 + [STAppEnvs shareInstance].safeAreaBottomHeight);
        self.backgroundColor = [UIColor clearColor];
        self.scrollView.hidden = true;
        self.imageView.hidden = true;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
    
}

@end
