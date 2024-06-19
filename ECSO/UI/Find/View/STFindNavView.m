//
//  STFindNavView.m
//  ECSO
//
//  Created by YY on 2024/5/23.
//

#import "STFindNavView.h"

@interface STFindNavView()
@property (nonatomic, strong)UILabel *titleLabel;
@end

@implementation STFindNavView

- (void)setup {
    [super setup];
    
    self.backgroundColor = HexRGB(0xF5F6F7);
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"发现";
    self.titleLabel.textColor = SXColorMain;
    self.titleLabel.font = [STFont fontStatus:medium fontSize:20];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.bottom.equalTo(self).offset(-14);
    }];
    
    UIButton *addBtn = [[UIButton alloc]init];
    addBtn.tag = 100;
    [addBtn setImage:[UIImage imageNamed:@"find_add"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self.titleLabel);
        make.size.mas_offset(CGSizeMake(25, 25));
    }];
    
    UIButton *scanBtn = [[UIButton alloc]init];
    scanBtn.tag = 101;
    [scanBtn setImage:[UIImage imageNamed:@"find_scan"] forState:UIControlStateNormal];
    [scanBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:scanBtn];
    [scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(addBtn.mas_leading).offset(-7);
        make.centerY.equalTo(self.titleLabel);
        make.size.mas_offset(CGSizeMake(25, 25));
    }];
}

- (void)buttonAction:(UIButton *)sender {
    NSInteger index = sender.tag - 100;
    if (self.clickBlock) {
        self.clickBlock(index);
    }
}

@end
