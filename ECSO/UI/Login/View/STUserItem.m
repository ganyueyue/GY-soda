//
//  STUserItem.m
//  ECSO
//
//  Created by YY on 2024/5/29.
//

#import "STUserItem.h"

@implementation STUserItem

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 8;
    self.layer.shadowColor = [UIColor colorWithRed:219/255.0 green:221/255.0 blue:226/255.0 alpha:1.0].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,1);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 10;
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [STFont fontSize:17];
    self.titleLabel.textColor = SXColorMain;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(14);
        make.centerY.equalTo(self);
        make.top.equalTo(self).offset(16);
    }];
    
    self.iconView = [[UIImageView alloc] init];
    [self addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-16);
        make.centerY.equalTo(self);
        make.size.mas_offset(CGSizeMake(6, 11));
    }];
    
    self.iconView.image = [UIImage imageNamed:@"common_arrow"];
}

@end
