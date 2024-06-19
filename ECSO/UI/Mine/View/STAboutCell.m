//
//  STAboutCell.m
//  Swim
//
//  Created by YY on 2022/10/26.
//

#import "STAboutCell.h"

@implementation STAboutCell

- (void)setup {
    [super setup];
    
    self.lineEdge = UIEdgeInsetsMake(0, 14, 0, -14);
    self.lineView.backgroundColor = HexRGB(0xF2F2F2);
    self.backgroundColor = HexRGB(0xFFFFFF);
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = [STFont fontSize:13];
    _titleLabel.textColor = HexRGB(0x292F48);
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(14);
        make.top.equalTo(self.contentView).offset(16);
        make.centerY.equalTo(self.contentView);
        make.height.mas_offset(18);
        make.bottom.equalTo(self.contentView).offset(-16);
    }];
    
    UIImageView *iconView = [[UIImageView alloc]init];
    iconView.image = [UIImage imageNamed:@"icon_home_arrow"];
    [self.contentView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-14);
        make.centerY.equalTo(self.contentView);
    }];
    
}

@end
