//
//  STShareItemCell.m
//  Swim
//
//  Created by YY on 2022/3/30.
//

#import "STShareItemCell.h"

@interface STShareItemCell ()
@property (nonatomic, strong)UIImageView *iconView;
@property (nonatomic, strong)UILabel *titleLabel;
@end

@implementation STShareItemCell

- (void)setup {
    [super setup];
    
    self.iconView = [[UIImageView alloc]init];
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(10);
        make.size.mas_offset(CGSizeMake(40, 40));
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [STFont fontSize:12];
    self.titleLabel.textColor = HexRGB(0x333333);
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.iconView.mas_bottom).offset(8);
    }];
}

- (void)setPlatform:(STSharePlatform *)platform {
    _platform = platform;
    self.titleLabel.text = _platform.name;
    
    if ([NSString checkUrlWithString:_platform.icon]) {
        [self.iconView sx_setImagePlaceholdWithURL:_platform.icon];
    } else if ([_platform.icon containsString:@"res@"]) {
        NSString *iconString = [_platform.icon stringByReplacingOccurrencesOfString:@"res@" withString:@""];
        self.iconView.image = [UIImage imageNamed:iconString];
    } else {
        self.iconView.image = [UIImage imageNamed:_platform.icon];
    }
    
}


@end
