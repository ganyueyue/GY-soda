//
//  STAppItemViewCell.m
//  Swim
//
//  Created by YY on 2022/3/21.
//

#import "STAppItemViewCell.h"

@interface STAppItemViewCell ()
@end

@implementation STAppItemViewCell

- (void)setup {
    [super setup];
    
    self.iconView = [[UIImageView alloc]init];
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconView.layer.borderColor = HexRGB(0xE6E6E6).CGColor;
    self.iconView.layer.borderWidth = 0.5;
    self.iconView.layer.cornerRadius = 10;
    self.iconView.clipsToBounds = true;
    [self.contentView addSubview:self.iconView];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.leading.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [STFont fontSize:10];
    self.titleLabel.textColor = HexRGB(0x292F48);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.centerX.equalTo(self.contentView);
        make.top.equalTo(self.iconView.mas_bottom).offset(5);
        make.height.mas_offset(15);
        make.bottom.equalTo(self.contentView);
    }];
    
}

- (void)setWebInfo:(STWebInfo *)webInfo {
//    if (_webInfo == webInfo) {
//        return;
//    }
    _webInfo = webInfo;
    [self.iconView sx_setImagePlaceholdWithURL:_webInfo.icon];
    self.titleLabel.text = _webInfo.title;
}

@end
