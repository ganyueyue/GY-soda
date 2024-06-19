//
//  STCommonViewCell.m
//  Swim
//
//  Created by YY on 2022/3/14.
//

#import "STCommonViewCell.h"

@implementation STCommonViewCell

- (void)setup {
    [super setup];
    
    self.lineHeight = 0;
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.iconView = [[UIImageView alloc]init];
    self.iconView.contentMode = UIViewContentModeCenter;
    self.iconView.clipsToBounds = true;
    [self.contentView addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.contentView);
        make.size.mas_offset(CGSizeMake(20, 20));
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [STFont fontSize:14];
    self.titleLabel.textColor = HexRGB(0x292F48);
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconView.mas_trailing).offset(5);
        make.centerY.equalTo(self.iconView);
    }];
}
@end
