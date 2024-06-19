//
//  STVisitCell.m
//  ECSO
//
//  Created by YY on 2024/5/24.
//

#import "STVisitCell.h"

@interface STVisitCell()
@property (nonatomic, strong)UIImageView *iconView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *descLabel;
@end

@implementation STVisitCell

- (void)setup {
    [super setup];
    
    self.lineHeight = 0;
    
    UIView *backgroundView = [[UIView alloc]init];
    backgroundView.backgroundColor = HexRGB(0xFCFCFC);
    backgroundView.layer.cornerRadius = 8;
    backgroundView.layer.borderColor = HexRGB(0xD8D8D8).CGColor;
    backgroundView.layer.borderWidth = 0.5;
    [self.contentView addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(15);
        make.trailing.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.contentView).offset(5);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
    
    self.iconView = [[UIImageView alloc] init];
    self.iconView.layer.cornerRadius = 5;
//    self.iconView.layer.borderColor = HexRGB(0xD5D5D5).CGColor;
//    self.iconView.layer.borderWidth = 0.5;
    [backgroundView addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(backgroundView).offset(10);
        make.top.equalTo(backgroundView).offset(15);
        make.width.height.mas_offset(40);
        make.bottom.equalTo(backgroundView).offset(-15);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = HexRGB(0x606060);
    self.titleLabel.font = [STFont fontSize:12];
    [backgroundView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconView.mas_trailing).offset(10);
        make.trailing.equalTo(backgroundView).offset(-30);
        make.bottom.equalTo(backgroundView.mas_centerY).offset(-1);
    }];
    
    self.descLabel = [[UILabel alloc]init];
    self.descLabel.textColor = HexRGB(0x606060);
    self.descLabel.font = [STFont fontSize:12];
    [backgroundView addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconView.mas_trailing).offset(10);
        make.trailing.equalTo(backgroundView).offset(-30);
        make.top.equalTo(backgroundView.mas_centerY).offset(1);
    }];
    
}

- (void)setWebInfo:(STWebInfo *)webInfo {
    _webInfo = webInfo;
    [self.iconView sx_setImagePlaceholdWithURL:_webInfo.icon];
    
    self.titleLabel.text = _webInfo.title;
    self.descLabel.text = _webInfo.url;
}

@end
