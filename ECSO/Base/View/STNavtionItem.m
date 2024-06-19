//
//  STNavtionItem.m
//  Swim
//
//  Created by GanYue on 2022/3/13.
//

#import "STNavtionItem.h"

@implementation STNavtionItem

- (void)setup {
    [super setup];
    
    UIButton *closeBtn = [[UIButton alloc]init];
    [closeBtn setImage:[UIImage imageNamed:@"icon_pop_close"] forState:UIControlStateNormal];
    closeBtn.tag = 100;
    [closeBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.bottom.equalTo(self);
        make.leading.equalTo(self.mas_centerX);
    }];
    
    UIButton *moreBtn = [[UIButton alloc]init];
    [moreBtn setImage:[UIImage imageNamed:@"icon_pop_more"] forState:UIControlStateNormal];
    moreBtn.tag = 101;
    [moreBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.bottom.equalTo(self);
        make.trailing.equalTo(self.mas_centerX);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = HexRGB(0xe6e6e6);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_offset(CGSizeMake(0.5, 18));
    }];
}

- (void)buttonAction:(UIButton *)btn {
    NSInteger index = btn.tag - 100;
    if (self.clickBlock) {
        self.clickBlock(index);
    }
}

@end
