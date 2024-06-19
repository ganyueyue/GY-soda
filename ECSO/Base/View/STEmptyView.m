//
//  STEmptyView.m
//  Swim
//
//  Created by YY on 2022/3/10.
//

#import "STEmptyView.h"

@implementation STEmptyView


- (void)setup {
    [super setup];
    _iconView = [[UIImageView alloc]init];
    _iconView.image = [UIImage imageNamed:@"icon_collect_empty"];
    [self addSubview:_iconView];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-40);
    }];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = [STFont fontSize:12];
    _titleLabel.textColor = HexRGB(0x888888);
    _titleLabel.numberOfLines = 0;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"暂无数据";
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.leading.equalTo(self).offset(30).priorityHigh();
        make.top.equalTo(self.iconView.mas_bottom).offset(15);
    }];
}

@end
