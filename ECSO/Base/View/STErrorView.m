//
//  STErrorView.m
//  Swim
//
//  Created by YY on 2022/3/10.
//

#import "STErrorView.h"

@implementation STErrorView

- (void)setup {
    [super setup];
    self.backgroundColor = HexRGB(0xFFFFFF);
    
    UIImageView *iconView = [[UIImageView alloc]init];
    iconView.image = [UIImage imageNamed:@"common_no_network"];
    [self addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_centerY).offset(-50);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"主人！数据开小差啦~";
    titleLabel.textColor = HexRGB(0x333333);
    titleLabel.font = [STFont fontStatus:medium fontSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(iconView.mas_bottom).offset(8);
    }];
    
    UIButton *loadBtn = [[UIButton alloc]init];
    [loadBtn setBackgroundImage:[UIImage gradientImageWithSize:CGSizeMake(152, 40) andColors:@[HexRGB(0x02ABFF),HexRGB(0x0687FA)]] forState:UIControlStateNormal];
    [loadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
    loadBtn.titleLabel.font = [STFont fontStatus:medium fontSize:14];
    [loadBtn setTitleColor:HexRGB(0xFFFFFF) forState:UIControlStateNormal];
    loadBtn.layer.cornerRadius = 20;
    loadBtn.layer.shadowColor = [UIColor colorWithRed:5/255.0 green:136/255.0 blue:250/255.0 alpha:0.21].CGColor;
    loadBtn.layer.shadowOffset = CGSizeMake(0,4);
    loadBtn.layer.shadowOpacity = 1;
    loadBtn.layer.shadowRadius = 10;
    loadBtn.clipsToBounds = true;
    [loadBtn addTarget:self action:@selector(loadAciton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:loadBtn];
    [loadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(152, 40));
        make.top.equalTo(titleLabel.mas_bottom).offset(39);
        make.centerX.equalTo(self);
    }];
    
}

- (void)loadAciton {
    if ([self.delegate respondsToSelector:@selector(touchErrorView:)]) {
        [self.delegate touchErrorView:self];
    }
}

@end
