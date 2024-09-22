//
//  STCustomNavView.m
//  ECSO
//
//  Created by YY on 2024/5/24.
//

#import "STCustomNavView.h"

@implementation STCustomNavView


- (void)setup {
    [super setup];
    
    UIButton *backBtn = [[UIButton alloc]init];
    [backBtn setImage:[UIImage imageNamed:@"custom_back"] forState:UIControlStateNormal];
    backBtn.tag = 100;
    [backBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    self.backBtn = backBtn;
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(3);
        make.bottom.equalTo(self).offset(-5);
        make.size.mas_offset(CGSizeMake(40, 40));
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [STFont fontStatus:medium fontSize:20];
    self.titleLabel.textColor = SXColorMain;
    self.titleLabel.text = @"修改昵称".string;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(backBtn.mas_trailing).offset(3);
        make.centerY.equalTo(backBtn);
    }];
    
    self.saveBtn = [[UIButton alloc]init];
    [self.saveBtn setTitle:@"保存".string forState:UIControlStateNormal];
    [self.saveBtn setTitleColor:HexRGB(0x606060) forState:UIControlStateNormal];
    self.saveBtn.titleLabel.font = [STFont fontSize:16];
    self.saveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.saveBtn.tag = 101;
    [self.saveBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.saveBtn];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(backBtn);
        make.size.mas_offset(CGSizeMake(70, 30));
    }];
}

- (void)buttonAction:(UIButton *)sender {
    NSInteger index = sender.tag - 100;
    if (self.clickBlock) {
        self.clickBlock(index);
    }
}

@end
